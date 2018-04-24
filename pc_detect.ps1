<#
                       Update-State-Checker
                       --------------------
       a PoC Script for Update State Check Scheme
 
                Copyright (C) 2018 Sung-jin Kim
      at National Security Research Institute of South Korea
#>

<#
   This software has dual license (MIT and GPL v2). See the GPL_LICENSE and
   MIT_LICENSE file.
#>

<#
Download this script, right click and click Run with Powershell.

Simple Descrption
1. List the installed packages on the system
 : We assume that the ComponentDetect registry has not been tampered with by an attacker.
 : We analyze the ComponentDetect registry information to identify the updated components by package installation
   and the latest version of those components.
2. Check the package-component mappings
 : We verify that the component version in the SideBySide registry is correct based on the latest component version
   information identified in step 1.
3. Verify the hardlink information of components
#>

Write-Host -NoNewLine 'Now Scanning...';

#1. List the installed packages on the system
$ComponentDetect = Get-ChildItem -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\ComponentDetect\'
$DictAnswer = @{} #nested dictionary {component_name, {package_name, component_version}}

ForEach($i in 0..($ComponentDetect.Length-1)) {
    $RegPath = "Registry::"
    $RegPath += $ComponentDetect.Item($i).Name
    $Info = (Get-ItemProperty -path $RegPath)
    $DictPackage = @{}
    ForEach($j in 0..($Info.psobject.Properties.Name.Length-1)){
        If ($Info.psobject.Properties.Name.Item($j).tostring() -match "Package_"){
            $DictPackage.Add($Info.psobject.Properties.Name.Item($j), $Info.psobject.Properties.Value.Item($j).Split("@")[0])
        }
    }
    $DictPackage = $DictPackage.GetEnumerator() | sort -Property value -Descending

    $temp_key = $RegPath.Split("\\")[($RegPath.Split("\\").Length)-1]
    $sub_string = $temp_key.Split("_")[($temp_key.Split("_").Length) - 4] + "_" + $temp_key.Split("_")[($temp_key.Split("_").Length) - 3] + "_" + $temp_key.Split("_")[($temp_key.Split("_").Length) - 2] + "_" + $temp_key.Split("_")[($temp_key.Split("_").Length) - 1]
    $temp_key = $temp_key.Replace($sub_string, "") + $temp_key.Split("_")[($temp_key.Split("_").Length) - 2]

    If( -not $DictAnswer.ContainsKey($temp_key)){
        $DictAnswer.Add($temp_key, $DictPackage)
    }
}

#2. Check the package-component mappings
$SideBySide = Get-ChildItem -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners\'
ForEach($i in 0..(($SideBySide.Length)-1) ){
    $NameInSxS = $SideBySide.Item($i).Name.Split("\\")[($SideBySide.Item($i).Name.Split("\\").Length)-1]
    $temp_name = $NameInSxS.Split("_")[0] + "_" + $NameInSxS.Split("_")[1] + "_" + $NameInSxS.Split("_")[($NameInSxS.Split("_").Length) - 2]
    
    If($DictAnswer.ContainsKey($temp_name)){
        $Base = $DictAnswer[$temp_name][0].Value.Split(".")[0] + "." + $DictAnswer[$temp_name][0].Value.Split(".")[1] + "\\"

        Try{
            $Check = (Get-ItemProperty -path ("Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners\" + $NameInSxS + "\\" + $Base) -ErrorAction Ignore)
        }
        Catch{
        }
        If(6 -ge $Check.psobject.Properties.Name.Length){continue}
        
        #Find the Correct Version
        $count = 0
        $Latest = 0
        ForEach($data in $DictAnswer[$temp_name]){
            $Installed = [int]$data.Value.Split(".")[($data.Value.Split(".").Length) - 1]
            If($Installed -ge $Latest){
                $Latest = $Installed
                $count += 1
            }
        }
        $CorrectVersion = $DictAnswer[$temp_name][$count-1].Value

        $CurrentVersion = (Get-ItemProperty -path ("Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners\" + $NameInSxS + "\\" + $Base)).'(default)'
        If($CorrectVersion -ne $CurrentVersion){
            $NameInSxS
            "Correct Version: " + $CorrectVersion
            "Current Version: " + $CurrentVersion
        }
    }
}

#When running in ISE, annotating the following codes
Write-Host -NoNewLine 'Press any key to exit...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
