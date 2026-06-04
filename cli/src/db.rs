use rusqlite::{Connection, params};
use std::process::Command;

const SCHEMA: &str = r#"
CREATE TABLE IF NOT EXISTS intake (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    input_type TEXT NOT NULL,
    summary TEXT NOT NULL,
    lane TEXT NOT NULL CHECK(lane IN ('tiny', 'normal', 'high-risk')),
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS story (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    lane TEXT NOT NULL CHECK(lane IN ('tiny', 'normal', 'high-risk')),
    status TEXT NOT NULL DEFAULT 'planned' CHECK(status IN ('planned', 'in-progress', 'done', 'blocked')),
    unit_proof INTEGER DEFAULT 0,
    integration_proof INTEGER DEFAULT 0,
    e2e_proof INTEGER DEFAULT 0,
    platform_proof INTEGER DEFAULT 0,
    verify_command TEXT,
    last_verified_at TEXT,
    last_verified_result TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS decision (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    doc_path TEXT,
    notes TEXT,
    status TEXT NOT NULL DEFAULT 'proposed' CHECK(status IN ('proposed', 'accepted', 'rejected', 'superseded')),
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS trace (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    summary TEXT NOT NULL,
    outcome TEXT NOT NULL CHECK(outcome IN ('success', 'partial', 'blocked', 'failed')),
    story_id TEXT,
    files_changed TEXT,
    decisions TEXT,
    errors TEXT,
    harness_friction TEXT,
    score REAL,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (story_id) REFERENCES story(id)
);

CREATE TABLE IF NOT EXISTS backlog (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    pain TEXT NOT NULL,
    risk TEXT DEFAULT 'tiny' CHECK(risk IN ('tiny', 'normal', 'high-risk')),
    predicted TEXT,
    outcome TEXT,
    status TEXT NOT NULL DEFAULT 'open' CHECK(status IN ('open', 'closed')),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    closed_at TEXT
);

CREATE TABLE IF NOT EXISTS session (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS knowledge (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ktype TEXT NOT NULL CHECK(ktype IN ('pattern', 'gotcha', 'convention', 'decision')),
    content TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);
"#;

fn open_db() -> Result<Connection, Box<dyn std::error::Error>> {
    let conn = Connection::open("harness.db")?;
    conn.execute_batch("PRAGMA journal_mode=WAL; PRAGMA foreign_keys=ON;")?;
    Ok(conn)
}

pub fn init_db() -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    conn.execute_batch(SCHEMA)?;
    println!("✅ harness.db initialized");
    Ok(())
}

pub fn record_intake(input_type: &str, summary: &str, lane: &str) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    conn.execute(
        "INSERT INTO intake (input_type, summary, lane) VALUES (?1, ?2, ?3)",
        params![input_type, summary, lane],
    )?;
    let id = conn.last_insert_rowid();
    println!("📥 Intake #{} recorded: lane={}, type={}", id, lane, input_type);
    Ok(())
}

pub fn story_add(id: &str, title: &str, lane: &str, verify: Option<&str>) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    conn.execute(
        "INSERT INTO story (id, title, lane, verify_command) VALUES (?1, ?2, ?3, ?4)",
        params![id, title, lane, verify],
    )?;
    println!("📋 Story {} added: lane={}", id, lane);
    Ok(())
}

pub fn story_update(
    id: &str, status: Option<&str>, unit: Option<i32>, integration: Option<i32>,
    e2e: Option<i32>, platform: Option<i32>, verify: Option<&str>,
) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    let mut updates = vec!["updated_at = datetime('now')".to_string()];
    let mut values: Vec<Box<dyn rusqlite::types::ToSql>> = vec![];

    if let Some(s) = status {
        updates.push(format!("status = ?{}", values.len() + 1));
        values.push(Box::new(s.to_string()));
    }
    if let Some(v) = unit {
        updates.push(format!("unit_proof = ?{}", values.len() + 1));
        values.push(Box::new(v));
    }
    if let Some(v) = integration {
        updates.push(format!("integration_proof = ?{}", values.len() + 1));
        values.push(Box::new(v));
    }
    if let Some(v) = e2e {
        updates.push(format!("e2e_proof = ?{}", values.len() + 1));
        values.push(Box::new(v));
    }
    if let Some(v) = platform {
        updates.push(format!("platform_proof = ?{}", values.len() + 1));
        values.push(Box::new(v));
    }
    if let Some(v) = verify {
        updates.push(format!("verify_command = ?{}", values.len() + 1));
        values.push(Box::new(v.to_string()));
    }

    let idx = values.len() + 1;
    let sql = format!("UPDATE story SET {} WHERE id = ?{}", updates.join(", "), idx);
    values.push(Box::new(id.to_string()));

    let params_ref: Vec<&dyn rusqlite::types::ToSql> = values.iter().map(|v| v.as_ref()).collect();
    let changed = conn.execute(&sql, params_ref.as_slice())?;
    if changed == 0 {
        return Err(format!("Story {} not found", id).into());
    }
    println!("✏️  Story {} updated", id);
    Ok(())
}

