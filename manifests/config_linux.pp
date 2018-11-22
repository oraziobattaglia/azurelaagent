# @summary Permit to set new workspace Id and Key. Remove all present workspace Ids.
#
# @param azure_id
#   The new workspace id
# @param azure_share
#   The new workspace key
#
# @example
#   azurelaagent::config_linux { 
#     azure_id     => 'new_workspace_id', 
#     azure_shared => 'new_shared_key',
#   }
define azurelaagent::config_linux(
  String $azure_id,
  String $azure_shared,
) {
  # TO DO
}
