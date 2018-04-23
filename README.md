# 1. Notice
Update-State-Checker is a tool to detect the package-component mismatch issue will be introduced in DIMVA 2018.

## 1.1. Papers and Presentations
They will be released after being published in DIMVA 2018.

## 1.2. Contributions
We always welcome your contributions. Issue report, bug fix, new feature implementation, anything is alright. Feel free to send us. 

## 1.3. License
Update-State-Checker has dual license, GPL v2 and MIT. You can choose any license you want.

# 2. Introduction of Update-State-Checker
Update-State-Checker solves some of the issues caused by problems of the Windows update management mechanisms.

## 2.1. Proplems of Windows Update Management
The package-component mismatch and the blind spot issue are the first structural problems in the Windows update management mechanism that have not been reported. We outline the concept of a package-component
mismatch and two types of blind spots of Windows update management and reveal the potential threats associated with them. The blind spot issue occurs because Windows does not care about the consistency between update packages and components installed on the system.
These issues affect all server and desktop platforms.  
  
We briefly describe the problems. See the paper for details :)
### 2.1.1. Package-Component Mismatch
- We define it as..  
A state in which a part of component is different from the system that is usually updated
- What (or Who) cause it?  
An error that corrupts the component files or the registry settings  
An attacker who alters the component resources (with administrative privileges)  
- The result from the package-component mismatch  
A part of the components can be replaced with the previous versions that contain known vulnerabilities. At the same time, the update history remains unchanged.  

### 2.1.2. Blind Spot Issues
- After things going..  
There is nothing to diagnose the package-component mismatch.  
- Two types of blind spots  
(Type Ⅰ) The system loads the components that do not match the current update state  
(Type Ⅱ) The system does not provide a means to detect update status abnormalities
 
 ## 2.2. Update State Check Scheme
The blind spot issue can be resolved by mutually verifying the package information and component information. We were able to extract package-component mapping information from the registry settings scattered inside a local.
We also propose update state check scheme, which detects and corrects package-component mismatches by using the package-component mapping information.

### 2.2.1. Package-Component Mappings
- The registry paths for package-component mappings  
The figure 1 shows the registry paths for package-component mappings, where it can be determined which version of a particular component belongs to which update package.  
<center> <img src="Images/ComponentDetect.png" width="700"> </center>  
<center> figure 1. Registry Settings for Package-Component Mappings </center> 

### 2.2.2. Detecting the Package-Component Mismatches
The following information is required:
- The list of package-component mappings  
  (A record set of [Package Name | Component Name | Component Version])
- Component Information (name, version)
- Package Information (name, installation status)
  
Based on the list of package-component mappings, we describes the following procedure of a detection scheme:   
1. List the installed packages on the system  
The package installation information can be found in the registry path Pn. Alterna-tively, if you run the command “dism /online /get-packages,” the servicing agent queries the registry keys and values under the path Pn.
2. Check the package-component mappings  
It must be ensured that your system has component configurations that match the installed package. If all component configurations match the package-component mapping list, the up-date status is normal; unmatched items should be considered to have a package-component mismatch.
3. Verify the hardlink information of components  
Finally, the hardlink information for each component needs to be verified. The "fsutil hardlink list [component file path]" command tells us the hardlink information. If the hardlink sources in the component store have the correct versions of the target components, the update status is normal. Otherwise, the update status has been compromised.


