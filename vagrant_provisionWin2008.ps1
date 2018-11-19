# provision.ps1
# Author: Michelangelo Bottura
# 
# 

# Funzioni
Function Test-Command
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param (
        [string]$command = 'choco' 
    )
    Write-Verbose -Message "Test-Command $command"
    if (Get-Command -Name $command -ErrorAction SilentlyContinue) {
        Write-Verbose -Message "$command exists"
        return $true
    } else {
        Write-Verbose -Message "$command does NOT exist"
        return $false
    } 
} 

Function Install-Choco {
    $mytest = test-command -command "choco.exe"
    switch ( $mytest ) {
        $true   { 
            write-verbose "Installazione di choco non necessaria"
        }
        $false  {
            write-host "Avvio Installazione choco"
            iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) -ErrorAction Continue
            #Set-ExecutionPolicy RemoteSigned; $ERRORACTION=continue;
        }
        Default { Write-Error "stato non determinato"}
    }
}

# execution policy
Write-host "impostazione execution policy"
set-executionpolicy bypass -force

# per Windows 2008 r2 - fine tuning parametru winrm
#Write-Host "Setup WINRM win2008"
#winrm quickconfig -q
#winrm set winrm/config/winrs @{MaxShellsPerUser="10"}
#winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1000"}
#winrm set winrm/config/winrs @{MaxConcurrentUsers="10"}

# variabili 
$setupDir = Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path
Push-Location $setupDir
[Environment]::CurrentDirectory = $PWD

$kms = "kms-svr.dir.unibo.it"
$slmgr = "\windows\system32\slmgr.vbs"
$path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform"
$KmsSetupKey = "Y6KT-GKW9T-YTKYR-T4X34-R7VHC"

#if (-not(Get-ItemProperty $path)."KeyManagementServiceName") {
#    Write-Host "Setting KMS server..."
#    $proc = Start-Process "cscript.exe" -Wait -PassThru -NoNewWindow -ArgumentList @("/nologo", $slmgr, "-skms", $kms)
#    if ($proc.ExitCode -ne 0) {
#        Throw "set KMS server failed"
#    }
#}

Write-host "Attivazione KMS o rearm"

If (-not(Get-ItemProperty $path)."IsActivated") {
    Write-Host "Impostazione KMS client key..."
    $proc = Start-Process "cscript.exe" -wait -PassThru -NoNewWindow -ArgumentList @("/nologo", $slmgr, "-ipk ", $KmsSetupKey)
    # mostra errore slui.exe 0x2a 0xc004d302
    If ($proc.ExitCode -ne 0) {
        #Throw "setup KMS client key failed"
        write-warning "Impostazione KMS client key fallita, tentativo attivazione con key presente"
   }
    $proc = Start-Process "cscript.exe" -Wait -PassThru -NoNewWindow -ArgumentList @("/nologo", $slmgr, "-ato")
    If ($proc.ExitCode -ne 0) {
        #Throw "activate via KMS failed"
        write-warning "Attivazione via KMS fallita, esecuzione rearm"
        $proc = Start-Process "cscript.exe" -Wait -PassThru -NoNewWindow -ArgumentList @("/nologo", $slmgr, "-rearm")
   }
    Set-ItemProperty -Path $path -Name "IsActivated" -Value 1 
}

Write-Host "Disabilitazione modalita' protetta per IE (user & admin)"

$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0

# Write-Host -fore red "Disabilitazione Windows Firewall - disattivare se necessario"
# Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled False

Write-host "Impostazione Tastiera Italiana"
# set-WinUserLanguageList -LanguageList it-IT -Confirm:$false -Force
# set via registry per W2008R2
$LayoutKey = "HKCU:\Keyboard Layout\Preload"  
set-ItemProperty -Path $LayoutKey -name "1" -value "000410"

# Timezone
Write-Host "Impostazione TimeZone"
tzutil /s "W. Europe Standard Time"

# Chocolatey
Write-Host "Installazione chocolatey"

do {  write-host "Installazione Chocolatey..."
      Install-Choco
      sleep 10   
} while ( -not $(test-command -command "choco.exe") )

Write-host "Elimina la conferma di installazione"
choco feature enable -n allowGlobalConfirmation

# Powershell update
Write-Host "Installazione/aggiornamento WMF 5.1 -> DSC"
choco install powershell #--force

#Puppet Agent
Write-host "Installazione puppet agent"
choco install puppet-agent

Write-Host "Creazione dir per ambiente dev"
$devPath = "C:\ProgramData\PuppetLabs\code\environments\dev"
while ( -not (Test-Path $devPath) ) {
    write-host "path non esistente, creo"
    new-item $devPath -ItemType Directory -Force # | out-null
}

# Creazione Shortcut per test puppet (powershell 5.0 è disponibile solo dopo riavvio )
# New-Item -ItemType SymbolicLink -Path "$env:userprofile\Desktop\" -Name "Puppet-Code DEV" -Value "C:\vagrant\Puppet-Code\environments\dev"
$wshshell = New-Object -ComObject WScript.Shell
$desktop = [System.Environment]::GetFolderPath('Desktop')
$lnk = $wshshell.CreateShortcut($desktop+"\Puppet-Code DEV.lnk")
$lnk.TargetPath = "C:\vagrant\Puppet-Code\environments\dev\"
$lnk.Save() 
 
Write-Host "Riavvio necessario"
shutdown -t 10 -r -f

# Valutare:

# set WSUS
## registry

## install nuget
# Install-packageprovider -name nuget -force

## install module pswindowsupdate
# Install-Module -Name PSWindowsUpdate -force

## Install updates
# get-WUinstall

Write-Host "Provisioning Terminato"