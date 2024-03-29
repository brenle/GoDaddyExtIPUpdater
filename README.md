# GoDaddyExtIPUpdater
The GoDaddy External IP Updater PowerShell script can be used with a home lab and GoDaddy DNS.  The purpose is to automate some available technologies to automatically update Public DNS when the external IP of your lab changes using Task Scheduler in Windows 10.

Uses the following technologies:

GoDaddy PowerShell Module by clintcolding: https://github.com/clintcolding/GoDaddy

Get External/Public IP address 1 liner: https://gallery.technet.microsoft.com/scriptcenter/Get-ExternalPublic-IP-c1b601bb

# Download:

https://github.com/brenle/GoDaddyExtIPUpdater/releases

# To setup:

1) Create a GoDaddy API Key/Secret here: https://developer.godaddy.com/keys/ (make sure you use Production keys)
2) Save API key/secret in script (variables at top)
3) Update domains variable in script
4) Make sure the computer you will be running this on has execution policy set to Unrestricted (Set-ExecutionPolicy Unrestricted)
5) Unblock each of the scripts/psd1 file(s) by right clicking, go to properties, click unblock
6) update location of script in UpdateIP.bat file
7) Download the GoDaddy PS Module and set directory path in the script (https://github.com/clintcolding/GoDaddy).
8) Setup task manager to run the UpdateIP.bat file. I run every 1 hr.

# Change Log:

- 1.0 - initial release
- 1.1 - BugFix; When internet is DOWN and script runs, $ip is returned as $null, which will break the enitre process.
- 1.2 - Added variable to update Cloud-based dns provider if used (NextDns/OpenDns/CloudFlare/etc).  Tested with NextDNS.  Other DNS providers may not use a URL to update like NextDNS does.  

# Warning
This script is present as-is without any support.  I am not responsible for any damage using this script may cause.  This script requires you to keep your GoDaddy API key and secret in clear text within the script, as well as saved in the apiKey.csv file created by the GoDaddy powershell module, which can be potentially damaging if given to the wrong hands.  I do not recommend using this script in production (non-lab) environments. Use at your own risk.