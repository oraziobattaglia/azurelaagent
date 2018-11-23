
# azurelaagent

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with azurelaagent](#setup)
    * [What azurelaagent affects](#what-azurelaagent-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with azurelaagent](#beginning-with-azurelaagent)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

Install the Azure Log Analytics agent on Linux and Windows.
This is a beta module, feel free to contribute.

## Setup

### What azurelaagent affects

The module have the dependecies:
* puppetlabs-stdlib
* puppetlabs-powershell

### Setup Requirements

### Beginning with azurelaagent  

Example

To install the agent

```
   class { 'azurelaagent':
     azure_id     => 'your_workspace_id',
     azure_shared => 'your_shared_key',
   }
```

To modify workspace id and key

```
   class { 'azurelaagent::config':
     azure_id     => 'your_workspace_id',
     azure_shared => 'your_shared_key',
   }
```

To uninstall the agent

```
   class { 'azurelaagent':
     ensure => 'absent',
   }
```

## Usage

If you need to change specific data in Linux or Windows installation use yaml files like

```
azurelaagent::install_linux::x64_download_path: 'https://github.com/Microsoft/OMS-Agent-for-Linux/releases/download/OMSAgent_v1.8.1.256/omsagent-1.8.1-256.universal.x64.sh'
```
```
azurelaagent::install_windows::x64_download_path: 'https://go.microsoft.com/fwlink/?LinkId=828603'
```

## Reference

See reference.

## Limitations

OS compatibility: tested on Ubuntu 16.04 and Windows Server 2012 R2.

## Development

Contributions are welcome!

## Release Notes/Contributors/Etc.
