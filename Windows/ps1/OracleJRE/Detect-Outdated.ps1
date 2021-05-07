 <#
# Script Name:              Detect-Outdated_Oracle_jre8.ps1
# Script Author:            Peet McKinney @ Artichoke Consulting

# Changelog                 
2021.05.06              Initial Checkin                 PJM

This script will uninstall all versions of Oracle Java JRE older than $ChocoPkgCurrentVersion.
If Oracle Java JRE jre is not installed by choco, it will be removed regardless if it's current.
The most recent version of jre8 will be choco install --force jre8 -y

Syncro Script Variables:

None

#>
Import-Module $env:SyncroModule
#Remove-Variable * -ErrorAction SilentlyContinue

########################################
## detect Oracle Java JRE             ##
## Older than $ChocoPkgCurrentVersion ##
########################################

## Variables (Static, think before changing)
$ChocoPkgID="jre8"

## Functions
function Get-ChocoPkgCurrentVersion ($ChocoPkgID){
  $AppInfo_Repo=$((choco list $ChocoPkgID -e -r) -split '\|')
  if ($AppInfo_Repo){
    $global:ChocoPkgCurrentVersion=$AppInfo_Repo[1]
  }else{
    Write-Output "Error:choco did not return $ChocoPkgID`$ChocoPkgCurrentVersion. Exit 1"
    exit 1
  }
}
function Get-ChocoInstalledVersion ($ChocoPkgID) {
  $AppInfo_Local=$((choco list $ChocoPkgID -e -r -l) -split '\|')
  if ($AppInfo_Local){
    $global:ChocoInstalledVersion=$AppInfo_Local[1]
  }else{
    $global:ChocoInstalledVersion=0
  }
}
function Get-ProductInfo {
  $global:CurrentOracleJava=$(Get-WmiObject -Class Win32_Product -Filter "Vendor like 'Oracle%%' and Name like 'Java%%' and NOT Name like 'Java Auto Updater' and Version >= '$ChocoPkgCurrentVersion'")
  $global:OldOracleJava=$(Get-WmiObject -Class Win32_Product -Filter "Vendor like 'Oracle%%' and Name like 'Java%%' and NOT Name like 'Java Auto Updater' and Version < '$ChocoPkgCurrentVersion'")
  $global:OldOracleJavaAutoUpdater=$(Get-WmiObject -Class Win32_Product -Filter "Vendor like 'Oracle%%' and Name like 'Java Auto Updater'")
}
function Stop-JavaApps {
  Get-CimInstance -ClassName 'Win32_Process' | Where-Object {$_.ExecutablePath -like '*Program Files\Java*'} | 
  Select-Object @{n='Name';e={$_.Name.Split('.')[0]}} | Stop-Process -Force
  Get-process -Name *iexplore* | Stop-Process -Force -ErrorAction SilentlyContinue
}

## Main

Get-ChocoPkgCurrentVersion $ChocoPkgID
Write-Output "$ChocoPkgCurrentVersion"
$CurrentOracleJava=$(Get-WmiObject -Class Win32_Product -Filter "Vendor like 'Oracle%%' and Name like 'Java%%' and NOT Name like 'Java Auto Updater' and Version >= '$ChocoPkgCurrentVersion'")
if ($CurrentOracleJava){
  $InstalledVersions=$CurrentOracleJava.Version()
  Rmm-Alert -Category 'OutdatedApp' -Body 'Outdated $ChocoPkgID versions detected: '
} 
