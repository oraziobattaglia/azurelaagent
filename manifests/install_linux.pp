# @summary
#   Install agent on linux.
#
# To override default value use yaml file and define variables like
# azurelaagent::install_linux::x64_download_path: 'https://github.com/Microsoft/OMS-Agent-for-Linux/releases/download/OMSAgent_v1.8.1.256/omsagent-1.8.1-256.universal.x64.sh'
#
# @see https://github.com/Microsoft/OMS-Agent-for-Linux/blob/master/docs/OMS-Agent-for-Linux.md
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
# @param downloaded_script
#   Name of the installer script
# @param use_proxy
#   True to use a proxy (passed from init.pp)
# @param proxy
#   Proxy URL like [protocol://][user:password@]proxyhost[:port] (passed from init.pp)
class azurelaagent::install_linux (
  String $ensure,

  String $azure_id,
  String $azure_shared,

  String $x64_download_path,
  String $x86_download_path,
  String $path_to_download,
  String $downloaded_script,

  Optional[Boolean] $use_proxy,
  Optional[String] $proxy,

  # Optional[Array] $packages_to_install = ['glibc','openssl','curl','python-ctypes','pam'],  
){
  # Look for the right version of the installation script
  if ($::architecture == 'amd64' or $::architecture == 'x86_64') {
    # 64 bit
    $file_to_download = $x64_download_path
  } elsif ($::architecture == 'x86' or $::architecture == 'i386') {
    # 32 bit
    $file_to_download = $x86_download_path
  } else {
    fail("The fact 'architecture' is set to ${::architecture} which is not supported.")
  }

  if ($use_proxy and $proxy != '' and $proxy != undef) {
    $download_command = "wget -e use_proxy=yes -e http_proxy=${proxy} ${file_to_download} -O ${path_to_download}/${downloaded_script}"
  } else {
    $download_command = "wget ${file_to_download} -O ${path_to_download}/${downloaded_script}"
  }

  # Installation script download
  exec { 'OMSAgent install script download':
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin',
    command => $download_command,
    unless  => "test -f ${path_to_download}/${downloaded_script}",
  }

  file { "${path_to_download}/${downloaded_script}":
    mode => '0744',
  }

  if ($ensure == 'present') {
    # Install Agent

    # package {$packages_to_install:
    #   ensure => present,
    # }

    if ($use_proxy and $proxy != '' and $proxy != undef) {
      $install_command = "${path_to_download}/${downloaded_script} --upgrade -p ${proxy} -w ${azure_id} -s ${azure_shared}"
    } else {
      $install_command = "${path_to_download}/${downloaded_script} --upgrade -w ${azure_id} -s ${azure_shared}"
    }

    # Agent installation
    exec { 'OMSAgent installation':
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin',
      command => $install_command,
      unless  => 'test -f /opt/microsoft/omsagent/bin/omsadmin.sh',
    }

  } elsif ($ensure == 'absent') {
    # Uninstall Agent
    exec { 'OMSAgent uninstallation':
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin',
      command => "${path_to_download}/${downloaded_script} --purge",
      onlyif  => 'test -f /opt/microsoft/omsagent/bin/omsadmin.sh',
    }

  } else {
    fail('The ensure param must be present or absent')
  }

}
