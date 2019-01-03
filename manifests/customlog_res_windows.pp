# @summary Creates and runs the custom log script using a template
#
# @example
#   azurelaagent::customlog_res_windows { 'namevar': }
define azurelaagent::customlog_res_windows(
  String $resource_group,
  String $workspace_name,
  Array  $windows_log_paths = [],
  Array  $linux_log_paths =[],

  String $template = 'CreateCustomLog.erb',
  String $path = 'C:\Temp',
) {
  case $::osfamily {
    'windows': {

      # TO DO: generate and run the powershell script!

    } # end windows
    default : {
      fail("The fact 'osfamily' is set to ${::osfamily} which is not supported.")
    } # end default
  } # end case
}
