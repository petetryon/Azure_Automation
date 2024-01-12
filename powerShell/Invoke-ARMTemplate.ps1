[CmdletBinding()]
param (
    [string]
    $targetResourceGroupName = "AZRG-AUD-DV1L10N-DEV-AME-USE2-APP",

    [string]
    $templateFilePath = "C:\repos\L10NPortal2.0.Infrastructure\L10nPortal.Infrastructure\provisioning\subscription\subscription.Infrastructure.bicep",

    [string]
    $parameterFilePath = "C:\repos\L10NPortal2.0.Infrastructure\L10nPortal.Infrastructure\provisioning\subscription\parameters\l10n.ame.cic.parameters.json",

    [string]
    #$subscriptionID = "8c71ef53-4473-4862-af36-bae6e40451b2", #US_AUDIT_PROD
    #$subscriptionID = "579d5d7f-d0b3-4cc6-9c61-6715b876a8fe", #US-AZSUB-APA-AUD-NPD-01
    $subscriptionID = "d7ac9c0b-155b-42a8-9d7d-87e883f82d5d", #US_AUDIT_PREPROD
    #$subscriptionID = "8015b941-d143-4a59-9bfc-1717113c8423", #CHE-AUD-AZU-PRD-CORE-01Microsoft.Network/trafficManagerProfiles

    [string]
    #$appKeyFilePath = "C:\Users\ptryon\OneDrive - Deloitte (O365D)\PowerShell\Scripts\SPNKeys\US_Audit_PROD.xml",
    $appKeyFilePath = "C:\Users\ptryon\OneDrive - Deloitte (O365D)\PowerShell\Scripts\SPNKeys\US_Audit_PREPROD.xml",
    #$appKeyFilePath = "C:\Users\ptryon\OneDrive - Deloitte (O365D)\PowerShell\Scripts\SPNKeys\CHE-AUD-AZU-PRD-CORE-01.xml",

    [string]
    #$tenantID = "893fa7f9-3c45-41d0-8f46-5fe03a843c4e" #Swiss Tenant
    $tenantID = "36da45f1-dd2c-4d1f-af13-5abe46b99921", #Global Tenant
    
    [string]
    $deploymentTitle = "PT-deployTest"
)

$TimeStamp = Get-Date -Format "yyyyMMdd-hhmmss"

Write-Host "`n*********************** Logging Into Azure *********************************************************"
$spnCred = Import-Clixml $appKeyFilePath
#$SPNCred = New-Object System.Management.Automation.PSCredential($AppID, $SecureKey) -WarningAction SilentlyContinue
Connect-AzAccount -ServicePrincipal -Credential $SPNCred -Tenant $tenantID -Subscription $subscriptionID
az login --service-principal -u $SPNCred.UserName -p $SPNCred.GetNetworkCredential().Password --tenant $tenantID
az account set --subscription $subscriptionID

try {
    $context = Get-AzContext
    #$RGObject = Get-AzResourceGroup -Name $targetResourceGroupName -ErrorAction stop
    $TemplateFileObject = Get-ChildItem -Path $templateFilePath -ErrorAction stop
    $ParameterFileObject = Get-ChildItem -Path $parameterFilePath -ErrorAction stop
    $DeploymentName = $deploymentTitle + '_' + $TimeStamp
    Write-Host "Subscription: `t$($context.Subscription.Name)"
    Write-Host "ResourceGroup:`t$($RGObject.ResourceGroupName)"
    Write-Host "Template: `t$($TemplateFileObject.Name)"
    Write-Host "Param File `t$($ParameterFileObject.Name)"
    Write-Host "Deployment Name`t$DeploymentName`n"
}
catch {
    throw "One of the deployment objects was not found. Check the path strings"
}

$Deployment = New-AzDeployment -Location 'eastus2' -Name $DeploymentName -TemplateFile $TemplateFileObject.FullName `
-TemplateParameterFile $ParameterFileObject.FullName -SkipTemplateParameterPrompt -DeploymentDebugLogLevel All