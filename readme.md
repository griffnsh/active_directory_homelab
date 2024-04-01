# Active Directory Homelab

![Network Diagram](https://github.com/griffnsh/active_directory_homelab/blob/master/img/lab_diagram.png)

## Objectives
- Make a simulated corporate network with a VM for a domain controller and a VM for a client interface
- Create a script to have users added to their respective OUs within Active Directory
- Create a script to offboard / disable users

## Environment Setup
- I first had to create the virtual machines to begin -- this was done with VirtualBox w/ a Windows Server 2019 ISO (domain controller) and a Windows 10 x64 ISO (client)
- From the Domain Controller, I configured the domain and DHCP per the lab diagram above.
- Following setup the Client is able to access the internet as demonstrated from the ping tests (outside test & domain test)

![Ping Test](https://github.com/griffnsh/active_directory_homelab/blob/master/img/client_ping.png)

## Employee Onboarding Script

![Onboarding GIF](https://github.com/griffnsh/active_directory_homelab/blob/master/img/onboarding.gif)

- The goal of these scripts is to make a rudimentary console app to handle the requested changes
- Because of this, I need to store and consistently reference the correct variables to ensure cohesion
- Initial delcarations:

```powershell
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
```

- Next I am going to begin writing the logic needed to utilize these variable declarations with if/elseif

```powershell
# Copy info via template
if ($Org.ToLower() -eq '_admins') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _AdminTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created: " +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}

elseif ($Org.ToLower() -eq 'Help Desk') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _HelpDeskTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created: " +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}

elseif ($Org.ToLower() -eq 'Development') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _DevelopmerTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created: " +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}

elseif ($Org.ToLower() -eq 'Executive Office') {
    $User = Get-ADUser -Identity _AdminTemplate -Properties Description, Office
    # Get user group
    $UserGroups = Get-ADPrincipalGroupMembership -Identity _ExecutiveTemplate
    # Create user
    New-ADUser -Instance $User -SamAccountName $UserName -UserPrincipalName $UPN -Surname $LastName -GivenName $FirstName -Name $DisplayName -Description ("Created: " +$CurrentDate) -AccountExpirationDate $AccExpiration
    # Assign users to groups
    $UserGroups | ForEach-Object { Add-ADPrincipalGroupMembership -Identity $UserName -MemberOf $_ -ErrorAction SilentlyContinue}
}
```

- A brief snippet to have the script spit out the created user's properties

```powershell
# Verify input
Clear-Host
Write-Host "User created for: $UserName"
Write-Host "Properties:"
Get-ADUser -Identity $UserName -Properties *
```

- And lastly logic to ask whether you would like to enable the user account (accounts are automatically disabled in my environment)
```powershell
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

```

## Employee Offboarding Script

![Offboarding GIF](https://github.com/griffnsh/active_directory_homelab/blob/master/img/offboarding.gif)

- Now I have to create a script to disable an employee's account
- This code will be much more brief because I only have to anticipate 2 things occuring in the script
- The declarations:

```powershell
# Get user
$DisableUser = Read-Host "Enter employee username"
# Verify input, handle errors
$User = $(try{Get-ADUser $DisableUser} catch{$Null})
```

- Now for the logic I simply need to chain the correct cmdlets to the correct variables and PowerShell properties and error handle:
```powershell
if ($User -ne $Null) {
    Disable-ADAccount -Identity $DisableUser
    Get-ADUser -Identity $DisableUser | Select-Object SamAccountName, Enabled
}
else {
    Write-Host "User not found"
    exit
}
```
