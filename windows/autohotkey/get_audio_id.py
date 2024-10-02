'''
Retreives the ID for an audio device.
'''

import subprocess
import argparse

DAC_TYPE = 'dac'
ARCTIS_MEDIA_TYPE = 'arctis_media'
ARCTIS_GAMING_TYPE = 'arctis_gaming'
ARCTIS_MIC_TYPE = 'arctis_mic'
SONOS_TYPE = 'sonos'
MIC_TYPE = 'mic'

MAPPING = {
  DAC_TYPE: 'FiiO USB DAC-E10',
  ARCTIS_MEDIA_TYPE: 'SteelSeries Sonar - Media (SteelSeries Sonar Virtual Audio Device)',
  ARCTIS_GAMING_TYPE: 'SteelSeries Sonar - Gaming (SteelSeries Sonar Virtual Audio Device)',
  ARCTIS_MIC_TYPE: 'Microphone (Arctis Nova Pro Wireless)',
  SONOS_TYPE: 'LG TV SSCR2 (NVIDIA High Definition Audio)',
  MIC_TYPE: 'Microphone (High Definition Audio Device)'
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
