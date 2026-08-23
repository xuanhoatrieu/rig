use std::path::Path;
use std::process::Command;

pub fn update_rig(dry_run: bool) -> Result<(), Box<dyn std::error::Error>> {
    let current_version = env!("CARGO_PKG_VERSION");
    println!("🚀 Rig Self-Update (Current version: v{})", current_version);
    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    if dry_run {
        println!("🔍 [Dry-Run] Checking for latest release from GitHub...");
        // Check latest version string via curl/wget or powershell
        let check_cmd = if cfg!(target_os = "windows") {
            Command::new("powershell")
                .arg("-NoProfile")
                .arg("-Command")
                .arg("(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/xuanhoatrieu/rig/main/VERSION' -UseBasicParsing).Content.Trim()")
                .output()
        } else {
            Command::new("curl")
                .arg("-fsSL")
                .arg("https://raw.githubusercontent.com/xuanhoatrieu/rig/main/VERSION")
                .output()
        };

        match check_cmd {
            Ok(out) if out.status.success() => {
                let remote_ver = String::from_utf8_lossy(&out.stdout).trim().to_string();
                if !remote_ver.is_empty() {
                    println!("📡 Latest upstream version: v{}", remote_ver);
                    if remote_ver == current_version {
                        println!(
                            "✅ You are already on the latest version (v{}).",
                            current_version
                        );
                    } else {
                        println!(
                            "✨ A newer version (v{}) is available! Run 'rig update' to apply.",
                            remote_ver
                        );
                    }
                    return Ok(());
                }
            }
            _ => {
                println!("⚠️  Could not fetch remote version tag. You can still run 'rig update' directly.");
            }
        }
        return Ok(());
    }

    println!("📦 Fetching and applying latest Rig update...");

    let status = if cfg!(target_os = "windows") {
        Command::new("powershell")
            .arg("-NoProfile")
            .arg("-Command")
            .arg("iex \"& { $(irm https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.ps1) }\"")
            .status()?
    } else {
        let cmd =
            "curl -fsSL https://raw.githubusercontent.com/xuanhoatrieu/rig/main/install.sh | bash";
        Command::new("bash").arg("-c").arg(cmd).status()?
    };

    if !status.success() {
        return Err(
            "Update execution failed. Please check your network connection or permissions.".into(),
        );
    }

    println!("\n🎉 Rig update completed successfully!");

    // If current folder has a harness project, run doctor
    if Path::new("harness.db").exists() {
        println!("\n🔍 Running project health check after update...");
        let _ = crate::db::doctor();
    }

    Ok(())
}
