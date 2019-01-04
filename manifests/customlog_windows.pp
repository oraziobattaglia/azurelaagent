# @summary Creates custom logs on a log analytics workspace
#
# This class execute command on Azure.
# Require a windows machine with:
#   1. .Net Framework 4.7.2
#   2. Az powershell module
#
# This class only install the Az powershell module. .Net Framework installation is out of this class
#
# First create an app and a service principal to authenticate to Azure. The app and service principal must 
# have the permissions to create the custom log (contributor?)
#
# @see https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps?view=azps-1.0.0
# @see https://docs.microsoft.com/en-us/powershell/azure/create-azure-service-principal-azureps?view=azps-1.0.0
#
# Sign in with a service principal
# $secpasswd = ConvertTo-SecureString "PlainTextPassword" -AsPlainText -Force
# $mycreds = New-Object System.Management.Automation.PSCredential ("username", $secpasswd)
# Connect-AzAccount -ServicePrincipal -ApplicationId  "http://my-app" -Credential $mycreds -TenantId $tenantid
#
# @example
#   include azurelaagent::customlog_windows
#
# @example
#   hash with custom logs
#   'customlog1':
#     resource_group: 'rs1'
#     workspace_name: 'ws_name1'
#     windows_log_paths:
#       - 'e:\\iis5\\*.log'
#       - 'e:\\logs\\*.log'
#     linux_log_paths:
#       - '/var/logs'
#       - '/logs/*.log'
#   'customlog2':
#     resource_group: 'rs2'
#     workspace_name: 'ws_name2'
#     windows_log_paths:
#       - 'e:\\iis5\\*.log'
#       - 'e:\\logs\\*.log'
#     linux_log_paths:
#       - '/var/logs'
#       - '/logs/*.log'
class azurelaagent::customlog_windows (
  # Parameters to connect to Azure
  String $application_id,
  String $username,
  String $password,
  String $tenant_id,

  # Hash of customlog
  Hash $customlogs = {},

  Boolean $manage_ps_module = true
){
  case $::osfamily {
    'windows': {

      # Install the Az module
      # Works only with direct access to internet
      # To use a proxy need a script and the PSCredential!
      if $manage_ps_module {
        exec { 'Install Az module':
          command  => 'Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted; Install-Module -Name Az -AllowClobber', # lint:ignore:140chars
          unless   => 'if (Get-InstalledModule | Select-String -Pattern "Az") { exit 0 } else { exit 1 }',
          provider => powershell,
        }
      }

      # For each custom log generate and run the powershell script
      $customlogs.each | $k,$v | {
          azurelaagent::customlog_res_windows { $k:
            application_id => $application_id,
            username       => $username,
            password       => $password,
            tenant_id      => $tenant_id,
            *              => $v,
          }
      }

    } # end windows
    default : {
      fail("The fact 'osfamily' is set to ${::osfamily} which is not supported.")
    } # end default
  } # end case
}
