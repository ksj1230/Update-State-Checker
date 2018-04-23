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
To ensure package-component consistency, knowledge of which component configuration is appropriate for the current update state is crucial.
The figure 1 shows the registry paths for package-component mappings, where it can be determined which version of a particular component belongs to which update package.
The subkeys of “ComponentDetect” represent component names.
The red box to the right lists the version of the component installed by the particular package.
For example, the name of the package that installed version 6.1.7200.21980 of the amd64_microsoft-windows-os-kernel is KB3046480.
