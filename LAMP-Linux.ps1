
#requires -Modules CimCmdlets, PSDesiredStateConfiguration
#requires -Version 4
configuration LAMPServer
{
    Import-DSCResource -Module nx
    Import-DSCResource -Module nxComputerManagement
    Import-DSCResource -Module nxNetworking
 
    node 10.20.0.10
    {
        nxPackage Apache
        {
            PackageManager = 'Yum'
            Ensure = 'Present'
            Name = 'httpd'
        }
        nxPackage MariaDB
        {
            PackageManager = 'Yum'
            Ensure = 'Present'
            Name = 'mariadb-server'
        }
        nxPackage PHP
        {
            DependsOn = '[nxPackage]Apache'
            PackageManager = 'Yum'
            Ensure = 'Present'
            Name = 'php php-mysql'
        }
 
        nxService Apache
        {
            DependsOn = '[nxPackage]Apache'
            Name = 'httpd'
            Enabled = $true
            Controller = 'systemd'
            State = 'Running'
        }
        nxService MariaDB
        {
            DependsOn = '[nxPackage]MariaDB'
            Name = 'mariadb'
            Enabled = $true
            Controller = 'systemd'
            State = 'Running'
        }
        nxFile PHPTest
        {
            DependsOn = '[nxPackage]Apache'
            Ensure = 'Present'
            Type = 'File'
            DestinationPath = '/var/www/html/test.php'
            Contents = "<?php `nphpinfo(); `n?>"
        }
    }
}
 
LAMPServer
 
$RootCredentials = Get-Credential -UserName:'root' -Message 'Root Credentials'
 
$CIMOptions = New-CimSessionOption -SkipCACheck -SkipCNCheck -UseSsl -SkipRevocationCheck
 
$CIMSession = New-CimSession -Credential $RootCredentials -ComputerName '10.20.0.10' -Port 5986 -Authentication Basic -SessionOption $CIMOptions
 
Start-DscConfiguration -CimSession $CIMSession -Wait -Verbose -Path c:\LAMPServer
 
Get-DscConfiguration -CimSession $CIMSession
 
Test-DscConfiguration -CimSession:$CIMSession