# @summary Permit to set new workspace Id and Key. Remove all present workspace Ids.
#
# @param azure_id
#   The new workspace id
# @param azure_share
#   The new workspace key
#
# @example
#   azurelaagent::config_windows { 
#     azure_id     => 'new_workspace_id', 
#     azure_shared => 'new_shared_key',
#   }
define azurelaagent::config_windows(
  String $azure_id,
  String $azure_shared,
) {
  # Where to put the powershell script
  $path_to_download = lookup('azurelaagent::install_windows::path_to_download', {default_value => 'C:\temp'})

  file {"${path_to_download}\\ChangeWorkspaceAndKey.ps1":
    ensure => present,
    source => 'puppet:///modules/azurelaagent/ChangeWorkspaceAndKey.ps1',
  }

  # Set new workspace Id and Key
  exec { 'SetWorkspaceAndKey':
    command  => "${path_to_download}\\ChangeWorkspaceAndKey.ps1 -command set -workspaceId ${azure_id} -workspaceKey ${azure_shared}",
    unless   => "${path_to_download}\\ChangeWorkspaceAndKey.ps1 -command get -workspaceId ${azure_id}",
    provider => powershell,
  }
}
