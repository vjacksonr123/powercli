Connect-VIServer vcenter.conseco.ad
$vms = Get-Content C:\Beta.csv
Foreach ($vm in $vms){
(Get-Datastore -VM (Get-VM $vm)).Name
}

Disconnect-VIServer -Confirm:$false