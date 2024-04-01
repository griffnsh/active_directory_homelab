# Define when accounts expire
$TSpan = New-TimeSpan -Days 365

# Declare OUs
$OrgList = @('_Admins', 'Help Desk', 'Development', 'Executive Office')
$Org = Read-Host "Please enter Department (_Admins, Help Desk, Development, Executive Office)"

# Validate Department Input
if ($Org -in $OrgList) {
    Clear-Host
} 
# Entry does not exist 
else {
    Write-Host "Department not found"
    Start-Sleep -Seconds 10
}

# Input User Info
$FirstName = Read-Host "Please enter first name"
$LastName = Read-Host "Please enter last name"
$UserName = ($FirstName + "." + $LastName)
$DisplayName = ($FirstName + " " + $LastName)
$UPN = ($UserName + '@mydomain.com')
$CurrentDate = Get-Date -Format "yyyy/MM/dd"
$AccExpiration = (Get-Date) + $TSpan

# Copy info via template
if ($Org.ToLower() -eq '_admins') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _AdminTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created:" +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}

elseif ($Org.ToLower() -eq 'Help Desk') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _AdminTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created:" +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}

elseif ($Org.ToLower() -eq 'Development') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _AdminTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created:" +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}

elseif ($Org.ToLower() -eq 'Executive Office') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _AdminTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created:" +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}



# Verify input
Clear-Host
Write-Host "User created for: $UserName"
Write-Host "Properties:"
Get-ADUser -Identity $UserName -Properties *

# Enable Account -- Templates are disabled by default
$EnableUser = Read-Host "Enable $UserName's account? (Y/N)"
if ($EnableUser.ToLower() -eq 'y') {
    Set-ADAccountPassword -Identity $UserName -Reset
    Write-Host "Account Enabled"
    Enable-ADAccount -Identity $UserName
}
# Decline Account enablment
elseif  ($EnableUser.ToLower() -eq "n") {
    Write-Host "Account remains disabled"
}

# Input validation
else {
    Write-Host "Input not recognized"
    Start-Sleep -Seconds 5
    Exit
}
