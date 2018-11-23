# @summary Permit to set new workspace Id and Key. Remove all present workspace Ids.
#
# @param azure_id
#   The new workspace id
# @param azure_share
#   The new workspace key
#
# @example
#   class {'azurelaagent::config_linux': 
#     azure_id     => 'new_workspace_id', 
#     azure_shared => 'new_shared_key',
#   }
class azurelaagent::config_linux (
  String $azure_id,
  String $azure_shared,

  Optional[String] $omsadmin_command = '/opt/microsoft/omsagent/bin/omsadmin.sh',
){
  # Set new workspace Id and Key
  exec { 'SetWorkspaceAndKeyOnLinux':
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin',
    command => "${omsadmin_command} -X; ${omsadmin_command} -w ${azure_id} -s ${azure_shared}",
    unless  => "${omsadmin_command} -l | grep -E '\s+${azure_id}\s+'",
  }
}
