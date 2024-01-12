[CmdletBinding()]
param (
    [string]
    $subscriptionID,

    [string]
    $appKeyFilePath,

    [string]
    $tenantID
)

Write-Host "`n*********************** Logging Into Azure *********************************************************"
Clear-AzContext -Force
$spnCred = Import-Clixml $appKeyFilePath
Connect-AzAccount -ServicePrincipal -Credential $SPNCred -Tenant $tenantID -Subscription $subscriptionID
az login --service-principal -u $SPNCred.UserName -p $SPNCred.GetNetworkCredential().Password --tenant $tenantID | Out-Null
az account set --subscription $subscription | Out-Null
Get-AzContext