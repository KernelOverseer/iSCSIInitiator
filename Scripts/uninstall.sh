#! /bin/bash

# Define targets
DAEMON=iscsid
TOOL=iscsictl
KEXT=iSCSIInitiator.kext
FRAMEWORK=iSCSI.framework

# Get minor version of the OS
OSX_MINOR_VER=$(sw_vers -productVersion | awk -F '.' '{print $2}')

# Minor version of OS X Mavericks
OSX_MAVERICKS_MINOR_VER="9"

if [ "$OSX_MINOR_VER" -ge "$OSX_MAVERICKS_MINOR_VER" ]; then
    KEXT_DST=/Library/Extensions
else
    KEXT_DST=/System/Library/Extensions
fi

# Stop, unload and remove launch daemon
sudo launchctl stop /Library/LaunchDaemons/com.github.iscsi-osx.iscsid
sudo launchctl unload /Library/LaunchDaemons/com.github.iscsi-osx.iscsid.plist
sudo rm -f /Library/LaunchDaemons/com.github.iscsi-osx.iscsid.plist
sudo rm -f /usr/sbin/$DAEMON # Old location
sudo rm -f /Library/PrivilegedHelperTools/$DAEMON

# Unload & remove kernel extension
sudo kextunload $KEXT_DST/$KEXT
sudo rm -f -R $KEXT_DST/$KEXT

# Remove user tools
sudo rm -f /usr/bin/$TOOL # Old location
sudo rm -f /usr/local/bin/$TOOL

# Remove framework
sudo rm -R /Library/Frameworks/$FRAMEWORK

# Remove man pages
sudo rm -f /usr/share/man/man8/iscsictl.8
sudo rm -f /usr/share/man/man8/iscsid.8