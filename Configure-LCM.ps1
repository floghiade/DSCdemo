[DSCLocalConfigurationManager()]
configuration PullClient
{
    Node localhost
    {
        Settings
        {
            RefreshMode = 'Pull'
            RefreshFrequencyMins = 30 
            RebootNodeIfNeeded = $true
            ConfigurationMode = 'ApplyAndAutoCorrect'
            ConfigurationModeFrequencyMins = 15
        }
        ConfigurationRepositoryWeb DSC-Pull
        {
            ServerURL = 'https://dc:8080/PSDSCPullServer.svc'
            RegistrationKey = '2cece610-d19c-4592-b48a-e09cee2003c3'
            ConfigurationNames = 'SomeConfiguration'
            #AllowUnsecureConnection =             $true #Use this parameter only if you do not have a certificate installed on the pull server
        }      
    }
}
PullClient
Set-DSCLocalConfigurationManager localhost –Path .\PullClient –Verbose