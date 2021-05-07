#!/bin/bash

: <<'CommentBlock-StartandEND'

# Script Name:              macOS-RestartSyncroAgent
# Script Author:            Peet McKinney @ Artichoke Consulting

# Changelog                 
2021.05.06                 Initial Checkin                 PJM

#Desription
Restarts the SyncroMSP v2 Agent. 

CommentBlock-StartandEND

## Static Variables (Must Set)
PrefDomain="consulting.artichoke.RestartSyncroAgent"
ScriptFolder="/Library/Application Support/Artichoke/RestartSyncroAgent"

##Main
if [ ! -d "$ScriptFolder" ];then
	mkdir -p "$ScriptFolder"
	chown -R root:wheel "$ScriptFolder"
	chmod -R 755 "$ScriptFolder"
fi

cat << EOF > "$ScriptFolder/macOS-RestartSyncroAgent.sh"
#!/bin/bash

## Runtime Variables
loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
UID=\$(id -u "\$loggedInUser")

##Main
sleep 5

launchctl unload /Library/LaunchDaemons/com.syncromsp.*
launchctl load /Library/LaunchDaemons/com.syncromsp.*

launchctl asuser "\$UID" sudo -u "\$loggedInUser" launchctl unload /Library/LaunchAgents/com.syncromsp.*
launchctl asuser "\$UID" sudo -u "\$loggedInUser" launchctl load /Library/LaunchAgents/com.syncromsp.*

sleep 5

rm -rf "$ScriptFolder"

rm /Library/LaunchDaemons/$PrefDomain.plist
launchctl remove $PrefDomain
EOF

chmod 755 "$ScriptFolder/macOS-RestartSyncroAgent.sh"

cat << EOF > "/Library/LaunchDaemons/$PrefDomain.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
<string>$PrefDomain</string>
	<key>Program</key>
<string>$ScriptFolder/macOS-RestartSyncroAgent.sh</string>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
EOF

chown root:wheel "/Library/LaunchDaemons/$PrefDomain.plist"
chmod 755 "/Library/LaunchDaemons/$PrefDomain.plist"

if launchctl list | grep $PrefDomain; then
	launchctl remove $PrefDomain
fi

launchctl load /Library/LaunchDaemons/$PrefDomain.plist
