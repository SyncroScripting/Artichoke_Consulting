#!/bin/bash

: <<'CommentBlock-StartandEND'

# Script Name:              macOS-DeploySyncroAgent.sh
# Script Author:            Peet McKinney @ Artichoke Consulting

# Changelog                 
2021.05.01                 Initial Checkin                 PJM

#Desription
Will automatically deploy SyncroMSP Agent given customerId policyid shopkey.

CommentBlock-StartandEND

### Usage: ./DeploySyncro.sh [-c customerId] [-p policyid] [-k shopkey] [-u Uninstall_if_Present <*true|false>] [-n noUI <*true|false>]
### Tip: Find customerId, policyid, shopkey in your installer URL.
### https://production.kabutoservices.com/desktop/macos/setup?customerId=11111&policyid=111111&shopkey=11111111111111111111111
customerId="11111"
policyid="111111"
shopkey="11111111111111111111111"
If_Present_Uninstall=false
noUI=true

### Usage ###
usage() 
{
	echo "Usage: $0 [-c customerId] [-p policyid] [-k shopkey] [-u Uninstall_if_Present <*true|false>] [-n noUI <*true|false>]" 1>&2
	echo "Tip: Find customerId, policyid, shopkey in your installer URL." 1>&2
	echo "Tip: Hardcode variables in script if prefered." 1>&2
	
	exit 1
}
### Stupid simple log
LogIt() 
{
	echo $(date +%Y-%m-%d_%H:%M:%S): ${*}
}

### use flags ###
while getopts c:p:k:u:n: option
do
	case "${option}"
		in
		c) customerId=${OPTARG};;
		p) policyid=${OPTARG};;
		k) shopkey=${OPTARG};;
		u) If_Present_Uninstall=${OPTARG};;
		n) noUI=${OPTARG};;
		*) usage;;
	esac
done

### check running as root
if [[ $EUID -ne 0 ]]; then
   echo "Usage: This script must be run as root." 1>&2
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
curl -s -OJ "https://desktop-updates.kabutoservices.com/api/v1/get-installer/macos?customerId=$customerId&policyid=$policyid&shopkey=$shopkey"
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