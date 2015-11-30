Connect-VIServer view4vc.conseco.ad

$vmcsv = Import-Csv \\ntadminp01\Public\VMware\VMDesktops.csv ### Imports VM deployment specs
$sourcevm = "WXP-SP3-X86"									  ### Sets source vm\template

foreach ($line in $vmcsv)									  ### For Loop to get each object in the CSV
{
New-VM -VM $sourcevm -Name $line.name -VMHost $line.hostname -ResourcePool $line.resourcepool -Location $line.location -Datastore $line.datastore -DiskStorageFormat $line.diskstorageformat -OSCustomizationSpec $line.oscustspec -RunAsync
}
### Deploys the virtual machines from the source vm with the paramaters specified in the CSV.

Disconnect-VIServer -Confirm:$false