pub fn story_verify(id: &str) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    let cmd: Option<String> = conn.query_row(
        "SELECT verify_command FROM story WHERE id = ?1",
        params![id],
        |row| row.get(0),
    )?;

    let cmd = cmd.ok_or_else(|| format!("Story {} has no verify command", id))?;
    println!("🔍 Running: {}", cmd);

    let output = Command::new("sh")
        .arg("-c")
        .arg(&cmd)
        .output()?;

    let result = if output.status.success() { "pass" } else { "fail" };
    let now = chrono::Utc::now().format("%Y-%m-%d %H:%M:%S").to_string();

    conn.execute(
        "UPDATE story SET last_verified_at = ?1, last_verified_result = ?2, updated_at = ?1 WHERE id = ?3",
        params![now, result, id],
    )?;

    if output.status.success() {
        println!("✅ Story {} verification: PASS", id);
    } else {
        let stderr = String::from_utf8_lossy(&output.stderr);
        println!("❌ Story {} verification: FAIL\n{}", id, stderr);
        std::process::exit(1);
    }
    Ok(())
}

pub fn decision_add(id: &str, title: &str, doc: Option<&str>, notes: Option<&str>) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    conn.execute(
        "INSERT OR REPLACE INTO decision (id, title, doc_path, notes) VALUES (?1, ?2, ?3, ?4)",
        params![id, title, doc, notes],
    )?;
    println!("📝 Decision {} recorded", id);
    Ok(())
}

pub fn record_trace(
    summary: &str, outcome: &str, story: Option<&str>, files: Option<&str>,
    decisions: Option<&str>, errors: Option<&str>, friction: Option<&str>,
) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;

    // Calculate score based on field completeness
    let mut score: f64 = 2.0; // base for summary + outcome
    if story.is_some() { score += 1.0; }
    if files.is_some() { score += 1.0; }
    if decisions.is_some() { score += 1.0; }
    if friction.is_some() { score += 1.0; }
    let max_score = 6.0;
    let normalized = (score / max_score) * 10.0;

    conn.execute(
        "INSERT INTO trace (summary, outcome, story_id, files_changed, decisions, errors, harness_friction, score)
         VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)",
        params![summary, outcome, story, files, decisions, errors, friction, normalized],
    )?;
    let id = conn.last_insert_rowid();
    println!("📊 Trace #{} recorded: outcome={}, score={:.1}/10", id, outcome, normalized);
    Ok(())
}

pub fn score_trace(id: i64) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    let row = conn.query_row(
        "SELECT summary, outcome, story_id, files_changed, decisions, harness_friction FROM trace WHERE id = ?1",
        params![id],
        |row| {
            Ok((
                row.get::<_, String>(0)?,
                row.get::<_, String>(1)?,
                row.get::<_, Option<String>>(2)?,
                row.get::<_, Option<String>>(3)?,
                row.get::<_, Option<String>>(4)?,
                row.get::<_, Option<String>>(5)?,
            ))
        },
    )?;

    let mut score: f64 = 2.0;
    if row.2.is_some() { score += 1.0; }
    if row.3.is_some() { score += 1.0; }
    if row.4.is_some() { score += 1.0; }
    if row.5.is_some() { score += 1.0; }
    let normalized = (score / 6.0) * 10.0;

    conn.execute("UPDATE trace SET score = ?1 WHERE id = ?2", params![normalized, id])?;
    println!("📊 Trace #{} re-scored: {:.1}/10", id, normalized);
    Ok(())
}

