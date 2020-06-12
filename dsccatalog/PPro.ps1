Configuration PPro
{
    Import-DscResource -Module cChoco
    Node "localhost" 
    {
        # Install Packages
        cChocoInstaller installChoco
        {
          InstallDir = "c:\choco"
        }

        cChocoPackageInstallerSet InstallPackages
        {
          Ensure = 'Present'
          Name = @(
                    "googlechrome"
                    "7zip"                 
                  )
          DependsOn = "[cChocoInstaller]installChoco"
        }

        Script InitializeDisks
        {
            SetScript = {
              $disks = Get-Disk | Where NumberOfPartitions -eq '0' | sort number
              $disks | Initialize-Disk
              $letters = 70..89 | ForEach-Object { [char]$_ }
              $count = 0
              $label = "Data"             
              foreach ($disk in $disks) {
                  $driveLetter = $letters[$count].ToString()
                  $disk | 
                  New-Partition -UseMaximumSize -DriveLetter $driveLetter |
                  Format-Volume -FileSystem NTFS -NewFileSystemLabel $label.$count -Confirm:$false -Force
              $count++
              }
            }
            TestScript = { 
              if ((Get-Disk | Where NumberOfPartitions -eq '0') -eq $null) {
                  Write-Verbose "Disks are provisioned"  
                  return $true
              } Else {
                  Write-Verbose "Disks are not provisioned"            
                  Return $false 
              }
            }
            GetScript = { @{ Result = (Get-Disk | Where NumberOfPartitions -eq '0') } }
        }

        Script DownloadPPro
        {
            SetScript = {
              New-Item -ItemType Directory -Force -Path c:\temp
              Set-Location C:\temp
              Invoke-WebRequest -Uri https://raw.githubusercontent.com/fazdamoa/azure-adobe-pp/master/files/torrent.exe -OutFile c:\temp\torrent.exe
              Start-Process -FilePath c:\temp\torrent.exe -Wait -NoNewWindow -ArgumentList "download","magnet:?xt=urn:btih:ea575decbaa3934db12e52d5ce8cb9efac7f4796"
              Mount-DiskImage C:\temp\Premiere.Pro.2019\Adobe.Premiere.Pro.2019.u10.Multilingual.iso
            }
            TestScript = { 
              if ((Get-Volume | where FileSystemLabel -eq "PPRO 2019") -ne $null) {
                  Write-Verbose "PPRO is mounted"  
                  return $true
              } Else {
                  Write-Verbose "Error in mount"            
                  Return $false 
              }
            }
            GetScript = { @{ Result = (Get-Volume | where FileSystemLabel -eq "PPRO 2019") } }
        }    
    }
}

