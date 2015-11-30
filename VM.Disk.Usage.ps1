Connect-VIServer vcenter.conseco.ad
$MyCollection = @()
$AllVMs = Get-View -ViewType VirtualMachine | Where {$_.name -like "NTS8*"}
$SortedVMs = $AllVMs | Select *, @{N="NumDisks";E={@($_.Guest.Disk.Length)}} | Sort-Object -Descending NumDisks
ForEach ($VM in $SortedVMs){
	$Details = New-object PSObject
	$Details | Add-Member -Name Name -Value $VM.name -Membertype NoteProperty
	$DiskNum = 0
	Foreach ($disk in $VM.Guest.Disk){
		$Details | Add-Member -Name "Disk$($DiskNum)path" -MemberType NoteProperty -Value $Disk.DiskPath
		$Details | Add-Member -Name "Disk$($DiskNum)Capacity(MB)" -MemberType NoteProperty -Value ([math]::Round($disk.Capacity/ 1MB))
		$Details | Add-Member -Name "Disk$($DiskNum)FreeSpace(MB)" -MemberType NoteProperty -Value ([math]::Round($disk.FreeSpace / 1MB))
		$DiskNum++
}
$MyCollection += $Details
}
$MyCollection | Export-Csv "C:\Users\lanmgs\Desktop\SQL-Space.csv"
# Export-Csv, ConvertTo-Html or ConvertTo-Xml can be used above instead of Out-Gridview
Disconnect-VIServer -Confirm:$false