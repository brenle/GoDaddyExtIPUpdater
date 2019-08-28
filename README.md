# GoDaddyExtIPUpdater
This script can be used with a home lab and GoDaddy DNS.  The purpose is to automate some available technologies to automatically update Public DNS when the external IP of your lab changes uses Task Scheduler

Uses the following technologies:

GoDaddy PowerShell Module by clintcolding: https://github.com/clintcolding/GoDaddy
Get External/Public IP address 1 liner: https://gallery.technet.microsoft.com/scriptcenter/Get-ExternalPublic-IP-c1b601bb

To setup:

1) Create a GoDaddy API Key/Secret here: https://developer.godaddy.com/keys/ (make sure you use Production keys)
2) Save API key/secret in script (variables at top)
3) Update domains variable in script
4) Make sure the computer you will be running this on has execution policy set to Unrestricted (Set-ExecutionPolicy Unrestricted)
5) Unblock each of the scripts/psd1 file(s) by right clicking, go to properties, click unblock
6) update location of script in UpdateIP.bat file
7) Download the GoDaddy PS Module and set directory path in the script (https://github.com/clintcolding/GoDaddy).
8) Setup task manager to run the UpdateIP.bat file. I run every 5 min.
