'VMWare Automated Template Deployment Script'
'by http://www.mcpguides.com'
'In order for this script to function properly, you will need a VMWare template, and a Guest Customization Wizard Configuration File already created.'
'Last modified on 12-14-2010'

'**********************************************************************************************************'
'Beginning Script'
'Loading Snapins'
function LoadSnapin{
param($PSSnapinName)
if (!(Get-PSSnapin | where {$_.Name -eq $PSSnapinName})){
Add-pssnapin -name $PSSnapinName
}
}
LoadSnapin -PSSnapinName "VMware.VimAutomation.Core"

'Reading CSV file'
$vms = Import-CSV C:\Scripts\NewVMs.csv

'Reading the contents of the CSV, and for each line execute the following code'
foreach ($vm in $vms){
'Declaring variables that correspond to the column names in the CSV'
$VMName = $vm.name
$VMHost = Get-VMHost $vm.host
$Datastore = Get-Datastore $vm.datastore
$Template = Get-Template $vm.template
$Customization = $vm.customization
$IPAddress = $vm.ipaddress
$Subnetmask = $vm.subnetmask
$DefaultGW = $vm.defaultgw
$DNS1 = $vm.dns1
$DNS2 = $vm.dns2
$WINS1 = $vm.wins1
$WINS2 = $vm.wins2
'Modifying the customization file with the network information you specified in the CSV'
Get-OSCustomizationSpec $Customization | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIp -IpAddress $IPAddress -SubnetMask $Subnetmask -DefaultGateway $DefaultGW -Dns $DNS1,$DNS2 -Wins $WINS1,$WINS2
'Deploying a new VM from the template you specified in the CSV'
New-VM -Name $VMName -OSCustomizationSpec $Customization -Template $Template -VMHost $VMHost -Datastore $Datastore -RunAsync
'Powering up the newly created VM, to allow the guest customization to complete'
Start-VM -VM $VMName -RunAsync
}
'Ending Script'
'*********************************************************************************************************'

