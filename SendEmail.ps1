            $mailbody = "
Processing of WF <B>CO#$CONumber</B> has been completed. <BR>
Please validate that the task was executed successfully and advance the workflow.<BR>
<BR>
<BR>
<FONT FACE =""Courier New"">
-- Server: $vmname<BR>
--- Action: $COActionTXT<BR>
--- FO IP: $VMFOIP<BR>
--- BO IP: $VMBOIP<BR>
--- vCPUs: $VMVCPUS<BR>
--- RAM: $VMRAMmb MB<BR>
--- 2nd Disk: $VMDISKgb GB<BR>
--- VMware Info:<BR>
----- Datastore: $VMdatastore<BR>
----- Cluster: $VMcluster<BR>
----- Resource Pool: $VMresourcepool<BR>
----- Clone Source: $VMsource<BR>
----- Template: $OSVer<BR>
</FONT>"

            $smtpServer = "smtp.conseco.com"
            $mailfrom = "WF-Automate <WF-Automate@CNOinc.com>"
            $mailto = "ntadmin@conseco.com"
            $msg = new-object Net.Mail.MailMessage
            $smtp = new-object Net.Mail.SmtpClient($smtpServer) 
            $msg.From = $mailfrom
            $msg.To.Add($mailto) 
            $msg.To.Add(“loser@cnoinc.com”)
            $msg.Subject = "WF Processing Completed - WF#$CONumber"
            $msg.Body = $mailbody
            $msg.IsBodyHTML = $true 
            $smtp.Send($msg)
