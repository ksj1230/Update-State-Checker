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
The package-component mappings are the key infor-mation to solve the blind spot issue. The figure 1 shows the registry paths for package-component mappings, where it can be determined which version of a particular component belongs to which update package.  
![ComponentDetect](Images/ComponentDetect.png "mapping")
<em>figure 1. Registry Settings for Package-Component Mappings</em> 

### 2.2.2. Detecting the Package-Component Mismatches
The following information is required:
- The list of package-component mappings  
  (A record set of [Package Name | Component Name | Component Version])
- Component Information (name, version)
- Package Information (name, installation status)
  
Based on the list of package-component mappings, we describes the following procedure of a detection scheme:   
1. List the installed packages on the system  
2. Check the package-component mappings  
3. Verify the hardlink information of components  
  
# 3. Run Update-State-Checker !
We provide Update-State-Checker written in PowerShell based on the detection scheme. We ran the script on a Windows 10 64-bits desktop. Figure 2 shows the update packages installed on the system.  
![systeminfo](Images/systeminfo.png "systeminfo")
<em>figure 2. Packages Installed on the System </em>  

After tampering the component "amd64_microsoft-windows-smbserver-v2", We ran the script. The execution result is shown in the figure 3.  
![The Execution Result](Images/detection.png "detection")
<em>figure 3. The Execution Result</em>  
  
The execution result tells you that the correct version of the component "amd64_microsoft-windows-smbserver-v2" is 10.0.16299.371, but now consists of 10.0.16299.309.
