param (
  [String]
  $workspaceId
)

$mma = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg'

$found = $false

$workspaces = $mma.GetCloudWorkspaces()

foreach ($workspace in $workspaces) {
  if ($workspace.workspaceId -eq $workspaceId) {
    $found = $true
  }
}

if ($found) {
  #Write-Output "Id found"
  exit 0
} else {
  #Write-Output "Id not found"
  exit 1
}