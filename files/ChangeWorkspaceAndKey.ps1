# ChangeWorkspaceAndKey.ps
#
# Author: Orazio Battaglia
#
# Works in 2 ways:
# -command get -workspaceId $workspaceId, return 0 if $workspacceId exists else return 1, used for idempotency
# -command set -workspaceId $workspaceId -workspaceKey $workspaceKey, set the new values
param (
  [String]
  $command,
  [String]
  $workspaceId,
  [String]
  $workspaceKey
)

switch ($command) {

  "get" {
    $found = $false
    $mma = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'
    $workspaces = $mma.GetCloudWorkspaces()

    if ($null -ne $workspaces) {
        foreach ($workspace in $workspaces) {
          if ($workspace.workspaceId -eq $workspaceId) {
            $found = $true
          }
        }    
    }

    if ($found) { exit 0 } else { exit 1 }
  } # end get

  "set" {
    $mma = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'

    # Remove old workspaces
    $old_workspaces = $mma.GetCloudWorkspaces()

    if ($null -ne $old_workspaces) {
        foreach ($old_workspace in $old_workspaces) {
          $mma.RemoveCloudWorkspace($old_workspace.workspaceId)
        }
    }

    # Add new workspace and key
    $mma.AddCloudWorkspace($workspaceId,$workspaceKey)
    $mma.ReloadConfiguration()
    exit 0
  } # end set

  default {
    Write-Output "Command must be get or set"
    exit 2
  } # end default

} # end switch
