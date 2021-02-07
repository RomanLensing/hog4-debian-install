# hog4-debian-install

This script let you install the Hog4 PC Software on any PC running Debian 9.

# Introductions
- Install Debian 9 without graphical environment (you can get it from debian.org)
- Login with your root account (created during installation)
- Start the script with this command: "wget -O - https://raw.githubusercontent.com/RomanLensing/hog4-debian-install/0.0.1/hog4-install.sh | /bin/sh" (without quotes)

# Process
- Downloads ISO image from etcconnect
- Extracts everything it needs from the image
- Installs most of needed software
- reboots
- After the graphical enviroment is started the rest gets installed and the network gets configured
- reboots
- Ready to go!

# Limitations
This script doesn't take care of your hardware setup. If for example your Touchscreen isn't working during the debian installation, it probably won't work after this script. Same for all other hardware.
