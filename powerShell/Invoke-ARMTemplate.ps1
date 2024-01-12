[CmdletBinding()]
param (
    [string]
    $targetResourceGroupName,

    [string]
    $templateFilePath,

    [string]
    $parameterFilePath,

    [string]
    $subscriptionID,

    [string]
    $appKeyFilePath,

    [string]
    $tenantID,
    
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