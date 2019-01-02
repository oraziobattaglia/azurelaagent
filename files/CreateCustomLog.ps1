# CreateCustomLog.ps1
#
# Author: Orazio Battaglia
# Thanks to: https://raw.githubusercontent.com/thebitstreamer/toolbox/master/AZMON-CreateCustomLog.ps1
#
# Works in 2 ways:
# -command get 
# -command set 
#
# TODO
# Parametrizzare e provare. Serve un modo per accedere alla sottoscrizione probabilmente una applicazione con permessi specifici
# vedi https://docs.microsoft.com/it-it/azure/active-directory/develop/howto-create-service-principal-portal#required-permissions
param (
  [String]
  $command = "set",
  [String]
  $resourceGroup,
  [String]
  $workspaceName
)

switch ($command) {

  "get" {

  } # end get

  "set" {
        # Custom Log to collect
        # Customize "fileSystemLocations" to the path where files are
        # more info here https://docs.microsoft.com/en-us/azure/azure-monitor/platform/powershell-workspace-configuration
$customLog = @"
{
    "customLogName": "sampleCustomLog1", 
    "description": "Example custom log datasource", 
    "inputs": [
        { 
            "location": { 
            "fileSystemLocations": { 
                "windowsFileTypeLogPaths": [ "e:\\iis5\\*.log" ],  
                "linuxFileTypeLogPaths": [ "/var/logs" ] 
                } 
            }, 
        "recordDelimiter": { 
            "regexDelimiter": { 
                "pattern": "\\n", 
                "matchIndex": 0, 
                "matchIndexSpecified": true, 
                "numberedGroup": null 
                } 
            } 
        }
    ], 
    "extractions": [
        { 
            "extractionName": "TimeGenerated", 
            "extractionType": "DateTime", 
            "extractionProperties": { 
                "dateTimeExtraction": { 
                    "regex": null, 
                    "joinStringRegex": null 
                    } 
                } 
            }
        ] 
    }
"@
        # Custom Logs
        New-AzOperationalInsightsCustomLogDataSource -ResourceGroupName $resourceGroup -WorkspaceName $workspaceName -CustomLogRawJson "$customLog" -Name "Example Custom Log Collection"  
  } # end set

  default {
  
  } # end default
  
} # end switch