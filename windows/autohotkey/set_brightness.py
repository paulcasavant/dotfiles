import sys
import re
from subprocess import Popen, PIPE
from pathlib import Path

STEP_SIZE = 10

# === 1. Read LGTV_CLI_PATH from config.ahk ===
config_path = Path("config.ahk")
if not config_path.exists():
    print("❌ config.ahk not found.")
    sys.exit(1)

config_content = config_path.read_text(encoding="utf-8")
match = re.search(r'LGTV_CLI_PATH\s*:=\s*"(.*?)"', config_content)
if not match:
    print("❌ LGTV_CLI_PATH not found in config.ahk.")
    sys.exit(1)

lgtv_cli_path = match.group(1)

# === 2. Get current brightness ===
get_proc = Popen([
    lgtv_cli_path, '-ok', 'backlight',
    '-get_system_settings', 'picture', '[\"backlight\"]'
], stdout=PIPE, stderr=PIPE)

stdout, _ = get_proc.communicate()
try:
    current_brightness = int(stdout.decode('utf-8').strip().strip('"'))
except ValueError:
    print(f"❌ Failed to parse brightness value: {stdout}")
    sys.exit(1)

# === 3. Adjust brightness based on argument ===
new_brightness = current_brightness  # default if no change
if len(sys.argv) > 1:
    arg = sys.argv[1].lower()
    if 'increase' in arg:
        new_brightness = min(100, current_brightness + STEP_SIZE)
    elif 'decrease' in arg:
        new_brightness = max(0, current_brightness - STEP_SIZE)

    if new_brightness != current_brightness:
        Popen([lgtv_cli_path, '-backlight', str(new_brightness)], stdout=PIPE, stderr=PIPE)

print(f'Brightness: {current_brightness} → {new_brightness}')
