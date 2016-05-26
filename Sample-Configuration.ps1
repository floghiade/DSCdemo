#requires -Version 5
configuration SampleConfiguration
{
    param(
        [string[]]$NodeName,
        [string[]]$Services
    )
 
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    node $NodeName
    {
        foreach($Service in $Services)
        {
            Service $Service
            {
                StartupType = 'Manual'
                Name = $Service
                State = 'Stopped'
                Ensure = 'Present'
            
            }
        }
    }
}
SampleConfiguration -NodeName ('DSCClient01','DSCClient02') -Services ('BITS', 'Spooler')