<#
.SYNOPSIS
This script gathers information across Office 365 about Teams

.DESCRIPTION
REquires PowerShell connection to Exchange Online, SharePointOnline, and Teams

.NOTES
1.0 - 

Check-Teams.ps1
v1.0
4/9/2020
By Nathan O'Bryan, MVP|MCSM
nathan@mcsmlab.com

.EXAMPLE
Check-Teams

.LINK
https://www.mcsmlab.com/about
https://github.com/MCSMLab/Check-Teams/blob/master/Check-Teams.ps1
#>

$ErrorActionPreference = 'silentlycontinue'
$Output = @()
$TotalTeams = (Get-Team).count
$Teams = Get-Team
 
ForEach ($Team in $Teams)
{
    $UnifiedGroup = Get-UnifiedGroup -Identity $Team.GroupId
    $SPOSite = Get-SPOSite -Identity $UnifiedGroup.SharePointSiteUrl
    $FolderStatistics = Get-MailboxFolderStatistics -Identity $UnifiedGroup.Identity | Where {$_.FolderPath -eq "/Conversation History/Team Chat"}
  
    $Result = New-Object Object
    $Result | Add-Member DisplayName $Team.DisplayName
    $Result | Add-Member Description $Team.Description
    $Result | Add-Member AccessType $UnifiedGroup.AccessType
    $Result | Add-Member Classification $UnifiedGroup.Classification
    $Result | Add-Member EmailAddress $UnifiedGroup.PrimarySmtpAddress
    $Result | Add-Member Expires $UnifiedGroup.ExpirationTime
    $Result | Add-Member MemberCount $UnifiedGroup.GroupMemberCount
    $Result | Add-Member GuestCount $UnifiedGroup.GroupExternalMemberCount
    $Result | Add-Member HiddenfromOutlook $UnifiedGroup.HiddenFromExchangeClientsEnabled
    $Result | Add-Member StorageUsedMB $SPOSite.StorageUsageCurrent
    $Result | Add-Member TeamChatsinMBX $FolderStatistics.ItemsInFolder
  
    $Output += $Result
}
 
Write-Host
Write-Host "You have $TotalTeams Teams in your tenant"
$Output
