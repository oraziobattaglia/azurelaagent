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
#
# @example
#   class {'azurelaagent::config_proxy':
#     proxy_server   => 'http://your.proxy:port',
#     proxy_user     => 'username',
#     proxy_password => 'password',
#   }
class azurelaagent::config_proxy (
  String $ensure,

  Optional[String] $proxy_server = undef,
  Optional[String] $proxy_user = undef,
  Optional[String] $proxy_password = undef,
){

  case $::osfamily {
    'RedHat','Debian': {
      class { 'azurelaagent::config_proxy_linux':
        ensure         => $ensure,
        proxy_server   => $proxy_server,
        proxy_user     => $proxy_user,
        proxy_password => $proxy_password,
      }
    }
    'windows': {
      class { 'azurelaagent::config_proxy_windows':
        ensure         => $ensure,
        proxy_server   => $proxy_server,
        proxy_user     => $proxy_user,
        proxy_password => $proxy_password,      }
    }
    default : {
      fail("The fact 'osfamily' is set to ${::osfamily} which is not supported.")
    }
  } # end case

}
