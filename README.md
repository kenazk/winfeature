SUMMARY:
------------------------
This puppet module creates a new defined type 'winfeature'. This can be called within any
class to install/remove windows features based on their ID string ex: 'Web-Server' or a 
comma seperated list of feature IDs ex: 'Telnet-Client,Telnet-Server' 

The functionality is simply a wrapper to the powershell cmdlets 'Add-WindowsFeature' and 'Remove-WindowsFeature'.
All cmdlet parameters are supported by this module. For details about how the above cmdlets operates, please see the 
following microsoft KB Article: http://technet.microsoft.com/en-us/library/cc732263.aspx#BKMK_powershell

Inspired from puppet module: https://forge.puppetlabs.com/opentable/windows_feature

DEPENDENCIES:
------------------------
* Powershell 'Servermanager' module available on local server
* powershell puppet module: https://forge.puppetlabs.com/joshcooper/powershell 

USAGE:
------------------------

<pre>
Param: title
Description: The text ID of the feature to install
Required: Yes
Values: ID string ex: 'Web-Server' or a comma seperated list of feature IDs ex: 'Telnet-Client,Telnet-Server' 
Default: -none-

Param: ensure
Description: Whether to install or remove the feature
Required: Yes
Values: 'present' -or- 'absent'
Default: -none-

Param: allsubfeatures
Description: Whether to force install of all child features
Requried: No
Values: true -or- false
Default: false

Param: restart
Description: Whether to restart the computer after feature installation.
Required: No
Values: true -or- false
Default: false

Param: logpath
Description: file in which to log the installation output
Required: No
Values: Valid filepath, puppet escaped. Ex: "c:\\featureinstall.log"
Default: -none-

Param: whatif
Description: Dry run only, does not install/remove any feature nor restart. 
Required: No
Values: true -or- false
Default: false

Param: concurrent
Description: Whether to run multiple feature installs concurrently.
Required: No
Values: true -or- false
Default: false
</pre>

<pre>
class install-winfeatures{    
    winfeature{'[TITLE]':
        ensure => '[PRESENT/ABSENT]',
        allsubfeatures => [TRUE/FALSE],        
        whatif => [TRUE/FALSE],
        logpath => "[FILEPATH]",
        restart => [TRUE/FALSE],
        concurrent => [TRUE/FALSE],
    }
}
</pre>


EXAMPLES:
------------------------

<pre>
**INSTALL ALL IIS WEBSERVER FEATURES**

class install-winfeatures{    
    winfeature{'Web-Server':
        ensure => 'present',
        allsubfeatures => true,        
        whatif => false,
        logpath => "C:\\featureinstall.log",
        restart => false,
        concurrent => false,
    }
}

**REMOVE ALL IIS WEBSERVER FEATURES AND RESTART**

class install-winfeatures{    
    winfeature{'Web-Server':
        ensure => 'absent',
        allsubfeatures => true,        
        whatif => false,
        logpath => "C:\\featureremoval.log",
        restart => true,
        concurrent => false,
    }
}

**INSTALL MULTIPLE SINGLE FEATURES AT ONCE**

class install-winfeatures{    
    winfeature{'Telnet-Server,Telnet-Client':
        ensure => 'present',
        allsubfeatures => true,        
        whatif => false,
        logpath => "C:\\rolesinstall.log",
        restart => true,
        concurrent => true,
    }
}
</pre>
