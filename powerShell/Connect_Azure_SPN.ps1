[CmdletBinding()]
param (
    [string]
    #$subscriptionID = "8c71ef53-4473-4862-af36-bae6e40451b2", #US_AUDIT_PROD
    $subscriptionID = "d7ac9c0b-155b-42a8-9d7d-87e883f82d5d", #US_AUDIT_PREPROD
    #$subscriptionID = "8015b941-d143-4a59-9bfc-1717113c8423", #CHE-AUD-AZU-PRD-CORE-01Microsoft.Network/trafficManagerProfiles

    [string]
    #$appKeyFilePath = "C:\Users\ptryon\OneDrive - Deloitte (O365D)\PowerShell\Scripts\SPNKeys\US_Audit_PROD.xml",
    #$appKeyFilePath = "C:\Users\ptryon\OneDrive - Deloitte (O365D)\PowerShell\Scripts\SPNKeys\US_Audit_PREPROD.xml",
    #$appKeyFilePath = "C:\Users\ptryon\OneDrive - Deloitte (O365D)\PowerShell\Scripts\SPNKeys\US Audit Azure Policy PROD.xml",
    $appKeyFilePath = "C:\Users\ptryon\OneDrive - Deloitte (O365D)\PowerShell\Scripts\SPNKeys\US AAPS OneCloud Automation PROD.xml",
    #$appKeyFilePath = "C:\Users\ptryon\OneDrive - Deloitte (O365D)\PowerShell\Scripts\SPNKeys\CHE-AUD-AZU-PRD-CORE-01.xml",

    [string]
    #$tenantID = "893fa7f9-3c45-41d0-8f46-5fe03a843c4e" #Swiss Tenant
    $tenantID = "36da45f1-dd2c-4d1f-af13-5abe46b99921" #Global Tenant
)

Write-Host "`n*********************** Logging Into Azure *********************************************************"
Clear-AzContext -Force
$spnCred = Import-Clixml $appKeyFilePath
Connect-AzAccount -ServicePrincipal -Credential $SPNCred -Tenant $tenantID -Subscription $subscriptionID
az login --service-principal -u $SPNCred.UserName -p $SPNCred.GetNetworkCredential().Password --tenant $tenantID | Out-Null
az account set --subscription $subscription | Out-Null
Get-AzContext