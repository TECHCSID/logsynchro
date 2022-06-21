#Récupération du statut de la synchro
$synchroPath = $null;
$synchroService = Get-WmiObject win32_service | ?{$_.Name -like 'Synchronisation iNot Exchange'};

if($null -ne $synchroService)
{
    $synchroPath = $synchroService.PathName.Trim().Trim('"').Trim('SynchroINot.exe');
} 

$SynchroConfigFile = Join-Path -Path $synchroPath -ChildPath "SynchroINot.exe.config";

$xmlSynchro = [xml](Get-Content $SynchroConfigFile);

$appSettings = $xmlSynchro.configuration.appSettings;

$PathLogKeyValue = $appSettings.SelectSingleNode("//add[@key='LogPath']");

$PathLog = $PathLogKeyValue.value;

if(Test-Path -Path $PathLog)
{
    $folderChild = Get-ChildItem $PathLog -Directory -Recurse | Select-Object -Last 1;

    $folder = Join-Path -Path $PathLog -ChildPath $folderChild.Name;

    $FirstFileChild = Get-ChildItem $folder -File -Recurse | Select-Object -First 1;

    $FirstFile = Join-Path -Path $folder -ChildPath $FirstFileChild.Name;

    $Content = Get-Content -tail 5 $FirstFile;

    Write-Output $Content;
}
