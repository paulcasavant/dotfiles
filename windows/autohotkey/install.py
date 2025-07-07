import ctypes
import sys
import re
import subprocess
import os
from pathlib import Path

# === 0. Require admin privileges ===
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

if not is_admin():
    print("❌ This script must be run as Administrator.")
    sys.exit(1)

# === 1. Install PowerShell module: AudioDeviceCmdlets ===
print("=" * 60)
print("🔈 Installing PowerShell module: AudioDeviceCmdlets...")
print("=" * 60)

try:
    subprocess.run([
        "powershell", "-Command",
        "if (-not (Get-Module -ListAvailable -Name AudioDeviceCmdlets)) { Install-Module -Name AudioDeviceCmdlets -Force -Scope AllUsers -AllowClobber }"
    ], check=True)
    print("✅ AudioDeviceCmdlets installed.")
except subprocess.CalledProcessError as e:
    print(f"❌ Failed to install AudioDeviceCmdlets: {e}")
    sys.exit(1)

# === 2. Install Python dependencies ===
print("=" * 60)
print("📦 Installing Python dependencies...")
print("=" * 60)

try:
    import soco_cli  # noqa: F401
    print("✅ soco-cli is already installed.")
except ImportError:
    print("📦 soco-cli not found. Installing via pip...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "soco-cli"])
    print("✅ soco-cli installed successfully.")

# === 2. Begin config.ahk generation ===
print("\n" + "=" * 60)
print("🔧 Starting config.ahk generation...")
print("=" * 60 + "\n")

template_path = Path("config.ahk.template")
output_path = Path("config.ahk")

template_content = template_path.read_text(encoding='utf-8')

pattern = re.compile(r'^(?P<key>\w+)\s*:=\s*(?P<value>".*?"|[^"\r\n]+)', re.MULTILINE)
variables = {match.group("key"): match.group("value") for match in pattern.finditer(template_content)}

def is_likely_path(key: str, val: str) -> bool:
    return 'PATH' in key.upper()

def path_exists(val: str) -> bool:
    HOME_VAR = "$HOME"

    val = val.strip('"')

    if HOME_VAR in val:
        home = os.path.expanduser("~")
        val = val.replace(HOME_VAR, home)
        
    val = os.path.expandvars(val)
    val = os.path.expanduser(val)
    return Path(val).exists()

# === 3. Prompt for needed changes ===
for key, value in variables.items():
    prompt_user = False
    reason = ""
    allow_recheck = False

    if is_likely_path(key, value) and not path_exists(value):
        prompt_user = True
        reason = "⚠️  Path does not exist"
        allow_recheck = True
    elif key.upper().endswith('_HDMI_NUMBER'):
        prompt_user = True
        reason = "⚙️  Needs confirmation"

    while True:
        if prompt_user:
            print(f"{reason}: {key} = {value}")
            if allow_recheck:
                user_input = input("Enter new value (Enter to keep, R to recheck): ").strip()
                if user_input.lower() == 'r':
                    if not is_likely_path(key, value) or path_exists(value):
                        print("✅ Path now exists.")
                        break
                    else:
                        print("⚠️  Still not found. Please install the program or change the path.")
                        continue
            else:
                user_input = input("Enter new value (or press Enter to keep): ").strip()

            if user_input:
                if value.startswith('"') and not user_input.startswith('"'):
                    user_input = f'"{user_input}"'
                value = user_input
                variables[key] = value
            break
        else:
            print(f"✅ {key} = {value} (OK)")
            break

# === 4. Replace in template safely ===
for key, value in variables.items():
    assign_pattern = re.compile(rf'^{key}\s*:=\s*.*$', re.MULTILINE)
    template_content = assign_pattern.sub(lambda m: f'{key} := {value}', template_content)

# === 5. Write final config ===
output_path.write_text(template_content, encoding='utf-8')
print(f"\n✅ config.ahk successfully generated at: {output_path.resolve()}")

# === 6. XML Generation ===
print("=" * 60)
print("📄 Writing Task Scheduler XML from embedded template...")
print("=" * 60)

config_ahk_path = Path("config.ahk")
ahk_path = None
for line in config_ahk_path.read_text(encoding='utf-8').splitlines():
    if line.strip().startswith("AHK_PATH"):
        match = re.search(r'AHK_PATH\s*:=\s*["\']?(.*?)["\']?$', line.strip())
        if match:
            ahk_path = match.group(1)
            break

if not ahk_path or not Path(ahk_path).exists():
    print(f"❌ AHK_PATH from config.ahk is invalid or missing: {ahk_path}")
    sys.exit(1)

init_ahk_path = Path("init.ahk").resolve()
xml_output_path = Path("InitAHK_Script_Startup.generated.xml")

xml_template = f'''<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <Triggers>
    <LogonTrigger>
      <Enabled>true</Enabled>
    </LogonTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>{ahk_path}</Command>
      <Arguments>{init_ahk_path}</Arguments>
    </Exec>
  </Actions>
</Task>
'''

xml_output_path.write_text(xml_template, encoding="utf-16")
print(f"✅ Task Scheduler XML written to: {xml_output_path.resolve()}")

# === 7. Schedule Task using XML ===
print("=" * 60)
print("📅 Importing Task Scheduler XML...")
print("=" * 60)

task_name = "InitAHK_Script_Startup"
try:
    subprocess.run([
        "schtasks", "/Create", "/TN", task_name,
        "/XML", str(xml_output_path),
        "/F"
    ], check=True)
    print(f"✅ Scheduled task '{task_name}' created from XML.")
except subprocess.CalledProcessError as e:
    print(f"❌ Failed to import scheduled task: {e}")