pub fn query_matrix(numeric: bool) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    let mut stmt = conn.prepare(
        "SELECT id, title, lane, status, unit_proof, integration_proof, e2e_proof, platform_proof FROM story ORDER BY id"
    )?;

    let rows = stmt.query_map([], |row| {
        Ok((
            row.get::<_, String>(0)?,
            row.get::<_, String>(1)?,
            row.get::<_, String>(2)?,
            row.get::<_, String>(3)?,
            row.get::<_, i32>(4)?,
            row.get::<_, i32>(5)?,
            row.get::<_, i32>(6)?,
            row.get::<_, i32>(7)?,
        ))
    })?;

    let fmt = |v: i32| -> String {
        if numeric { v.to_string() } else if v == 1 { "yes".into() } else { "no".into() }
    };

    println!("{:<12} {:<30} {:<10} {:<12} {:<6} {:<6} {:<6} {:<6}",
        "ID", "Title", "Lane", "Status", "Unit", "Integ", "E2E", "Plat");
    println!("{}", "-".repeat(88));

    for row in rows {
        let r = row?;
        println!("{:<12} {:<30} {:<10} {:<12} {:<6} {:<6} {:<6} {:<6}",
            r.0, truncate(&r.1, 28), r.2, r.3, fmt(r.4), fmt(r.5), fmt(r.6), fmt(r.7));
    }
    Ok(())
}

pub fn query_stats() -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;

    let total_stories: i64 = conn.query_row("SELECT COUNT(*) FROM story", [], |r| r.get(0))?;
    let done_stories: i64 = conn.query_row("SELECT COUNT(*) FROM story WHERE status = 'done'", [], |r| r.get(0))?;
    let open_stories: i64 = conn.query_row("SELECT COUNT(*) FROM story WHERE status != 'done'", [], |r| r.get(0))?;
    let total_decisions: i64 = conn.query_row("SELECT COUNT(*) FROM decision", [], |r| r.get(0))?;
    let total_traces: i64 = conn.query_row("SELECT COUNT(*) FROM trace", [], |r| r.get(0))?;
    let total_intakes: i64 = conn.query_row("SELECT COUNT(*) FROM intake", [], |r| r.get(0))?;
    let open_backlog: i64 = conn.query_row("SELECT COUNT(*) FROM backlog WHERE status = 'open'", [], |r| r.get(0))?;
    let avg_score: f64 = conn.query_row(
        "SELECT COALESCE(AVG(score), 0) FROM trace WHERE score IS NOT NULL", [], |r| r.get(0)
    )?;

    println!("📊 Project Stats");
    println!("────────────────────────────");
    println!("Stories:    {}/{} done ({} open)", done_stories, total_stories, open_stories);
    println!("Decisions:  {}", total_decisions);
    println!("Traces:     {} (avg score: {:.1}/10)", total_traces, avg_score);
    println!("Intakes:    {}", total_intakes);
    println!("Backlog:    {} open", open_backlog);
    Ok(())
}

pub fn query_backlog(open: bool, closed: bool) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    let filter = if open { "WHERE status = 'open'" }
        else if closed { "WHERE status = 'closed'" }
        else { "" };

    let sql = format!("SELECT id, title, pain, risk, status, predicted, outcome FROM backlog {} ORDER BY id", filter);
    let mut stmt = conn.prepare(&sql)?;
    let rows = stmt.query_map([], |row| {
        Ok((
            row.get::<_, i64>(0)?,
            row.get::<_, String>(1)?,
            row.get::<_, String>(2)?,
            row.get::<_, String>(3)?,
            row.get::<_, String>(4)?,
            row.get::<_, Option<String>>(5)?,
            row.get::<_, Option<String>>(6)?,
        ))
    })?;

    println!("{:<4} {:<25} {:<10} {:<8} {}", "ID", "Title", "Risk", "Status", "Pain");
    println!("{}", "-".repeat(70));
    for row in rows {
        let r = row?;
        println!("{:<4} {:<25} {:<10} {:<8} {}", r.0, truncate(&r.1, 23), r.3, r.4, truncate(&r.2, 30));
    }
    Ok(())
}

