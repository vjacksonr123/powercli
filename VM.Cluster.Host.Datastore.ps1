Connect-VIServer vcenter.conseco.ad

$vm = Import-Csv 

Get-VM -Location 'Beta' | Select Name, `
@{N="Datastore";E={Get-Datastore -VM $_}} | `
Export-Csv "H:\VMware\Beta_vm_datastore.csv"

Disconnect-VIServer -Confirm:$false