if ($args.length -ne 2) { 
  "This script takes exactly two arguments, in this order: file for output, a path to analyze" 
} 
else { 
  $path = $args[1] 
  $outPutFile = $args[0] 
  $startDate = Get-Date 
  #Build information for the header of the output file. `r`n is a carrage return/line feed. 
  $header = "Start: " + $startDate + "`r`n" + "Output file: " + $outPutFile + "`r`n" + "Path analyzed: " + $path + "`r`n" 
  out-file -encoding ASCII -filePath $outPutFile -append -InputObject $header 
  # Get all directories, not files, get their ACLs, and stuff them into a variable ($dirs). 
  $dirs = Get-ChildItem $path -Force | ? { $_.GetType() -like 'System.IO.DirectoryInfo'} | get-ACL 
  Foreach ($dir in $dirs) { 
    Foreach ($Access in $dir.Access) { 
      $Inherited = [string]$Access.IsInherited 
      if ($Inherited -eq "False") { 
        $pathPieces = $dir.Path.split(":") 
        $output = $PathPieces[2] + ":" + $pathPieces[3] + ", " + $Access.IdentityReference + ", " + $Access.FileSystemRights 
        out-file -encoding ASCII -filePath $outPutFile -append -InputObject $output 
      } 
    } 
  } 
  $endDate = Get-Date 
  $elapsedTime = $endDate - $startDate 
  $footer = "`r`nRun completed at: " + $endDate + "`r`n" + "Elapsed Time:`r`n" + $elapsedTime + "`r`n" 
  out-file -encoding ASCII -filePath $outPutFile -append -InputObject $footer 
}
