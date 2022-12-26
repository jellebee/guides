#Set path to source folder
$Oldpath = "C:\Users\administrator\Documents\Folder\Folder1"

#Set path to destination folder
$Newpath = "C:\Users\administrator\Documents\Folder\Folder2"

#Creates a Mirror from the old to the new path with logging
function robocopyfunc{
    try{
        Robocopy $Oldpath $Newpath /Z /COPY:DATSO /MIR /DCOPY:DAT /MT:8 /R:2 /W:5 /NP
    }
    catch{
        Write-Host "An error has occurred while running robocopy: $($Error[0])"
    }
}
robocopyfunc