#Copyright 2013 Regan Daniel Laitila
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

define winfeature($feature_name = $title, $ensure, $allsubfeatures = false, $restart = false, $logpath = '', $whatif = false) {
    if $allsubfeatures == true { $strallsubfeatures = '-IncludeAllSubFeature' } else { $strallsubfeatures = '' }
    if $restart == true { $strrestart = '-restart' } else { $strrestart = '' }
    if $whatif == true { $strwhatif = '-whatif' } else { $strwhatif = '' }
    if $logpath != '' { $strlogfile = "-logPath \"${logpath}\"" } else { $strlogfile = "" }

    if $ensure == 'present'{
        $cmd = "Import-Module ServerManager; Install-WindowsFeature ${feature_name} ${strallsubfeatures} ${strrestart} ${strwhatif} ${strlogfile}"

        exec { "winfeature-install-feature-${feature_name}" :
            command   => $cmd,
            onlyif    => "Import-Module ServerManager; if((Get-WindowsFeature ${feature_name}).Installed) { exit 1 }",
            logoutput => true,
            provider  => powershell,
        }

        notify {"winfeature-add-msg-${feature_name}":
            message => "Invoking Install-WindowsFeature: ${cmd}",
        }

        Exec["winfeature-install-feature-${feature_name}"] -> Notify["winfeature-add-msg-${feature_name}"]
    }
    elsif $ensure == 'absent'{
        $cmd = "Import-Module ServerManager; Remove-WindowsFeature ${feature_name} ${strrestart} ${strwhatif} ${strlogfile}"
        exec { "winfeature-remove-feature-${feature_name}" :
            command   => $cmd,
            onlyif    => "Import-Module ServerManager; if((Get-WindowsFeature ${feature_name}).Installed) { exit 0 }",
            logoutput => true,
            provider  => powershell,
           }

        notify {"winfeature-remove-msg-${feature_name}":
            message => "Invoking Remove-WindowsFeature: ${cmd}",
        }

        Exec["winfeature-remove-feature-${feature_name}"] -> Notify["winfeature-remove-msg-${feature_name}"] 
    }
}
