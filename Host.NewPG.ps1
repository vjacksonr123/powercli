Connect-VIServer vcenter.conseco.ad
Get-Cluster -Name 'Alpha' | Get-VMHost | Get-VirtualSwitch -Name 'vSwitchFO' | New-VirtualPortGroup -Name 'VLAN_176' -VLanId 176
Get-Cluster -Name 'Alpha' | Get-VMHost | Get-VirtualSwitch -Name 'vSwitchFO' | New-VirtualPortGroup -Name 'VLAN_178' -VLanId 178
Disconnect-VIServer