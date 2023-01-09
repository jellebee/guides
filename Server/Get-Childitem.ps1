write-host "Please enter the folder path you'd like to scan like 'C:\Temp', Network paths also work "
$folderpath = read-host "What is the folder path of the folder you'd like to scan?"



if(-not [string]::IsNullOrEmpty($folderpath)) {
   try{
        $exportdecision = read-host -Prompt "Would you like to export afterwards? [Y/N]"
        $gcivar = Get-childitem -Path $folderpath -Recurse -Force -ErrorAction Stop
        Write-Host "Setting variable has succesfully been completed!"
        $gcivar | Out-gridview
   }
   catch{
        Write-Host "An error has occured while setting the child items under a variable" -ForegroundColor Red                
        Write-Host $error[0].Exception.Message
   }
}
else{
        Write-host "An error has occurred while setting the path. Please rerun the script with the correct path."
}

if ($exportdecision -eq 'y'){
    try{
        write-host "Please enter an export path like 'C:\temp\export.csv'"
        $exportpath = read-host "What is the export path (destination of the export file)?"
        gcivar = Export-csv -Path $exportpath -NoClobber -Encoding Unicode -ErrorAction Stop
    }
    catch{
        Write-Host "An error has occurred during the export." -ForegroundColor Red                
        Write-Host $error[0].Exception.Message
    }
}
elseif ($exportdecision -eq 'n') {
    write-host "Don't worry. You don't have to export any information."
}
else {
    Write-host "This is not a valid option. Please rerun the script with a valid option to use the export."
}