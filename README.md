# azure-adobe-pp

During Covid time, I decided to go to the beach with my laptop for a month. I needed to do some video editing while there, but I can't install anything on my work laptop.

This solution contains Terraform modules to deploy a GPU-enabled VM in Azure, and scripts to get Adobe apps.

## What this solution does

- Creates a GPU Promo VM in Azure
- Installs Chrome, Google Drive, One Drive (for video files)
- Creates an NSG for RDP whitelisted to deploying PC Public IP
- Creates an auto shutdown rule (in case you forget)
- Downloads Adobe apps via Torrent

## How to use this

Look at the 'examples' folder for example usage.

You can choose to deploy apps into Azure VM (requires Terraform), or just use the Powershell scripts provided to get apps on your local PC/server if you prefer.

Once the solution is deployed, it will have Adobe ISO's sitting in C:\temp ready to install. Silent install is a WIP but is a real bastard with Adobe.

## Under the hood

The scripts will get the Go torrent client from this repo, which was built using https://github.com/anacrolix/torrent
It will then use a magnet link defined for the app to get the ISO's from Monkrus.

## To do

- Moar clouds
- Moar apps
- Silent installs
- Spot pricing (once Promo vms are unavailable)