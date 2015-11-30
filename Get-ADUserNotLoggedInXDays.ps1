# List all users in that have not logged on within
# XXX days in "Active Directory"
# 
# Get the Current Date
# 
$COMPAREDATE=GET-DATE
#
# Number of Days to check back.  
# 
$NumberDays=90
#
# Organizational Unit to search
#
$OU='Contoso.local/Business/Users'
#
GET-QADUSER -SearchRoot $OU | where { $_.LastLogon.AddDays($NumberDays) -gt $CURRENTDATE }
#
# Add in a | DISABLE-QADUSER to AUTOMATICALLY Disable those accounts.
# Line should read like this if you want to do that
#
# GET-QADUSER -SearchRoot $OU | where { $_.LastLogon.AddDays($NumberDays) -gt $CURRENTDATE } | DISABLE-QADUSER
