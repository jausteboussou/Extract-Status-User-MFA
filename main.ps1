$ClientId = ''
$TenantId = ''
$CertThumbprint = ''
$Cert = Get-ChildItem Cert:\LocalMachine\My\$CertThumbprint
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Connect-MgGraph -ClientId $ClientId -TenantId $TenantId -Certificate $Cert
Connect-MsolService
# Filter
$users = Get-MgUser -All -Property "GivenName,Surname,Department,Manager,OfficeLocation,JobTitle,EmployeeType,UserPrincipalName,OnPremisesSyncEnabled" -Filter "accountEnabled eq true" | Where-Object {
    $_.UserPrincipalName -notmatch 'FileAttente|Standard|CR_FA|#EXT#|_CR_'
}

#$_.UserPrincipalName -notmatch 'FileAttente|Standard|CR_FA|#EXT#|_CR_|GroupeSTERNE.onmicrosoft.com'

$results = @() 
Write-Host "`nRetrieved $($users.Count) users"

foreach ($user in $users) {
    Write-Host "`n$($user.UserPrincipalName)"
    $MFAData = Get-MgUserAuthenticationMethod -UserId $user.UserPrincipalName

    # Initialize myObject with default values
    $myObject = [ordered]@{
        Surname                 = $user.Surname
        GivenName               = $user.GivenName
        User                    = $user.UserPrincipalName
        OnPremiseAccount        = $user.OnPremisesSyncEnabled
        EmployeeType            = $user.EmployeeType
        MFAstatus               = "Disabled"  # Assume disabled by default
        MicrosoftAuthenticator  = $false
        WindowsHelloForBusiness = $false
        SoftwareOath            = $false
        Email                   = $false
        Phone                   = $false
        JobTitle                = $user.JobTitle
        Department              = $user.Department
        OfficeLocation          = $user.OfficeLocation
    }

    #$nonPasswordMethodFound = $false
    foreach ($method in $MFAData) {
        $methodType = ([regex]::Match($method.AdditionalProperties["@odata.type"], '(?<=graph\.)[a-zA-Z]+(?=AuthenticationMethod)').Value).Substring(0,1).ToUpper() + ([regex]::Match($method.AdditionalProperties["@odata.type"], '(?<=graph\.)[a-zA-Z]+(?=AuthenticationMethod)').Value).Substring(1)
        if ($methodType -ne 'Password') {
            $myObject[$methodType] = $true
            #$nonPasswordMethodFound = $true
        }
    }

    <#if ($nonPasswordMethodFound) {
        $myObject.MFAstatus = "Enabled"
    }#>

    # Retrieve the user object from MSOnline
    $msolUser = Get-MsolUser -UserPrincipalName $User.UserPrincipalName

    # Check if StrongAuthenticationRequirements is not null and then access the State
    if ($null -ne $msolUser.StrongAuthenticationRequirements.State) {
        $myObject.MFAstatus = $msolUser.StrongAuthenticationRequirements.State
    } else {
        $myObject.MFAstatus = "Disabled"
    }


    $results += [PSCustomObject]$myObject
}

$TodayDate = Get-Date -Format "yyyyMMdd-HHmm"
$results | Export-Excel -Path "D:\Scripts\MFA\OUT\$($TodayDate)_MFAStatus.xlsx" -TableStyle Medium9 -AutoSize

Disconnect-MgGraph
