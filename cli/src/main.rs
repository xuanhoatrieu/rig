use clap::{Parser, Subcommand};

mod db;

#[derive(Parser)]
#[command(
    name = "rig",
    version,
    about = "Harness-Core workflow framework CLI v5.1.0"
)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Initialize harness.db in current project
    Init,

    /// Run health check and diagnostic on repository harness
    Doctor,

    /// Show project harness status and statistics
    Status,

    /// Record an intake classification
    Intake {
        #[arg(long)]
        r#type: String,
        #[arg(long)]
        summary: String,
        #[arg(long)]
        lane: String,
    },

    /// Manage durable execution plans
    Plan {
        #[command(subcommand)]
        action: PlanAction,
    },

    /// Manage stories
    Story {
        #[command(subcommand)]
        action: StoryAction,
    },

    /// Manage decision records
    Decision {
        #[command(subcommand)]
        action: DecisionAction,
    },

    /// Record a task trace
    Trace {
        #[arg(long)]
        summary: String,
        #[arg(long)]
        outcome: String,
        #[arg(long)]
        story: Option<String>,
        #[arg(long)]
        files_changed: Option<String>,
        #[arg(long)]
        decisions: Option<String>,
        #[arg(long)]
        errors: Option<String>,
        #[arg(long)]
        harness_friction: Option<String>,
    },

    /// Re-score a specific trace
    ScoreTrace {
        #[arg(long)]
        id: i64,
    },

    /// Query harness data
    Query {
        #[command(subcommand)]
        target: QueryTarget,
    },

    /// Manage session state
    Session {
        #[command(subcommand)]
        action: SessionAction,
    },

    /// Manage backlog items
    Backlog {
        #[command(subcommand)]
        action: BacklogAction,
    },
}

#[derive(Subcommand)]
enum PlanAction {
    /// Create a new durable plan in docs/plans/active/
    Create {
        #[arg(long)]
        title: String,
        #[arg(long)]
        lane: Option<String>,
    },
    /// List active (or all) plans
    List {
        #[arg(long)]
        all: bool,
    },
    /// Complete an active plan and move it to docs/plans/completed/
    Complete {
        #[arg(long)]
        id: String,
        #[arg(long)]
        outcome: Option<String>,
    },
}

#[derive(Subcommand)]
enum StoryAction {
    /// Add a new story
    Add {
        #[arg(long)]
        id: String,
        #[arg(long)]
        title: String,
        #[arg(long)]
        lane: String,
        #[arg(long)]
        verify: Option<String>,
    },
    /// Update an existing story
    Update {
        #[arg(long)]
        id: String,
        #[arg(long)]
        status: Option<String>,
        #[arg(long)]
        unit: Option<i32>,
        #[arg(long)]
        integration: Option<i32>,
        #[arg(long)]
        e2e: Option<i32>,
        #[arg(long)]
        platform: Option<i32>,
        #[arg(long)]
        verify: Option<String>,
    },
    /// Run story verification command
    Verify { id: String },
}

#[derive(Subcommand)]
enum DecisionAction {
    /// Add a decision record
    Add {
        #[arg(long)]
        id: String,
        #[arg(long)]
        title: String,
        #[arg(long)]
        doc: Option<String>,
        #[arg(long)]
        notes: Option<String>,
    },
}

#[derive(Subcommand)]
enum QueryTarget {
    /// Show test matrix
    Matrix {
        #[arg(long)]
        numeric: bool,
    },
    /// Show project stats
    Stats,
    /// Show backlog items
    Backlog {
        #[arg(long)]
        open: bool,
        #[arg(long)]
        closed: bool,
    },
    /// Show friction records
    Friction,
    /// Show session state
    Session,
    /// Show recent traces
    Traces {
        #[arg(long, default_value = "10")]
        limit: i64,
    },
}

#[derive(Subcommand)]
enum SessionAction {
    /// Set a session key-value pair
    Set {
        #[arg(long)]
        key: String,
        #[arg(long)]
        value: String,
    },
}

#[derive(Subcommand)]
enum BacklogAction {
    /// Add a backlog item
    Add {
        #[arg(long)]
        title: String,
        #[arg(long)]
        pain: String,
        #[arg(long)]
        risk: Option<String>,
        #[arg(long)]
        predicted: Option<String>,
    },
    /// Close a backlog item
    Close {
        #[arg(long)]
        id: i64,
        #[arg(long)]
        outcome: String,
    },
}

fn main() {
    let cli = Cli::parse();
    let result = match cli.command {
        Commands::Init => db::init_db(),
        Commands::Doctor => db::doctor(),
        Commands::Status => db::query_stats(),
        Commands::Intake {
            r#type,
            summary,
            lane,
        } => db::record_intake(&r#type, &summary, &lane),
        Commands::Plan { action } => match action {
            PlanAction::Create { title, lane } => db::plan_create(&title, lane.as_deref()),
            PlanAction::List { all } => db::plan_list(all),
            PlanAction::Complete { id, outcome } => db::plan_complete(&id, outcome.as_deref()),
        },
        Commands::Story { action } => match action {
            StoryAction::Add {
                id,
                title,
                lane,
                verify,
            } => db::story_add(&id, &title, &lane, verify.as_deref()),
            StoryAction::Update {
                id,
                status,
                unit,
                integration,
                e2e,
                platform,
                verify,
            } => db::story_update(
                &id,
                status.as_deref(),
                unit,
                integration,
                e2e,
                platform,
                verify.as_deref(),
            ),
            StoryAction::Verify { id } => db::story_verify(&id),
        },
        Commands::Decision { action } => match action {
            DecisionAction::Add {
                id,
                title,
                doc,
                notes,
            } => db::decision_add(&id, &title, doc.as_deref(), notes.as_deref()),
        },
        Commands::Trace {
            summary,
            outcome,
            story,
            files_changed,
            decisions,
            errors,
            harness_friction,
        } => db::record_trace(
            &summary,
            &outcome,
            story.as_deref(),
            files_changed.as_deref(),
            decisions.as_deref(),
            errors.as_deref(),
            harness_friction.as_deref(),
        ),
        Commands::ScoreTrace { id } => db::score_trace(id),
        Commands::Query { target } => match target {
            QueryTarget::Matrix { numeric } => db::query_matrix(numeric),
            QueryTarget::Stats => db::query_stats(),
            QueryTarget::Backlog { open, closed } => db::query_backlog(open, closed),
            QueryTarget::Friction => db::query_friction(),
            QueryTarget::Session => db::query_session(),
            QueryTarget::Traces { limit } => db::query_traces(limit),
        },
        Commands::Session { action } => match action {
            SessionAction::Set { key, value } => db::session_set(&key, &value),
        },
        Commands::Backlog { action } => match action {
            BacklogAction::Add {
                title,
                pain,
                risk,
                predicted,
            } => db::backlog_add(&title, &pain, risk.as_deref(), predicted.as_deref()),
            BacklogAction::Close { id, outcome } => db::backlog_close(id, &outcome),
        },
    };

    if let Err(e) = result {
        eprintln!("Error: {}", e);
        std::process::exit(1);
    }
}
