# List Magnet Links for apps
$PPro19 = "magnet:?xt=urn:btih:ea575decbaa3934db12e52d5ce8cb9efac7f4796"

# Create Temp directory to download ISO
New-Item -ItemType Directory -Force -Path c:\temp
Set-Location C:\temp

# Get torrent client. Is a compiled version of https://github.com/anacrolix/torrent
Invoke-WebRequest -Uri https://raw.githubusercontent.com/fazdamoa/azure-adobe-pp/master/files/torrent.exe -OutFile c:\temp\torrent.exe

# Get the installer ISOs
if ($args.contains("PPro19")) {
    Start-Process -FilePath c:\temp\torrent.exe -Wait -NoNewWindow -ArgumentList "download",$PPro19
}