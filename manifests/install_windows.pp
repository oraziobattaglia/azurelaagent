# @summary
#   Install agent on windows.
#
# To override default value use yaml file and define variables like
# azurelaagent::install_windows::x64_download_path: 'https://go.microsoft.com/fwlink/?LinkId=828603'
#
# @see https://docs.microsoft.com/it-it/azure/log-analytics/log-analytics-agent-windows?toc=/azure/azure-monitor/toc.json#install-the-agent-using-the-command-line
#
# @param ensure
#   'present' to install the agent, 'absent' to uninstall the agent
# @param azure_id
#   Azure workspace ID (passed from init.pp)
# @param azure_shared
#   Azure shared key (passed from init.pp)
# @param x64_download_path
#   URL of the 64 bit agent
# @param x86_download_path
#   URL of the 32 bit agent
# @param path_to_download
#   Where to download the installer
# @param downloaded_exe
#   Name of the installer
# @param path_to_test_installation
#   Agent binaries path, used in the exec resource
# @param package_name
#   Package name as is in Control Panel, Programs and Features 
# @param use_proxy
#   True to use a proxy (passed from init.pp)
# @param proxy
#   Proxy URL like [protocol://][user:password@]proxyhost[:port] (passed from init.pp)
class azurelaagent::install_windows (
  String $ensure,

  String $x64_download_path,
  String $x86_download_path,
  String $path_to_download,
  String $downloaded_exe,
  String $path_to_test_installation,
  String $package_name,

  Optional[String] $azure_id = undef,
  Optional[String] $azure_shared = undef,

  Optional[Boolean] $use_proxy = false,
  Optional[String] $proxy = undef,
){

  if ($ensure == 'present') {
    # Install Agent
    ensure_resource('file', $path_to_download, {'ensure' => 'directory'})

    if ($::architecture == 'amd64' or $::architecture == 'x86_64' or $::architecture == 'x64') {
      # 64 bit
      $file_to_download = $x64_download_path
    } elsif ($::architecture == 'x86' or $::architecture == 'i386') {
      # 32 bit
      $file_to_download = $x86_download_path
    } else {
      fail("The fact 'architecture' is set to ${::architecture} which is not supported.")
    }

    if ($use_proxy and $proxy != '' and $proxy != undef) {
      $download_command = "Invoke-WebRequest -Uri ${file_to_download} -OutFile ${path_to_download}\\${downloaded_exe} -Proxy ${proxy}"
    } else {
      $download_command = "Invoke-WebRequest -Uri ${file_to_download} -OutFile ${path_to_download}\\${downloaded_exe}"
    }

    # Installation exe download
    exec { 'MMASetup.exe install exe download':
      command  => $download_command,
      unless   => "if (Test-Path -Path ${path_to_download}\\${downloaded_exe}) {exit 0} else {exit 1}",
      provider => powershell,
    }

    # File extraction
    exec { 'MMASetup.exe extraction':
      command  =>  "${path_to_download}\\${downloaded_exe} /c /t:${path_to_download}\\extracted",
      unless   => "if (Test-Path -Path ${path_to_download}\\extracted\\setup.exe) {exit 0} else {exit 1}",
      provider => powershell,
    }

    if ($use_proxy and $proxy != '' and $proxy != undef) {
      $install_command = "${path_to_download}\\extracted\\setup.exe /qn NOAPM=1 ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_AZURE_CLOUD_TYPE=0 OPINSIGHTS_WORKSPACE_ID=${azure_id} OPINSIGHTS_WORKSPACE_KEY=${azure_shared} OPINSIGHTS_PROXY_URL=${proxy} AcceptEndUserLicenseAgreement=1" # lint:ignore:140chars
    } else {
      $install_command = "${path_to_download}\\extracted\\setup.exe /qn NOAPM=1 ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_AZURE_CLOUD_TYPE=0 OPINSIGHTS_WORKSPACE_ID=${azure_id} OPINSIGHTS_WORKSPACE_KEY=${azure_shared} AcceptEndUserLicenseAgreement=1" # lint:ignore:140chars
    }

    # Agent installation
    exec { 'Log Analytics Agent installation':
      command  => $install_command,
      unless   => "if (Test-Path -Path \"${path_to_test_installation}\") {exit 0} else {exit 1}",
      provider => powershell,
    }

  } elsif ($ensure == 'absent') {
    # Uninstall Agent
    package{$package_name:
      ensure => 'absent',
    }
  } else {
    fail('The ensure param must be present or absent')
  }

}
