'''
Retreives the ID for an audio device.
'''

import subprocess
import argparse

class Type:
  DAC = 'dac'
  MIC = 'mic'
  AUDEZE = 'audeze'
  AUDEZE_MIC = 'audeze_mic'
  CAMERA_MIC = 'camera_mic'
  SONOS = 'sonos'

MAPPING = {
  Type.DAC: 'Speakers (DX3 Pro+)',
  Type.AUDEZE: 'Speakers (Game-Audeze Maxwell)',
  Type.AUDEZE_MIC: 'Microphone (Chat-Audeze Maxwell)',
  Type.CAMERA_MIC: 'Microphone (C922 Pro Stream Webcam)',
  Type.MIC: 'Microphone (Realtek(R) Audio)',
  Type.SONOS: 'LG TV SSCR2 (NVIDIA High Definition Audio)',
}

parser = argparse.ArgumentParser()
parser.add_argument('--sound_type', '-t', required=True, choices=MAPPING.keys())
args = parser.parse_args()

if args.sound_type in MAPPING:
    with subprocess.Popen('powershell get-audiodevice -list',
                          shell=True, stdout=subprocess.PIPE,stderr=subprocess.PIPE) as process:
        cmd_output = process.stdout.read().decode('utf-8')

        for attr in cmd_output.split('Index                : '):
            SECTION = ' '.join(attr.strip().split()).strip()

            if 'ID' in SECTION:
                dev_id = SECTION.split('ID : ')[1].split()[0]

                if MAPPING[args.sound_type] in SECTION and (args.sound_type != 'dac' or\
                    (args.sound_type == 'dac' and 'Type : Recording' not in SECTION)):
                    dev_id = SECTION.split('ID : ')[1].split()[0]
                    print(dev_id)
