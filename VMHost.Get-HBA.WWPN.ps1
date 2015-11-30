#Initialize variables
$VCServer = "vcenter.conseco.ad"
$objHba = @()

#Connect to vCenter Server
Connect-VIServer $VCServer

$clusters = Get-cluster

foreach ($cluster in $clusters) {
    $vmhosts = $cluster | Get-vmhost
    if ($null -ne $vmhosts) {
        foreach ($vmhost in $vmhosts) {
            $vmhostview = $vmhost | Get-View
            foreach ($hba in $vmhostview.config.storagedevice.hostbusadapter) {
                if ($hba.PortWorldWideName) {
                    #Define Custom object
                    $objWwpn = "" | Select Clustername,Hostname,Hba,Wwpn
                    #Add porperties to the newly created object
                    $objWwpn.ClusterName = $cluster.Name
                    $objWwpn.HostName = $vmhost.Name
                    $objWwpn.Hba = $hba.Device
                    $objWwpn.Wwpn = "{0:x}" -f $hba.PortWorldWideName
                    $objHba += $ObjWwpn
                }
            }
        }
    }
}

$objHba | Export-Csv "H:\VMware\Get-Hba.csv"

Disconnect-VIServer -Confirm:$false
