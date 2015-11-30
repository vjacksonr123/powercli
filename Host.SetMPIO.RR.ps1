Connect-VIServer vcenter.conseco.ad

foreach ($hostx in ( Get-Cluster -Name Sigma | Get-VMHost)) {

$hostview = Get-View $hostx 
$storageSystem = Get-View $hostview.ConfigManager.StorageSystem 
$policy = new-object VMware.Vim.HostMultipathInfoLogicalUnitPolicy

#$policy.policy = "VMW_PSP_MRU" 
$policy.policy = "VMW_PSP_RR"

$storageSystem.StorageDeviceInfo.MultipathInfo.lun | foreach { $storageSystem.SetMultipathLunPolicy($_.ID, $policy) } 
}