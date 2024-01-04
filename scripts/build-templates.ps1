$dir = $PSScriptRoot + "\..\templates\"
$debug = $dir + "web_debug"
$release = $dir + "web_release"

Compress-Archive -Force -Path "$($debug)\*" -DestinationPath "$($debug).zip"
Compress-Archive -Force -Path "$($release)\*" -DestinationPath "$($release).zip"