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
# @param path_proxy_conf
#   Where's the proxy.conf file
# @param service_restart_command
#   Command to restart the omsagent
#
# @example
#   class {'azurelaagent::config_proxy_linux':
#     proxy_server   => 'http://your.proxy:port',
#     proxy_user     => 'username',
#     proxy_password => 'password',
#   }
class azurelaagent::config_proxy_linux (
  String $ensure,

  Optional[String] $proxy_server = undef,
  Optional[String] $proxy_user = undef,
  Optional[String] $proxy_password = undef,

  Optional[String] $path_proxy_conf,
  Optional[String] $service_restart_command,
){
  # Declare service resource to notify
  service {'omsagent':
    restart => $service_restart_command,
  }

  if ($ensure == 'present') {
    # Set proxy settings
    if $proxy_server {
      # Proxy server is set
      if ($proxy_user and $proxy_password) {
        # Proxy user and password are set
        $splitted_proxy_server = split($proxy_server,'//')
        file {$path_proxy_conf:
          ensure  => 'present',
          owner   => 'omsagent',
          group   => 'omiusers',
          content => "${splitted_proxy_server[0]}//${proxy_user}:${proxy_password}@${splitted_proxy_server[1]}\n",
          notify  => Service['omsagent'],
        }
      } else {
        file {$path_proxy_conf:
          ensure  => 'present',
          owner   => 'omsagent',
          group   => 'omiusers',
          content => "${proxy_server}\n",
          notify  => Service['omsagent'],
        }
      }
    } else {
      fail('Proxy server url is required.')
    }
  } elsif ($ensure == 'absent') {
    # Purge proxy settings
    file {$path_proxy_conf:
      ensure => 'absent',
      notify => Service['omsagent'],
    }
  } else {
    fail('The ensure param must be present or absent')
  }

}
