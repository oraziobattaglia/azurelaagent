param (
  [String]
  $new_workspaceId,
  [String]
  $new_workspaceKey
)

$mma = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'

# Remove old workspaces
$old_workspaces = $mma.GetCloudWorkspaces()

foreach ($old_workspace in $old_workspaces) {
  Write-Output $old_workspace.workspaceId
  #$mma.RemoveCloudWorkspace($old_workspace.workspaceId)
}

$mma.ReloadConfiguration()

# Add new workspace and key

$mma.AddCloudWorkspace($new_workspaceId,$new_workspaceKey)
$mma.ReloadConfiguration()