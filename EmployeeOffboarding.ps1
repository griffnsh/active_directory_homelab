# Get user
$DisableUser = Read-Host "Enter employee username"
# Verify input, handle errors
$User = $(try{Get-ADUser $DisableUser} catch{$Null})

if ($User -ne $Null) {
    Disable-ADAccount -Identity $DisableUser
    Get-ADUser -Identity $DisableUser | Select-Object SamAccountName, Enabled
}
else {
    Write-Host "User not found"
    exit
}