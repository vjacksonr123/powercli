$vcserver="vcenter01"
connect-VIServer $vcserver
 
$report = @()
Get-VM | `
  ForEach-Object {
    $VM = $_
    $VM | Get-HardDisk | `
      ForEach-Object {
        $HardDisk = $_
        $row = "" | Select Datastore, VM, VMHost, HardDisk, CapacityGB, Path
                    $row.Datastore = $HardDisk.Filename.Split("]")[0].TrimStart("[")
                    $row.VM = $VM.Name
                    $row.VMHost = $VM.VMHost.Name
                    $row.HardDisk = $HardDisk.Name
                    $row.CapacityGB = ("{0:f1}" -f ($HardDisk.CapacityKB/1MB))
                    $row.Path = $HardDisk.FileName
                    $report += $row
      }
  }
$report | Export-Csv "C:\Scripts\VMwareExport\vcenter01-datastore.csv" -noTypeInformation

Disconnect-VIServer -Confirm:$false