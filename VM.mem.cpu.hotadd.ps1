Connect-VIServer vcenter.conseco.ad

Function Enable-vCpuAndMemHotAdd($vm){
  $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
  $extra1 = New-Object VMware.Vim.optionvalue
  $extra1.Key="mem.hotadd"
  $extra1.Value="true"
  $vmConfigSpec.extraconfig += $extra1
  $extra2 = New-Object VMware.Vim.optionvalue
  $extra2.Key="vcpu.hotadd"
  $extra2.Value="true"
  $vmConfigSpec.extraconfig += $extra2
  $vm.Extensiondata.ReconfigVM($vmConfigSpec)
}

Get-Content  "c:\listofvms.txt" | %{
   $vm = Get-VM -Name $_
   #Shutdown-VMGuest $vm -Confirm:$false
  Enable-vCpuAndMemHotAdd $vm
}

Disconnect-VIServer vcenter.conseco.ad