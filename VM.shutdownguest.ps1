Connect-VIServer view4vc.conseco.ad

Get-Content  "c:\listofvms.txt" | %{
   $vm = Get-VM -Name $_
   Shutdown-VMGuest $vm -Confirm:$false
   }
   
Disconnect-VIServer view4vc.conseco.ad -Confirm:$false

###  Start-VM   ###