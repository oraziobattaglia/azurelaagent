# Changelog

## Release 0.1.5

**Features**

* Updated agent for linux versions

**Bugfixes**

* Removed "ensure_resource" function, used builtin function "defined"  

**Known Issues**

* The windows agent supports more than one workspace id but this module configures only one.
* Sometime the proxy server is configured without the protocol (http|https), for example using 'http://myproxy.com' the agent configuration will be 'myproxy.com'. This cause problem with idempotency. Seem to be a problem with the 'AgentConfigManager.MgmtSvcCfg' object used in the ChangeProxy.ps1 script.
* On Linux when change the proxy configuration there's no command to view the current proxy settings. The /opt/microsoft/omsagent/bin/omsadmin.sh -l command show the current workspace configuration but there isn't a switch to show the current proxy configuration.

## Release 0.1.4

**Features**

* Install and uninstall Azure Log Analytics agent on linux and windows systems
* Modify Azure Log Analytics workspace id and key after installation
* Modify proxy settings after installation

**Bugfixes**

* Added resource dependecies

**Known Issues**

* The windows agent supports more than one workspace id but this module configures only one.
* Sometime the proxy server is configured without the protocol (http|https), for example using 'http://myproxy.com' the agent configuration will be 'myproxy.com'. This cause problem with idempotency. Seem to be a problem with the 'AgentConfigManager.MgmtSvcCfg' object used in the ChangeProxy.ps1 script.
* On Linux when change the proxy configuration there's no command to view the current proxy settings. The /opt/microsoft/omsagent/bin/omsadmin.sh -l command show the current workspace configuration but there isn't a switch to show the current proxy configuration.

## Release 0.1.3

**Features**

* Install and uninstall Azure Log Analytics agent on linux and windows systems
* Modify Azure Log Analytics workspace id and key after installation
* Modify proxy settings after installation

**Bugfixes**

**Known Issues**

* Sometime the proxy server is configured without the protocol (http|https), for example using 'http://myproxy.com' the agent configuration will be 'myproxy.com'. This cause problem with idempotency. Seem to be a problem with the 'AgentConfigManager.MgmtSvcCfg' object used in the ChangeProxy.ps1 script.
* On Linux when change the proxy configuration there's no command to view the current proxy settings. The /opt/microsoft/omsagent/bin/omsadmin.sh -l command show the current workspace configuration but there isn't a switch to show the current proxy configuration.

## Release 0.1.2

**Features**

* Install and uninstall Azure Log Analytics agent on linux and windows systems
* Modify Azure Log Analytics workspace id and key after installation

**Bugfixes**

**Known Issues**

## Release 0.1.1

**Features**

* Install and uninstall Azure Log Analytics agent on linux and windows systems

**Bugfixes**

**Known Issues**

* To change worspace id and shared key uninstall the agent and install it again with the new values

## Release 0.1.0

**Features**

* Install Azure Log Analytics agent on linux and windows systems

**Bugfixes**

* Metadata fixes

**Known Issues**

## Release 0.0.9

**Features**

* Install Azure Log Analytics agent on linux and windows systems

**Bugfixes**

**Known Issues**
