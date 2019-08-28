<#
Version 1.1
Created by Brendon Lee

NOTE:

Uses the following technologies:

GoDaddy PowerShell Module by clintcolding: https://github.com/clintcolding/GoDaddy
Get External/Public IP address 1 liner: https://gallery.technet.microsoft.com/scriptcenter/Get-ExternalPublic-IP-c1b601bb

Fixes:

1.1: BugFix; When internet is DOWN and script runs, $ip is returned as $null, which will break the enitre process.
#>

Param([string]$testip)

#Update these before running:
$godaddypath = "C:\scripts" #This is the location of the godaddy powershell modules - download at link above
$GoDaddyAPIKey = "" #Godaddy api key
$GoDaddySecret = "" #Godaddy api secret
$domainsToUpdate = "domain1.com","domain2.com" #domains you want to have this update

#No need to update these values unless you want to change locations:
$LogFile = "C:\Scripts\UpdateExtIP.log" #This is the Log file location (will auto create)
$IPLogCSV = "C:\Scripts\IPLog.csv" #This is the previous/new ip log location (will auto create)

function initialization
{
    Add-Content -Path $IPLogCSV -Value '"CurrentIP","PreviousIP"'
    Add-Content -Path $IPLogCSV -Value '"null","null"'
}

function CheckIP([string]$extip)
{
    $IPLog = Import-Csv $IPLogCSV

    if($IPLog.CurrentIP -eq "null")
    {
        #first run
        $IPLog.CurrentIP = $extip
        Export-Csv $IPLogCSV -InputObject $IPLog -NoTypeInformation
        return $false

    } else {
        
        if($IPLog.CurrentIP -eq $extip){
            return $true
        } else {
            $IPLog.PreviousIP = $IPLog.CurrentIP
            $IPLog.CurrentIP = $extip
            Export-Csv $IPLogCSV -InputObject $IPLog -NoTypeInformation
            return $false
        }

    }
}

function LogWrite([string]$logstring)
{
  
    Add-Content $LogFile -Value "$(Get-Date): $logstring"

}

function updateGoDaddy([string]$previp,[string]$newip)
{
    Import-Module "$godaddypath\GoDaddy.psd1"
    $init = Test-Path "$godaddypath\apiKey.csv"

    if(!$init)
    {
        #need to set API
        Set-GoDaddyAPIKey -Key $GoDaddyAPIKey -Secret $GoDaddySecret
        LogWrite "Added GoDaddy API Key $GoDaddyAPIKey"
    } else {
        #check to see if we need to change the key
        $scriptapikey = Get-GoDaddyAPIKey
        if(!($scriptapikey.key -eq $GoDaddyAPIKey))
        {
            Set-GoDaddyAPIKey -Key $GoDaddyAPIKey -Secret $GoDaddySecret
            LogWrite "Updated GoDaddy API Key to $GoDaddyAPIKey"
        }

        #Update Godaddy Records for each domain
        foreach($domain in $domainsToUpdate)
        {   
            $recordsToUpdate = Get-GoDaddyDNS -domain $domain | Where-Object{$_.data -eq $previp}
            foreach($record in $recordsToUpdate)
            {
                Set-GoDaddyDNS -Domain $domain -Type $record.type -Name $record.name -Data $newip | Out-Null
                LogWrite "Updated record $($record.name) for $domain to IP $newip"
            }
        }
        
    }

}

$iplogExists = Test-Path $IPLogCSV
if(!$iplogExists)
{
    initialization
}

if($testip)
{
    $ip = $testip
} else {
    $ip = Invoke-RestMethod http://ipinfo.io/json | Select-Object -exp ip
}

if($null -ne $ip)
{
    $IPSame = CheckIP $ip

    if($IPSame)
    {
        LogWrite "No change in External IP address $ip"
        
    } else {
        $IPLog = Import-Csv $IPLogCSV
        if($IPLog.PreviousIP -eq "null")
        {
            #first run
            $IPLog.PreviousIP = "none"
            Export-Csv $IPLogCSV -InputObject $IPLog -NoTypeInformation
            LogWrite "Initial IP address detected as $ip"

        } else {
            LogWrite "New External IP address detected as $ip"
            updateGoDaddy $IPlog.PreviousIP $ip
        }
    }
} else {
    LogWrite "Internet appears to be down.  If not, check to make sure ipinfo.io is accessible from this computer."
}