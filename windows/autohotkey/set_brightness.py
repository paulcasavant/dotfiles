import sys
from subprocess import Popen, PIPE

STEP_SIZE = 10

new_brightess = None
current_brightness = Popen(['C:\\Program Files\\LGTV Companion\\LGTVcli.exe', '-ok', 'backlight',
                            '-get_system_settings', 'picture', '[\"backlight\"]'], stdout=PIPE,
                           stderr=PIPE)

current_brightness = current_brightness.communicate()[0]
current_brightness = current_brightness.decode('utf-8')
current_brightness = current_brightness.strip()
current_brightness = int(current_brightness)

if 'increase' in sys.argv[1]:
    new_brightess = current_brightness + (1 * STEP_SIZE)
    Popen(['C:\\Program Files\\LGTV Companion\\LGTVcli.exe', '-backlight', str(new_brightess)], stdout=PIPE, stderr=PIPE)
elif 'decrease' in sys.argv[1]:
    new_brightess = current_brightness - (1 * STEP_SIZE)
    Popen(['C:\\Program Files\\LGTV Companion\\LGTVcli.exe', '-backlight', str(new_brightess)], stdout=PIPE, stderr=PIPE)

print(f'Current Brightness: {current_brightness}')
