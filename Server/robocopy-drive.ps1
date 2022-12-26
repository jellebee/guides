Write-host "Welcome to the Robocopy tool. Please enter the old servername to use like \\servername\H$ and the current server drive like H"
Write-Host "Please be aware that the following directories are excluded RECYCLER, RECYCLEBIN and System Volume Information "
$oldserver = Read-host "Which is the old server? + drive letter"
net use K: $oldserver
$newserver = Read-host "What is the current server? + drive letter"
net use X: $newserver

function robocopyfunc{
    try{
        Robocopy K: X: /Z /COPY:DATSO /MIR /DCOPY:DAT /XD "K:\RECYCLER" "K:\$RECYCLE.BIN" "K:\System Volume Information" /MT:8 /R:2 /W:5 /LOG:C:\Temp\Migrate_$($oldserver)_to_$($newserver).log /NP
    }
    catch{
        Write-Host "An error has occurred while running robocopy"
    }
}
robocopyfunc