pub fn query_friction() -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    let mut stmt = conn.prepare(
        "SELECT id, summary, harness_friction, created_at FROM trace WHERE harness_friction IS NOT NULL ORDER BY id DESC LIMIT 20"
    )?;
    let rows = stmt.query_map([], |row| {
        Ok((
            row.get::<_, i64>(0)?,
            row.get::<_, String>(1)?,
            row.get::<_, String>(2)?,
            row.get::<_, String>(3)?,
        ))
    })?;

    println!("{:<4} {:<20} {:<30} {}", "ID", "Date", "Task", "Friction");
    println!("{}", "-".repeat(74));
    for row in rows {
        let r = row?;
        println!("{:<4} {:<20} {:<30} {}", r.0, truncate(&r.3, 18), truncate(&r.1, 28), truncate(&r.2, 30));
    }
    Ok(())
}

pub fn query_session() -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    let mut stmt = conn.prepare("SELECT key, value, updated_at FROM session ORDER BY key")?;
    let rows = stmt.query_map([], |row| {
        Ok((
            row.get::<_, String>(0)?,
            row.get::<_, String>(1)?,
            row.get::<_, String>(2)?,
        ))
    })?;

    println!("{:<25} {:<40} {}", "Key", "Value", "Updated");
    println!("{}", "-".repeat(80));
    for row in rows {
        let r = row?;
        println!("{:<25} {:<40} {}", r.0, truncate(&r.1, 38), r.2);
    }
    Ok(())
}

pub fn query_traces(limit: i64) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    let mut stmt = conn.prepare(
        "SELECT id, summary, outcome, score, created_at FROM trace ORDER BY id DESC LIMIT ?1"
    )?;
    let rows = stmt.query_map(params![limit], |row| {
        Ok((
            row.get::<_, i64>(0)?,
            row.get::<_, String>(1)?,
            row.get::<_, String>(2)?,
            row.get::<_, Option<f64>>(3)?,
            row.get::<_, String>(4)?,
        ))
    })?;

    println!("{:<4} {:<20} {:<35} {:<10} {}", "ID", "Date", "Summary", "Outcome", "Score");
    println!("{}", "-".repeat(80));
    for row in rows {
        let r = row?;
        let score_str = r.3.map(|s| format!("{:.1}", s)).unwrap_or_else(|| "-".into());
        println!("{:<4} {:<20} {:<35} {:<10} {}", r.0, truncate(&r.4, 18), truncate(&r.1, 33), r.2, score_str);
    }
    Ok(())
}

pub fn session_set(key: &str, value: &str) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    conn.execute(
        "INSERT OR REPLACE INTO session (key, value, updated_at) VALUES (?1, ?2, datetime('now'))",
        params![key, value],
    )?;
    println!("✅ Session: {} = {}", key, value);
    Ok(())
}

pub fn backlog_add(title: &str, pain: &str, risk: Option<&str>, predicted: Option<&str>) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    let risk = risk.unwrap_or("tiny");
    conn.execute(
        "INSERT INTO backlog (title, pain, risk, predicted) VALUES (?1, ?2, ?3, ?4)",
        params![title, pain, risk, predicted],
    )?;
    let id = conn.last_insert_rowid();
    println!("📌 Backlog #{} added: {}", id, title);
    Ok(())
}

pub fn backlog_close(id: i64, outcome: &str) -> Result<(), Box<dyn std::error::Error>> {
    let conn = open_db()?;
    let changed = conn.execute(
        "UPDATE backlog SET status = 'closed', outcome = ?1, closed_at = datetime('now') WHERE id = ?2",
        params![outcome, id],
    )?;
    if changed == 0 {
        return Err(format!("Backlog #{} not found", id).into());
    }
    println!("✅ Backlog #{} closed", id);
    Ok(())
}

fn truncate(s: &str, max: usize) -> String {
    if s.len() <= max { s.to_string() }
    else { format!("{}…", &s[..max-1]) }
}
