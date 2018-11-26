# Changelog

## Release 0.1.3

**Features**

* Install and uninstall Azure Log Analytics agent on linux and windows systems
* Modify Azure Log Analytics workspace id and key after installation
* Modify proxy settings after installation

**Bugfixes**

**Known Issues**

* Sometime the proxy server is configured without the protocol (http|https), for example using 'http://myproxy.com' the agent configuration will be 'myproxy.com'. This cause problem with idempotency. Seem to be a problem with the 'AgentConfigManager.MgmtSvcCfg' object used in the ChangeProxy.ps1 script.

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
