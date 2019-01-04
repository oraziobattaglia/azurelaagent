# @summary Creates and runs the custom log script using a template
#
# @example
#   azurelaagent::customlog_res_windows { 'namevar': }
define azurelaagent::customlog_res_windows (
  # Parameters to connect to Azure
  String $application_id,
  String $username,
  String $password,
  String $tenant_id,

  String $resource_group,
  String $workspace_name,
  Array  $windows_log_paths = [],
  Array  $linux_log_paths =[],

  String $template = 'CreateCustomLog.erb',
  String $path = 'C:\Temp',
) {
  case $::osfamily {
    'windows': {
      ensure_resource('file', $path, {'ensure' => 'directory' })

      # TO DO: generate and run the powershell script!
      file { "${path}\\CreateCustomLog_${title}.ps1":
        ensure  => present,
        content => template('azurelaagent/CreateCustomLog.erb'),
      }

      # Exec the script with the idempotency condition
      # exec {}

    } # end windows
    default : {
      fail("The fact 'osfamily' is set to ${::osfamily} which is not supported.")
    } # end default
  } # end case
}
