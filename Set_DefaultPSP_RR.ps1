Function HostLevel

{
	while (($Correct="Y") -or ($Correct="y"))
		{
			#Get Target Host
				$ESXHost=Read-Host 'Enter the name of the ESX Host to alter Default Path Selection Policy'
			
			#Verify target Host
				Write-Host 'You entered '** $ESXHost **' for the target host.' -foregroundcolor Yellow
			
				$Correct=Read-Host `n'Is the above information correct? [Y or N]'
				if (($Correct -ne "Y") -or ($Correct -ne "y"))
				{
				continue
					}
			
			Write-host `n'Beginning host default path selection policy reconfiguration' -foregroundcolor DarkCyan
			
			$Username=Read-Host 'Enter ESX host connection username CASE SENSTIVE'
			$Password=Read-Host 'Enter ESX host connecting user password CASE SENSTIVE'
			
				#Connect to target host to perform verification and reconfiguration
					Write-Host 'Host to reconfigure default path selection policy:' $ESXHost -foregroundcolor Cyan
					Connect-VIServer "$ESXHost" -Protocol https -User "$Username" -Password "$Password"
					$esxcli = Get-Esxcli -Server $ESXHost
				
				#Perform default path selection policy reconfiguration on target host
				$PSP = $esxcli.nmp.satp.list() | where {$_.Name -eq 'VMW_SATP_ALUA'}
				If ($PSP | where {$_.DefaultPSP -ne 'VMW_PSP_RR'})
					{Write-host 'Default PSP not set to Round Robin, reconfiguration will commence' -foregroundcolor Yellow
					$esxcli.nmp.satp.setdefaultpsp("VMW_PSP_RR", "VMW_SATP_ALUA")
						}
				else
					{
					Write-host 'Default PSP set to Round Robin, skipping host:' $ESXHost -foregroundcolor Green
						}
					break
					}
            startscript
			}
	


Function ClusterLevel
{
	while (($Correct="Y") -or ($Correct="y"))
		{
			#Get Target VCenter and Cluster
				$VirtualCenter=Read-Host 'Enter Virtual Center Server DNS Name'
				$Cluster=Read-Host 'Enter the name of the Cluster to alter disk pathing'
			
			#Verify target VCenter and Cluster
				Write-Host `n'You entered '** $VirtualCenter **' for the target virtual center' -foregroundcolor Yellow
				Write-Host 'You entered '** $Cluster **' for the target cluster.' -foregroundcolor Yellow
			
				$Correct=Read-Host `n'Is the above information correct? [Y or N]'
				if (($Correct -ne "Y") -or ($Correct -ne "y"))
				{
				continue
					}
				Connect-VIServer  "$VirtualCenter"
			
			#Gather lists of Hosts to reconfigure
			Write-host `n'Hosts to reconfigure default multipathing options'`n -foregroundcolor DarkCyan
			$hostn = $(foreach ($hostname in Get-Cluster $Cluster | get-vmhost) {$hostname.Name}) | sort | get-unique
			$hostn
			
			Write-host `n'Beginning host default path selection policy reconfiguration' -foregroundcolor DarkCyan
			
			$Username=Read-Host 'Enter ESX host connection username CASE SENSTIVE'
			$Password=Read-Host 'Enter ESX host connecting user password CASE SENSTIVE'
			
			foreach ($ESXHost in $hostn)
			{
				#Connect to target host to perform verification and reconfiguration
					Write-Host 'Host to reconfigure default path selection policy:' $ESXHost -foregroundcolor Cyan
					Connect-VIServer "$ESXHost" -Protocol https -User "$Username" -Password "$Password"
					$esxcli = Get-Esxcli -Server $ESXHost
				
				#Perform default path selection policy reconfiguration on target host
				$PSP = $esxcli.nmp.satp.list() | where {$_.Name -eq 'VMW_SATP_ALUA'}
				If ($PSP | where {$_.DefaultPSP -ne 'VMW_PSP_RR'})
					{Write-host 'Default PSP not set to Round Robin, reconfiguration will commence' -foregroundcolor Yellow
					$esxcli.nmp.satp.setdefaultpsp("VMW_PSP_RR", "VMW_SATP_ALUA")
						}
				else
					{
					Write-host 'Default PSP set to Round Robin, skipping host:' $ESXHost -foregroundcolor Green
						}
					}
                break
			}
	startscript
	}



function startscript

{
	write-host `n'Please selection an option to reconfigure LUN multipathing.'`n
	write-host '1) Change default path selection policy on a specific host.'
	write-host '2) Change default path selection policy on an entire cluster.'
	write-host 'E) Exit'`n
	$Choice = Read-Host "Please select an option [1-2, E to Exit]"

	switch ($Choice)
		{
		1 {HostLevel}
		2 {ClusterLevel}
		E {Write-Host 'Exiting...'}
		default {write-host 'Invalid Input Detected, please try again.' -foregroundcolor Yellow;startscript}
		}
	}

If ((Get-PowerCLIVersion).Build -ge '332441')
	{
		write-host `n'PowerCLI version is at least build 332441, continuing.'`n  -foregroundcolor Green
		}
else
	{
		write-host `n'PowerCLI version is not at least build 332441, script will not continue.' -foregroundColor Red -backgroundcolor Black
		exit
		}
        
startscript
