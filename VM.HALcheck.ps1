Connect-VIServer vcenter.conseco.ad

Get-VM | Where {$_.PowerState -eq "PoweredOn"} | Sort Name | Select Name, NumCPU, @{N="OS HAL";E={(Get-WmiObject -ComputerName $_.Name -Query "SELECT * FROM Win32_PnPEntity where ClassGuid = '{4D36E966-E325-11CE-BFC1-08002BE10318}'" | Select Name).Name}}

Disconnect-VIServer -Confirm:$false