Connect-VIServer vcenter.conseco.ad
Connect-VIServer view4vc.conseco.ad

Get-VM | where {(($_.Guest.OSFullName -like '*XP*') -or ($_.Guest.OSFullName -like '*7*'))}.count

Disconnect-VIServer '*' -Confirm:$false