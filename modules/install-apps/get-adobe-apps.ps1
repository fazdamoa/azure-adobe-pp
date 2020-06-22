# List Magnet Links for apps
$PPro19 = "magnet:?xt=urn:btih:ea575decbaa3934db12e52d5ce8cb9efac7f4796"
$PPro20 = "magnet:?xt=urn:btih:383cddcecc07c8868dc200f3d8f6a3b3c983824b"
$AEffects20 = "magnet:?xt=urn:btih:3f626db1c34dbfb807a46f5330747c2bb99f57a6"
$PShop20 = "magnet:?xt=urn:btih:53b95d5c10d66a9a0b16b51b1865c5bcebcab678"

# Create Temp directory to download ISO
New-Item -ItemType Directory -Force -Path c:\temp
Set-Location C:\temp

# Get torrent client. Is a compiled version of https://github.com/anacrolix/torrent
Invoke-WebRequest -Uri https://raw.githubusercontent.com/fazdamoa/azure-adobe-pp/master/files/torrent.exe -OutFile c:\temp\torrent.exe

# Get the installer ISOs
if ($args.contains("PPro19")) {
    Start-Process -FilePath c:\temp\torrent.exe -Wait -NoNewWindow -ArgumentList "download",$PPro19
}

if ($args.contains("PPro20")) {
    Start-Process -FilePath c:\temp\torrent.exe -Wait -NoNewWindow -ArgumentList "download",$PPro20
}

if ($args.contains("AEffects20")) {
    Start-Process -FilePath c:\temp\torrent.exe -Wait -NoNewWindow -ArgumentList "download",$AEffects20
}

if ($args.contains("Pshop20")) {
    Start-Process -FilePath c:\temp\torrent.exe -Wait -NoNewWindow -ArgumentList "download",$Pshop20
}