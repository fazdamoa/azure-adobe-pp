$ScriptFromGitHub = Invoke-WebRequest https://raw.githubusercontent.com/fazdamoa/azure-adobe-pp/master/modules/install-apps/get-adobe-apps.ps1
Invoke-Expression $($ScriptFromGitHub.Content) PPro19