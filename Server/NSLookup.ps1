#NSLookup
Write-host "Welcome to the NSLookup tool to find the debug information or the authorative server (SOA) information."

function nslookupfunction {
$varhostname = Read-host -prompt "Please enter the servername/hostname to perform nslookup on/at"
Write-host "Would you like to get the debug information please enter 1, if you would like the authorative information please enter 2:"
$varquestioncheck = Read-host -prompt "Please read the question above and check 1 or 2"
if($varquestioncheck -eq 1){
#Debug info:
nslookup -debug $varhostname
}
elseif($varquestioncheck -eq 2){
#Checkauthorative:
nslookup -type=soa $varhostname
}
else{
    write-host "The choice you made is not a valid choice...! Please try again.."
}
}
nslookupfunction
Start-sleep -Seconds 10


function retryrunfunction {
$varrerun = Read-host -prompt "Would you like to retry/rerun the script? [Y/N]"
if($varrerun -eq 'Y'){
nslookupfunction
}
else{
write-host "Exiting script"
$iamhappy += 1
}
}
do{
retryrunfunction
}
until ($iamhappy -gt 0)