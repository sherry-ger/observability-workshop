Add-Type -AssemblyName System.IO.Compression.FileSystem
$workshopPath = "C:\Users\Administrator\Desktop\observability-with-elastic"
$prereq_1 = 'https://notepad-plus-plus.org/repository/7.x/7.6.6/npp.7.6.6.Installer.x64.exe'
$filebeat_link = 'https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.0.0-windows-x86_64.zip'
$metricbeat_link = 'https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.0.0-windows-x86_64.zip'
$heartbeat_link = 'https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-7.0.0-windows-x86_64.zip'
function Install-Prereqs ()
{    
    If (!(Test-Path -Path $downloadPath -PathType Container)) {New-Item -Path $downloadPath -ItemType Directory | Out-Null}
    
    $packages = @(
    @{title='Notepad++ 7.6.6';url=$prereq_1;Arguments=' /Q /S';Destination=$downloadPath},
    @{title='Git 2.21.0';url=$prereq_2;Arguments=' /VERYSILENT /SUPPRESSMSGBOXES';Destination=$downloadPath}
    )
    
    foreach ($package in $packages) {
            $packageName = $package.title
            $fileName = Split-Path $package.url -Leaf
            $destinationPath = $package.Destination + "\" + $fileName
    
    If (!(Test-Path -Path $destinationPath -PathType Leaf)) {
    
        Write-Host "Downloading $packageName"
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($package.url,$destinationPath)
        }
    }
    
    foreach ($package in $packages) {
        $packageName = $package.title
        $fileName = Split-Path $package.url -Leaf
        $destinationPath = $package.Destination + "\" + $fileName
        $Arguments = $package.Arguments
        Write-Output "Installing $packageName"
    
    
    Invoke-Expression -Command "$destinationPath $Arguments"
    }
}
function Download-Beats(){
    If (!(Test-Path -Path $downloadPath -PathType Container)) {New-Item -Path $downloadPath -ItemType Directory | Out-Null}

    $beats = @(
    @{title='Filebeat';url=$filebeat_link;Arguments=' /Q /S';Destination=$downloadPath},
    @{title='Metricbeat';url=$metricbeat_link;Arguments=' /Q /S';Destination=$downloadPath},
    @{title='Heartbeat';url=$heartbeat_link;Arguments=' /Q /S';Destination=$downloadPath}
    )
    
    foreach ($beat in $beats) {
            $beatName = $beat.title
            $fileName = Split-Path $beat.url -Leaf
            $destinationPath = $beat.Destination + "\" + $fileName
    
            If (!(Test-Path -Path $destinationPath -PathType Leaf)) {
            
                Write-Host "Downloading $beatName"
                $webClient = New-Object System.Net.WebClient
                $webClient.DownloadFile($beat.url,$destinationPath)
            }
        }
    
    foreach ($beat in $beats) {
        $beatName = $beat.title
        $fileName = Split-Path $beat.url -Leaf
        $destinationPath = $beat.Destination + "\" + $fileName
        $Arguments = $package.Arguments
        Write-Output "Unzipping $beatName"
    
        [System.IO.Compression.ZipFile]::ExtractToDirectory(($downloadPath+'\'+$fileName), $downloadPath)

}
}