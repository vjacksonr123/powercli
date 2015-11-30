Connect-VIServer vcenter.conseco.ad

Get-VM | Get-Snapshot | Select VM , Name , Created , SizeMB

Disconnect-VIServer