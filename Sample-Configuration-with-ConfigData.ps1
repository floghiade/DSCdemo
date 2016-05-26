$ConfigData = 
@{
    AllNodes = @(
 
        @{
            NodeName           = 'DSCClient01'
            Role = 'NLBServer'
            Services = ('BITS','Spooler')
        },
        @{
            NodeName           = 'DSCClient02'
            Role = 'SQLServer'
            Services = 'BITS'
        }
);
    NonNodeData = '' #This is a hash-table of properties that may or may not be related to any of the defined nodes in the AllNodes table.   
}
 
configuration SampleConfiguration
{
 
 
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    node $AllNodes.Where{$_.Role -eq 'SQLServer'}.NodeName
    {
        foreach($Service in $Node.Services)
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
 
     node $AllNodes.Where{$_.Role -eq 'NLBServer'}.NodeName
    {
        foreach($Service in $Node.Services)
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
SampleConfiguration -ConfigurationData $ConfigData