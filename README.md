
# Artichoke Consulting
SyncroMSP Scripts by [Artichoke Consulting](https://artichoke.consulting). Montucky Tech at it's finest.

## [macOS](https://github.com/SyncroScripting/Artichoke_Consulting/tree/main/macOS)

**[SyncroMSP](https://github.com/SyncroScripting/Artichoke_Consulting/tree/main/macOS/SyncroMSP):**  
[macOS-DeploySyncroAgent.sh](https://github.com/SyncroScripting/Artichoke_Consulting/blob/main/macOS/SyncroMSP/macOS-DeploySyncroAgent.sh) - Simple macOS SyncroMSP v.2 Agent deployment script.  Just provide $customerId $policyid $shopkey and deploy.  
[macOS-RestartSyncroAgent.sh](https://github.com/SyncroScripting/Artichoke_Consulting/blob/main/macOS/SyncroMSP/macOS-RestartSyncroAgent.sh) - Since the macOS SyncroMSP Agent doesn't have a "Restart Agent" function, here's one for you.

## [Windows](https://github.com/SyncroScripting/Artichoke_Consulting/tree/main/Windows) 
**[Dell](https://github.com/SyncroScripting/Artichoke_Consulting/tree/main/Windows/Dell "Dell"):**  
[Dell-CVE-2021-21551](https://github.com/SyncroScripting/Artichoke_Consulting/blob/main/Windows/Splashtop/DeployAndManage-SplashtopStreamer.ps1) - [Detect](https://github.com/SyncroScripting/Artichoke_Consulting/blob/main/Windows/Dell/Dell-CVE-2021-21551/Detect-Dell-CVE-2021-21551.ps1) and [Remediate](https://github.com/SyncroScripting/Artichoke_Consulting/blob/main/Windows/Dell/Dell-CVE-2021-21551/Remediate-Dell-CVE-2021-21551.ps1) with logging via a SyncroMSP [Automated Remediation](https://help.syncromsp.com/hc/en-us/articles/360001249633-Automated-Remediation)[Dell-CVE-2021-21551](https://nvd.nist.gov/vuln/detail/CVE-2021-21551).

**[Oracle](https://github.com/SyncroScripting/Artichoke_Consulting/tree/main/Windows/Oracle "Oracle"):**  
[jre8](https://github.com/SyncroScripting/Artichoke_Consulting/blob/main/Windows/Splashtop/DeployAndManage-SplashtopStreamer.ps1) - [Detect](https://github.com/SyncroScripting/Artichoke_Consulting/blob/main/Windows/Oracle/jre8/Detect-Outdated-jre8.ps1) and [Enforce](https://github.com/SyncroScripting/Artichoke_Consulting/blob/main/Windows/Oracle/jre8/Enforce-ChocoManaged-jre8.ps1) Oracle Java SE [jre8](https://community.chocolatey.org/packages/jre8) to be installed by [choco](https://chocolatey.org) and remove all but the most recent instance of [jre8](https://community.chocolatey.org/packages/jre8).

**[Splashtop](https://github.com/SyncroScripting/Artichoke_Consulting/tree/main/Windows/Splashtop "Splashtop"):**   
[DeployAndManage-SplashtopStreamer.ps1](https://github.com/SyncroScripting/Artichoke_Consulting/blob/main/Windows/Splashtop/DeployAndManage-SplashtopStreamer.ps1) - Deploy/Upgrade/Redploy Splashtop Streamer with a [Customer Custom Field](https://help.syncromsp.com/hc/en-us/articles/115002530153-Customer-Custom-Fields) for per-customer deploy codes. Embed Splashtop UUID and st-business:// URI in Syncro [Asset Custom Fields](https://help.syncromsp.com/hc/en-us/articles/115002529873-Asset-Custom-Fields). As well as, enforce common settings.
