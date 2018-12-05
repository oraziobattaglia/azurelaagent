# @summary Configure proxy settings after installation
#
# @param ensure
#   'present' to set proxy, 'absent' to purge settings
# @param proxy_server
#   The proxy url like http://your.proxy:port
# @param proxy_user
#   Username for proxy that require authentication
# @param proxy_password
#   Password for proxy that require authentication
# @param path_to_download
#   Where to put the powershell script
#
# @example
#   class {'azurelaagent::config_proxy_windows':
#     proxy_server   => 'http://your.proxy:port',
#     proxy_user     => 'username',
#     proxy_password => 'password',
#   }
class azurelaagent::config_proxy_windows (
  String $ensure,

  Optional[String] $proxy_server = undef,
  Optional[String] $proxy_user = undef,
  Optional[String] $proxy_password = undef,

  # Where to put the powershell script
  Optional[String] $path_to_download,
){

  file {"${path_to_download}\\ChangeProxy.ps1":
    ensure => present,
    source => 'puppet:///modules/azurelaagent/ChangeProxy.ps1',
  }

  if ($ensure == 'present') {
    # Set proxy settings
    if $proxy_server {
      # Proxy server is set
      if ($proxy_user and $proxy_password) {
        # Proxy user and password are set
        exec { 'SetProxySettings':
          command  => "${path_to_download}\\ChangeProxy.ps1 -command set -proxy_server ${proxy_server} -proxy_user ${proxy_user} -proxy_password ${proxy_password}", # lint:ignore:140chars
          unless   => "${path_to_download}\\ChangeProxy.ps1 -command get -proxy_server ${proxy_server} -proxy_user ${proxy_user}",
          provider => powershell,
          require  => File["${path_to_download}\\ChangeProxy.ps1"],
        }
      } else {
        exec { 'SetProxySettings':
          command  => "${path_to_download}\\ChangeProxy.ps1 -command set -proxy_server ${proxy_server}",
          unless   => "${path_to_download}\\ChangeProxy.ps1 -command get -proxy_server ${proxy_server}",
          provider => powershell,
          require  => File["${path_to_download}\\ChangeProxy.ps1"],
        }
      }
    } else {
      fail('Proxy server url is required.')
    }
  } elsif ($ensure == 'absent') {
    # Purge proxy settings
    exec { 'PurgeProxySettings':
      command  => "${path_to_download}\\ChangeProxy.ps1 -command remove",
      unless   => "${path_to_download}\\ChangeProxy.ps1 -command get",
      provider => powershell,
      require  => File["${path_to_download}\\ChangeProxy.ps1"],
    }
  } else {
    fail('The ensure param must be present or absent')
  }

}
