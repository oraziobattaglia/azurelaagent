# ChangeProxy.ps
#
# Author: Orazio Battaglia
#
# Works in 3 ways:
# -command get -proxy_server proxyserver [-proxy_user proxyuser], return 0 if $proxy_server [and $proxy_user] exists else return 1, used for idempotency
# -command set -proxy_server proxyserver [-proxy_user proxyuser -proxy_password proxypassword], set the new proxy values
# -commande remove, remove the proxy settings
param (
  [String]
  $command,
  [String]
  $proxy_server,
  [String]
  $proxy_user,
  [String]
  $proxy_password
)

# First we get the Health Service configuration object.  We need to determine if we
#have the right update rollup with the API we need.  If not, no need to run the rest of the script.
$healthServiceSettings = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'

$proxyMethod = $healthServiceSettings | Get-Member -Name 'SetProxyInfo'

if (!$proxyMethod)
{
        Write-Output 'Health Service proxy API not present, will not update settings.'
        exit 2
}

switch ($command) {

    "get" {
        if ($proxy_server) {
            # Proxy server is set
            if ($proxy_user) {
                # Proxy user is set
                if (($healthServiceSettings.proxyUrl -eq $proxy_server) -and ($healthServiceSettings.proxyUsername -eq $proxy_user)) {
                    exit 0
                } else {
                    exit 1
                }
            } else {
                if ($healthServiceSettings.proxyUrl -eq $proxy_server) {
                    exit 0
                } else {
                    exit 1
                }
            }
        } else {
            if (($healthServiceSettings.proxyUrl -eq '') -or ($healthServiceSettings.proxyUrl -eq $null)) {
                exit 0
            } else {
                exit 1
            }
        }  
    } # end get

    "set" {
        if ($proxy_server) {
            # Proxy server is set
            # Clearing proxy settings
            $healthServiceSettings.SetProxyInfo('', '', '')

            if ($proxy_user -and $proxy_password) {
                #User and password are set
                $healthServiceSettings.SetProxyInfo($proxy_server, $proxy_user, $proxy_password)
            } else {
                $healthServiceSettings.SetProxyUrl($proxy_server)
            }
            exit 0
        } else {
            Write-Output 'Proxy server url is required.'
            exit 2
        }

    } # end set

    "remove" {
        # Clearing proxy settings
        $healthServiceSettings.SetProxyInfo('', '', '')
        exit 0
    } # end remove

    default {
        Write-Output "Command must be get or set or remove"
        exit 2
    } # end default

} # end switch
