Connect-VIServer vcenter.conseco.ad

function StopServiceSSH {
 $VMHost = Get-VMHost
 foreach ($VMHost in $VMHost) {
   Get-VMHostService -VMHost $VMHost | where {$_.Key -eq "TSM-SSH"} | Stop-VMHostService
  }
}
StopServiceSSH

Disconnect-VIServer -Confirm:$false

#function StartServiceSSH {
# $VMHost = Get-VMHost
# foreach ($VMHost in $VMHost) {
#   Get-VMHostService -VMHost $VMHost | where {$_.Key -eq "TSM-SSH"} | Start-VMHostService
#  }
#}
#StartServiceSSH