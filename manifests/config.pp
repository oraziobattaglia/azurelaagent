# @summary Change Azure Log Analytics configuration on Windows and Linux
#
# @example Explicit data
#   class { 'azurelaagent::config':
#     azure_id     => 'your_workspace_id',
#     azure_shared => 'your_shared_key',
#   }
#
# @example Data on yaml file
#   include azurelaagent::config
#
# @param azure_id
#   Azure workspace ID
# @param azure_shared
#   Azure shared key
class azurelaagent::config (
  String $azure_id,
  String $azure_shared,
){
  case $::osfamily {
    'RedHat','Debian': {
      class { 'azurelaagent::config_linux':
        azure_id     => $azure_id,
        azure_shared => $azure_shared,
      }
    }
    'windows': {
      class { 'azurelaagent::config_windows':
        azure_id     => $azure_id,
        azure_shared => $azure_shared,
      }
    }
    default : {
      fail("The fact 'osfamily' is set to ${::osfamily} which is not supported.")
    }
  } # end case
}
