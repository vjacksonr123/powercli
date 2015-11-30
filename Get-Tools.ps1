<#
	.Synopsis
		Will download and install 3 PowerShell tools
	.Description
		Will download and install 3 PowerShell tools.
		PowerGUI, Quest AD Cmdlets and Primal Forms Community Version
	.Notes
	 NAME:      Get-Tools
	 AUTHOR:    Fredrik Wall, fredrik@poweradmin.se
	 BLOG:		poweradmin.se/blog
	 LASTEDIT:  01/17/2010
#>

$targetFolder = "$env:Temp\psToolTemp"
$psTools = "QuestADCmdlet", "PowerGUI", "PrimalForms"

if ($targetFolder) {
	Write-Host "Deleting old temp folder structure"
	$existingTempStructure = Get-ChildItem $targetFolder -Recurse -Force -ErrorAction SilentlyContinue
	foreach ($folder in $existingTempStructure) {
		Write-Host "- Deleting" $folder.FullName
	}
	Write-Host "- Deleting $targetFolder" 
	Remove-Item $targetFolder -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
}

Write-Host
Write-Host "Creating new temp folder structure"

Write-Host "- Creating $targetFolder"
New-Item  $targetFolder -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

foreach ($psTool in $psTools) {
	Write-Host "- Creating $targetFolder\$psTool"
	New-Item  $targetFolder\$psTool -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
}

Write-Host
Write-Host "Downloading and installing tools"

$os = Get-WmiObject -Class Win32_OperatingSystem
$osArchitecture = $os.osArchitecture

foreach ($psTool in $psTools) {
	switch ($psTool) {
		"QuestADCmdlet" {
		
		switch ($osArchitecture) {
			"64-bit" {
			Write-Host "- Downloading $psTool $osArchitecture ~20MB"
			$sourceURL="http://www.quest.com/QuestWebPowershellCmdletDwnld64bit"
			$fileName = "ActiveRolesManagementShellforActiveDirectoryx64_130.msi"
			}
		
			"32-bit" {
			Write-Host "- Downloading $psTool $osArchitecture ~14MB"
			$sourceURL="http://www.quest.com/QuestWebPowershellCmdletDwnld"
			$fileName = "ActiveRolesManagementShellforActiveDirectoryx86_130.msi"
			}
		}
		
		$target = $targetFolder + "\" + $psTool + "\" + $fileName
		if ($WebClient -eq $null) {$Global:WebClient=new-object System.Net.WebClient}
		$ADCmdlet = $WebClient.DownloadFile($sourceURL,$target)
		
		Write-Host "- Installing $psTool $osArchitecture"
		$args = "/passive"
		[diagnostics.process]::start($target, $args).WaitForExit()
		}
		
		"PowerGUI" {
		Write-Host "- Downloading $psTool ~8MB"
		$sourceURL="http://www.powergui.org/servlet/KbServlet/download/1983-102-2817/PowerGUI.1.9.6.1027.msi"
		$fileName = "PowerGUI.1.9.6.1027.msi"

		$target = $targetFolder + "\" + $psTool + "\" + $fileName
		if ($WebClient -eq $null) {$Global:WebClient=new-object System.Net.WebClient}
		$PowerGUI = $WebClient.DownloadFile($sourceURL,$target)

		Write-Host "- Installing $psTool"
		$args = "/passive"
		[diagnostics.process]::start($target, $args).WaitForExit()
		}
		
		"PrimalForms" {
		Write-Host "- Downloading $psTool ~4MB"
		$sourceURL="http://www.primaltools.com/downloads/communitytools/download.asp?file=pforms"
		$fileName = "PrimalForms.msi"

		$target = $targetFolder + "\" + $psTool + "\" + $fileName
		if ($WebClient -eq $null) {$Global:WebClient=new-object System.Net.WebClient}
		$primalForms = $WebClient.DownloadFile($sourceURL,$target)

		Write-Host "- Installing $psTool"
		$args = "/passive"
		[diagnostics.process]::start($target, $args).WaitForExit()
		}
	}
}

if ($targetFolder) {
	Write-Host "Deleting old temp folder structure"
	$existingTempStructure = Get-ChildItem $targetFolder -Recurse -Force -ErrorAction SilentlyContinue
	foreach ($folder in $existingTempStructure) {
		Write-Host "- Deleting" $folder.FullName
	}
	Write-Host "- Deleting $targetFolder" 
	Remove-Item $targetFolder -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
}
