[CmdletBinding()]
param (
    $subscriptionName,

    # Path were SPN key file is written. Defaults to $PSSriptRoot
    [string]
    $outputFilePath = $PSScriptRoot + '\SPNKeys'

)

$SPNCred = Get-Credential -Message "Input the Object ID and the Key of the SPN for $($subscriptionName)"
$outputFilePath = $outputFilePath + '\' + $subscriptionName + '.xml'
$SPNCred | Export-CliXml -Path  $outputFilePath
Write-Host "Created Key File at: $($outputFilePath)"