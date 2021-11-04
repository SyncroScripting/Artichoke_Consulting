#!/bin/bash

: <<'CommentBlock-StartandEND'

# Script Name:              macOS-DeploySyncroAgent.sh
# Script Author:            Peet McKinney @ Artichoke Consulting

# Changelog                 
2021.05.01                 Initial Checkin            			      PJM
2021.11.03                 Updated for Syncro's new token deployment  PJM

#Desription
Will automatically deploy SyncroMSP Agent given deploy token.

CommentBlock-StartandEND

### Usage: ./macOS-DeploySyncroAgent.sh [-t token] [-u Uninstall_if_Present <*true|false>] [-n noUI <*true|false>]
### Tip: Find customerId, policyid, shopkey in your installer URL. 
### Tip: Record your Installer URL: 
### Tip: formatted like this: https://production.kabutoservices.com/desktop/macos/setup?token=12345678-abcd-1234-abcd-1234567890ab


token=
If_Present_Uninstall=true
noUI=true

### Stupid simple log
LogIt() 
{
	echo $(date +%Y-%m-%d_%H:%M:%S): ${*}
}

### Usage ###
usage() 
{
	echo "Usage: $0 
	[-t token <12345678-abcd-1234-abcd-1234567890ab>] 
	[-u Uninstall_if_Present <*true|false>] 
	[-n noUI <*true|false>]" 1>&2
	echo "Tip: Find token in your installer URL." 1>&2
	echo "Tip: Hardcode variables in script if prefered." 1>&2
	
	exit 1
}

### check running as root
if [[ $EUID -ne 0 ]]; then
   echo "Usage: This script must be run as root." 1>&2
   usage
fi

### use flags ###
while getopts t:u:n: option
do
	case "${option}"
		in
		t) token=${OPTARG};;
		u) If_Present_Uninstall=${OPTARG};;
		n) noUI=${OPTARG};;
		*) usage;;
	esac
done

if [ -z "$token" ]; then
   usage
fi

### Uninstall
if ($If_Present_Uninstall eq "true") && [ -f "/Library/Application Support/SyncroMSP/SyncroMSP.app/Contents/MacOS/scripts/uninstall.sh" ]; then
	LogIt "Start: Uninstall SyncroMSP Agent."
	"/Library/Application Support/SyncroMSP/SyncroMSP.app/Contents/MacOS/scripts/uninstall.sh"
	pkgutil --forget "com.syncromsp" 1>&2
	LogIt "End: Uninstall SyncroMSP Agent."
fi
if ($If_Present_Uninstall eq "false") && [ -f "/Library/Application Support/SyncroMSP/SyncroMSP.app/Contents/MacOS/scripts/uninstall.sh" ]; then
	LogIt "Info: SyncroMSP Agent already deployed."
	exit 0
fi
	

#### Suppress UI
if ($noUI eq "true"); then
	LogIt "Disabling Screen Recording entitlement request."
	touch /tmp/syncro-noui
fi

### download and install
TEMP_DIR=$(mktemp -d /tmp/SyncroDeploy-XXXXXXXXXXXXXX)
cd $TEMP_DIR
LogIt "Start: Download SyncroMSP installer package."
curl -s -L -OJ "https://production.kabutoservices.com/desktop/macos/setup?token=$token"
SYNCRO_PKG=$(ls $TEMP_DIR)
LogIt "End: Download SyncroMSP installer package."
LogIt "Start: Installing SyncroMSP installer package - $SYNCRO_PKG."
installer -pkg "$TEMP_DIR/$SYNCRO_PKG" -target / 1>&2
EXIT_CODE=$?
LogIt "END: Installing SyncroMSP installer package - $SYNCRO_PKG."

### Clean Up
LogIt "Start: Removing temporary files."
rm -rf $TEMP_DIR
if ($noUI eq "true"); then
	rm /tmp/syncro-noui
fi

### Exit politely
if [ $EXIT_CODE -eq 0 ]; then
	LogIt "Success: SyncroMSP installed."
	else
	LogIt "ERROR: SyncroMSP not installed correctly Error $EXIT_CODE."
fi
exit $EXIT_CODE