Connect-VIServer vcenter.conseco.ad

$vmName = Get-vm "NTS8SIT03"
Get-HardDisk -VM $vmName | where {$_.Name -eq "Hard disk 5"} | Set-HardDisk -Datastore "W2K8S8X64SIT002" -Confirm:$false
#Get-HardDisk -vm "NTS8SIT03"  | Where {$_.Name -eq "Hard disk 5"} | % {Set-HardDisk -HardDisk $_ -Datastore "W2K8S8X64SIT002" -Confirm:$false}

Disconnect-VIServer -Confirm:$false



