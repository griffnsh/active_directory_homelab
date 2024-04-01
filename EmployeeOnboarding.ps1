# Define when accounts expire
$TSpan = New-TimeSpan -Days 365

# Declare OUs
$OrgList = ('Admins, Help Desk, Development, Executive Office')
$Org = Read-Host "Please enter Department (Admins, Help Desk, Development, Executive Office)"

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
if ($Org.ToLower() -eq 'Admins') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office, OfficePhoneNumber
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _AdminTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created:" +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}

if ($Org.ToLower() -eq 'Help Desk') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office, OfficePhoneNumber
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _AdminTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created:" +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}

if ($Org.ToLower() -eq 'Development') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office, OfficePhoneNumber
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _AdminTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created:" +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}

if ($Org.ToLower() -eq 'Executive Office') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office, OfficePhoneNumber
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _AdminTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created:" +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}


