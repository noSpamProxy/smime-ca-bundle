<#
.SYNOPSIS
  Name: RenameAndSortCertificates.ps1
  Rename and sort X509 certificate files into the desired format of the NoSpamProxy SMIME CA Bundle repository.

.DESCRIPTION
  This script renames all X509 certificates of the current folder and places them into a new folder structure.
  The certificates will be sorted into root and intermidiate certificates.
  There will be a subfolder of the CA and the issuing year of the certificate.
  The naming convention is: certificateCN-certificateThumbprint.cer
  Invalid characters are replaced by '-' and spaces by '_'.

.NOTES
  Version:        1.0.0
  Author:         Jan Jäschke
  Creation Date:  2024-09-06
  Purpose/Change: inital creation
  
.LINK
  https://www.nospamproxy.de
  https://forum.nospamproxy.de 
  https://www.github.com/noSpamProxy

.EXAMPLE
  .\RenameAndSortCertificates.ps1 
#>

New-Item -ItemType Directory roots
New-Item -ItemType Directory intermediaries
$files = (Get-ChildItem -File).FullName
foreach ($file in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($file)
    $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($bytes)
    $dn = [X500DistinguishedName]::new($cert.Subject)
    try {
        $cn = ($dn.Format($true).Split([string[]] @("`r`n", "`r", "`n"), [StringSplitOptions]::RemoveEmptyEntries) | Where-Object {$_ -match 'CN='}).Split('=')[1]
    } catch {
        $o = ($dn.Format($true).Split([string[]] @("`r`n", "`r", "`n"), [StringSplitOptions]::RemoveEmptyEntries) | Where-Object {$_ -match 'O='}).Split('=')[1]
        $cn = $o
    }
    try {
      $o = ($dn.Format($true).Split([string[]] @("`r`n", "`r", "`n"), [StringSplitOptions]::RemoveEmptyEntries) | Where-Object {$_ -match 'O='}).Split('=')[1]
    } catch {
      # bad fallback if no organization exists
      $dc = (($dn.Format($true).Split([string[]] @("`r`n", "`r", "`n"), [StringSplitOptions]::RemoveEmptyEntries)) | Where-Object {$_ -match 'DC='}).Split('=')[3]
      $o = $dc
    }
    $o = $o.Replace(' ','_')
    $org = $o.Replace('"','').Replace('<','-').Replace('>','-').Replace(':','-').Replace('/','-').Replace('\','-').Replace('|','-').Replace('?','-').Replace('*','-') -replace '\.$',''
    $filename = "$($cn.Replace(' ','_'))_$($cert.Thumbprint).cer"
    $filename = $filename.Replace('"','').Replace('<','-').Replace('>','-').Replace(':','-').Replace('/','-').Replace('\','-').Replace('|','-').Replace('?','-').Replace('*','-') -replace '\.$',''
    $year = $cert.NotBefore.Year
    if ($cert.Issuer -eq $cert.Subject) {
        New-Item -ItemType Directory roots\$org
        New-Item -ItemType Directory roots\$org\$year
        Move-Item -Path $file -Destination roots\$org\$year\$filename
    } else {
        New-Item -ItemType Directory intermediaries\$org
        New-Item -ItemType Directory intermediaries\$org\$year
        Move-Item -Path $file -Destination intermediaries\$org\$year\$filename
    }
}

