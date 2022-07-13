#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

# Global Constants
	[string]$global:MyProjectName = "StorePoint_Presetup_CFG"
	[string]$global:MyName = "StorePoint_FTP_Config"

	[string]$global:MyLogFileFolder = "C:\IKEALogs\IFS" # replace [logdir] with OPOS, IFS or PFS
	
	[string]$global:ProgramData = [Environment]::GetFolderPath('CommonApplicationData') # IFS-PSlib.ps1 needs to be renamed
	[string]$global:ProgramFiles = [Environment]::GetFolderPath('ProgramFiles') # IFS-PSlib.ps1 needs to be renamed

	# $ProgramFiles	is definied in IFS-PSlib but not run before Globals.ps1
	# $ProgramData	is definied in IFS-PSlib but not run before Globals.ps1
	# $AliasRegKey	is definied in IFS-PSlib but not run before Globals.ps1
	[string]$global:MyProgramData = $ProgramData + "\IKEA\$MyProjectName\" + $MyVersion
#	[string]$global:MyProgramData = $ProgramData + "\IKEA\$MyBinaryName\" + $MyVersion

	# should actually use 
	# Set-Variable global:MyVersion -Value ([string]"0,3,0,8") -option Constant
	# but that's to messy to read :(

# Global variables
#[int]$global:LogLevel = 0 # set initial level to none

#Functions

function Set-ScriptVariable
	{
		<#
		.SYNOPSIS
			Set the aliases for the script.
	
		.DESCRIPTION
			Set the following script variables
				$FTPpath
				$FTPSiteAuthorizationRule, ICC Alias FTPSiteAuthorizationRule_1
				$FTPSiteBannerMsg, ICC Alias FTPSiteBannerMsg_1
				$FTPSiteDirBrowseVirtualDir, ICC Alias FTPSiteDirBrowseVirtualDir_1
				$FTPSiteEnableAnonymousAuthetication, ICC Alias FTPSiteEnableAnonymousAuthetication_1
				$FTPSiteEnableBasicAuthentication, ICC Alias FTPSiteEnableBasicAuthentication_1
				$FTPSiteIP, ICC Alias FTPSiteIP_1
				$FTPSiteLogDirectory, ICC Alias FTPSiteLogDirectory_1
				$FTPSiteLogFileRetention, ICC Alias FTPSiteLogFileRetention_1
				$FTPSiteMaxConnections, ICC Alias FTPSiteMaxConnections_1
				$FTPSiteName, ICC Alias FTPSiteName_1
				$FTPSitePhysPath, ICC Alias FTPSitePhysPath_1
				$FTPSiteProtocol, ICC Alias FTPSiteProtocol_1
				$FTPSiteSslBehaviour, ICC Alias FTPSiteSslBehaviour_1
				$FTPSiteTcpPort, ICC Alias FTPSiteTcpPort_1
				$BOS_FTPAccess_SOSIF, ICC Alias POS_STP_FtpAccess_SOSIF
				$BOS_FTPAccess_SAREC, ICC Alias POS_STP_FtpAccess_SAREC
				$BOS_FTPAccess_SOSIF_FTP, ICC Alias POS_STP_FtpAccess_SOSIF_FTP 
				$BOS_FTP_Firewall
				$RestrictedIP
	
		.EXAMPLE
			Set-ScriptVariable
	
		.INPUTS
			None
	
		.OUTPUTS
			None
	
		.NOTES
			https://icchandbook.ikea.com/kb/SitePages/DisplayPopUpPage.aspx?KBID=121&IsDlg=1
	
	#>
	
	Set-LogLevel
	
	$script:FTPpath = "$ProgramFiles\Office"

	# Get aliases
	$Script:FTPSiteAuthorizationRule = Get-LocalAlias FTPSiteAuthorizationRule_1
	$Script:FTPSiteBannerMsg = Get-LocalAlias FTPSiteBannerMsg_1
	$Script:FTPSiteDirBrowseVirtualDir = Get-LocalAlias FTPSiteDirBrowseVirtualDir_1
	$Script:FTPSiteEnableAnonymousAuthetication = Get-LocalAlias FTPSiteEnableAnonymousAuthetication_1
	$Script:FTPSiteEnableBasicAuthentication = Get-LocalAlias FTPSiteEnableBasicAuthentication_1
	[string]$Script:FTPSiteIP = Get-LocalAlias FTPSiteIP_1 -Mandatory
	$Script:FTPSiteLogDirectory = Get-LocalAlias FTPSiteLogDirectory_1
	$Script:FTPSiteLogFileRetention = Get-LocalAlias FTPSiteLogFileRetention_1
	$Script:FTPSiteMaxConnections = Get-LocalAlias FTPSiteMaxConnections_1
	$Script:FTPSiteName = Get-LocalAlias FTPSiteName_1 -Mandatory
	$Script:FTPSitePhysPath = Get-LocalAlias FTPSitePhysPath_1 -Mandatory
	[string]$Script:FTPSiteProtocol = Get-LocalAlias FTPSiteProtocol_1
	$Script:FTPSiteSslBehaviour = Get-LocalAlias FTPSiteSslBehaviour_1
	[int]$Script:FTPSiteTcpPort = Get-LocalAlias FTPSiteTcpPort_1
#	$Script:BOS_FTP_DisplayVirtualDirectories = Get-LocalAlias POS_FTP_DisplayVirtualDirectories
#	$Script:BOS_FTP_VirtualDirectories = Get-LocalAlias POS_FTP_VirtualDirectories
	[string]$Script:BOS_FTPAccess_SOSIF = Get-LocalAlias POS_STP_FtpAccess_SOSIF -Mandatory
	[string]$Script:BOS_FTPAccess_SAREC = Get-LocalAlias POS_STP_FtpAccess_SAREC -Mandatory
	[string]$Script:BOS_FTPAccess_SOSIF_FTP= Get-LocalAlias POS_STP_FtpAccess_SOSIF_FTP -Mandatory
	$Script:BOS_FTP_Firewall =
	
	
	if ($BOS_FTPAccess_SOSIF -and $BOS_FTPAccess_SAREC -and $BOS_FTPAccess_SOSIF_FTP) {# All values exists, combine them
		[string]$Script:BOS_FTPAccess = $BOS_FTPAccess_SOSIF + "," + $BOS_FTPAccess_SAREC + "," + $BOS_FTPAccess_SOSIF_FTP
		Add-Log "Restriced FTP filter string is: $BOS_FTPAccess"
	}# end if
	
	# Build array for filtered IP adresses
	if ($BOS_FTPAccess)
		{
		[array]$RestrictedHost = $BOS_FTPAccess.split(",")
		[array]$Script:RestrictedIP = @()
		
		foreach ($HostName in $RestrictedHost)
			{
			$IPaddress = Get-IpAddress $HostName
			if ($IPaddress) #was found
				{$Script:RestrictedIP = $RestrictedIP += $IPaddress}
		}# end foreach host
	}
	
	if (!$RestrictedIP)
		{
		$Script:RestrictedIP = @("10.63.221.99")
		Add-Log "WARNING:   No IP adresses found for any Restricted SOSIF Host. Reverting to fall back addresseses." -Level 1
		Add-Log "WARNING:   Fallback addresses: $RestrictedIP" -Level 4
	}
}# end function Set-ScriptVariable


function Create-FtpVirtualDirectory
	{
	<#
		.SYNOPSIS
			Creates a FTP Virtual directory.
	
		.DESCRIPTION
			Creates a FTP Virtual directory and restricts access based on IP addresses.
	
		.PARAMETER  FTPSiteName
			FTP site name.
	
		.PARAMETER  PhysicalFTPpath
			Physical path to new virtual folder.
	
		.PARAMETER  $VirtualFolder
			Virtual folder path name.
	
		PARAMETER $RestrictedIP
			Array of IP-addresses used for restricting access to virtal folder.
	
		.EXAMPLE
			Create-FtpVirtualDirectory -FTPSiteName "BOS" -PhysicalFTPpath "d:\FTProot\home" -VirtualFolder "default/home" -RestrictedIP @("10.63.221.99")
	
		.INPUTS
			System.String,System.Array
	
		.OUTPUTS
			None
	
		.NOTES
			Additional information about the function go here.
	
	#>
	
	param
		(
		[Parameter(Mandatory=$true)]
		[string]$FTPSiteName = "",
	
		[Parameter(Mandatory=$true)]
		[string]$PhysicalFTPpath = "",
	
		[Parameter(Mandatory=$true)]
		[string]$VirtualFolder = "",
	
		[array]$RestrictedIP = ""
	)
	
	Add-Log "Trying to create the file folder $PhysicalFTPpath" -Level 3
	New-Item $PhysicalFTPpath -Type Directory -ErrorAction 'SilentlyContinue'
	
	# Get current ACL
	$FolderACL = (Get-Item $PhysicalFTPpath).GetAccessControl("Access")

	#Set folder NTFS permissions
	#	$FTPacl = Get-Acl $FTPSitePhysPath # Root NTFS permissions
	$ACLrule = New-Object System.Security.AccessControl.FileSystemAccessRule("IUSR","Modify","ContainerInherit, ObjectInherit","None","Allow")
	$FolderACL.AddAccessRule($ACLrule)
	Set-Acl $PhysicalFTPpath $FolderACL
	Add-Log "Configured security settings for file folder $PhysicalFTPpath" -Level 3

	# Share Price Book folders as FTP
	New-Item "IIS:\Sites\$FTPSiteName\$VirtualFolder" -physicalPath $PhysicalFTPpath -type VirtualDirectory -force
	Add-Log "Created the FTP Virtual Folder /$VirtualFolder" -Level 3

	# Set FTP virtual folder firewall
	foreach ($ip in $RestrictedIP)
		{
		Add-Log "Trying to configure FTP folder $FTPSiteName/$VirtualFolder with RestrictedIP to $ip" -level 4
		Add-WebConfiguration "/system.ftpServer/security/ipSecurity"  -value @{ipAddress="$ip";Allowed="true"} -PSPath IIS:\ -Location "$FTPSiteName/$VirtualFolder"
	} # end foreach $ip virtual folder
	
	Set-WebConfigurationProperty -Filter /system.ftpserver/security/ipsecurity -Name allowUnlisted -Value $false -PSPath IIS:\ -Location "$FTPSiteName/$VirtualFolder"
#	get-WebConfiguration "/system.ftpServer/security/ipSecurity/*"  -PSPath IIS:\ -location $FTPSiteName

	#Adding User Authorization access
	Add-WebConfiguration "/system.ftpServer/security/authorization"  -value @{accessType="Allow";users="?";permissions=3} -PSPath IIS:\ -location "$FTPSiteName/$VirtualFolder"
	Add-Log "Restricted FTP authorization to $FTPSiteName /$VirtualFolder for Anonymous users." -Level 4
}# end function Create-FtpVirtualDirectory


function Set-Share
	{
	<#
		.SYNOPSIS
			Set a share name for a folder.
	
		.DESCRIPTION
			Shares a folder with a share name on a SMB/CIFS network with certain Windows access permissions
			to the group Everyone.
	
		.PARAMETER  ShareName
			Name of the share.
	
		.PARAMETER  FolderPath
			Path of the folder to share.
	
		.PARAMETER  Description
			Description of the share.
	
		.PARAMETER  Access
			The share access permission.
	
		.EXAMPLE
			Set-Share -ShareName "Test" -FolderPath "c:\Users\Public\Test" -Access "Read"
	
		.EXAMPLE
			Set-Share -ShareName "Secret$" -FolderPath "c:\Users\Public\Secret" -Description "Hidden share" -Access "Read"
	
		.INPUTS
			System.String
	
		.OUTPUTS
			None
	
		.NOTES
			No support for user- or group names in this implementation.
	
		.LINK
			https://support.microsoft.com/en-us/kb/301281
	
	#>
	
	param(
		[string]$ShareName,
		[string]$FolderPath,
		[string]$Description,

		[ValidateSet("Full","Change","Read")]
		[string]$Access = "Read"
	)
	
	# Create Share folder if missing
	New-Item $FolderPath -Type Directory -ErrorAction 'SilentlyContinue'
	Add-Log "Creating folder $FolderPath if needed." -Level 4
	
	# Build Win32 security descriptor structure
	$wmiSD = ([WMIClass]"Win32_SecurityDescriptor").CreateInstance()
	$wmiACE = ([WMIClass]"Win32_ACE").CreateInstance()
	$wmiTrustee = ([WMIClass]"Win32_Trustee").CreateInstance()

	$wmiTrustee.Name = "EVERYONE"
	$wmiTrustee.Domain = $Null
	$wmiTrustee.SID = @(1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0)

	switch ($Access) {
		"Full"		{$wmiACE.AccessMask = 2032127}
		"Change"	{$wmiACE.AccessMask = 1245631}
		"Read"		{$wmiACE.AccessMask = 1179817}
	}# end switch $Access
	
	$wmiACE.AceFlags = 3
	$wmiACE.AceType = 0
	$wmiACE.Trustee = $wmiTrustee

	$wmiSD.DACL += $wmiACE.psObject.baseobject 

	# Build wmiShare parameter structure
	$wmiShare = [WMIClass]"Win32_Share"

	$shareParam = $wmiShare.psbase.GetMethodParameters("Create")
	$shareParam.Access = $wmiSD
	$shareParam.Description = $description
	$shareParam.MaximumAllowed = $Null
	$shareParam.Name = $ShareName
	$shareParam.Password = $Null
	$shareParam.Path = $FolderPath
	$shareParam.Type = [uint32]0


	# Remove old share if it already exists
	if (Get-WmiObject Win32_Share -Filter "name = '$ShareName'"){
		Add-Log "Disabling $ShareName share." -Level 4
		(Get-WmiObject Win32_Share -Filter "name = '$ShareName'").Delete()
	}

	# Create share
	$wmiShare.PSBase.InvokeMethod("Create", $shareParam, $Null)
	# Alternative syntax
	# $wmiShare.Create($FolderPath, $ShareName, 0, $false, $description, $null, $wmiSD)
	Add-Log "Folder $FolderPath shared as $ShareName." -Level 2
}# end function Set-Share


function Set-AnonymousFtpConfiguration
	{
	<#
		.SYNOPSIS
			Set FTP Configuration.
	
		.DESCRIPTION
			Sets up a FTP site for anonymous access.
	
		.PARAMETER  FTPSiteName
			Name of FTP Site.
	
		.PARAMETER  FTPSiteTcpPort
			TCP port of FTP Site.
	
		.PARAMETER  FTPSitePhysPath
			Physical folder path for FTP site.
	
	.EXAMPLE
			Get-Something -ParameterA 'One value' -ParameterB 32
	
		.EXAMPLE
			Get-Something 'One value' 32
	
		.INPUTS
			System.String
	
		.OUTPUTS
			None
	
		.NOTES
			Checks that the physical path really exists.
			Creates the FTP site if not already created.
			Enables SSL connections.
			Enables Anonymous Authentication.
			Enables Anonymous user read access.
			Creates a dead end folder.
			Creates a welcome file for unathorized accesses.
			Sets List Virtual Directories in root
			Sets User Name directory mode (i.e. each user will get their own root folder).
	
		.LINK
			https://technet.microsoft.com/en-us/library/hh867899%28v=wps.620%29.aspx
	
		.LINK
			http://blogs.msdn.com/b/johan/archive/2008/10/02/powershell-advanced-configuration-editing-in-iis7.aspx
	
	#>
	
	param (
		[string]$FTPSiteName,
		[string]$FTPSiteTcpPort = "21",
		[string]$FTPSitePhysPath
	)
	
	# Create FTP Site
	New-WebFtpSite $FTPSiteName -Port $FTPSiteTcpPort -PhysicalPath $FTPSitePhysPath
	Add-Log ("Created FTP site: " + $FTPSiteName) -Level 1

	# Allow SSL connections (still needed due to FTP module SP1 bug)
	Set-ItemProperty "IIS:\Sites\$FTPSiteName" -Name ftpServer.security.ssl.controlChannelPolicy -Value 0
	Set-ItemProperty "IIS:\Sites\$FTPSiteName" -Name ftpServer.security.ssl.dataChannelPolicy -Value 0
	Add-Log "Changed SSL policy to Allow for FTP $FTPSiteName" -Level 3

	# Enable Anonymous Authentication
	Set-ItemProperty "IIS:\Sites\$FTPSiteName" -Name ftpServer.security.authentication.anonymousAuthentication.enabled -Value $true
	Add-Log "Enabled anonymous access to FTP $FTPSiteName." -Level 3

	# Allow Anonymous users Read access (permission= 3 sets Read_Write access)
	Add-WebConfiguration "/system.ftpServer/security/authorization"  -value @{accessType="Allow";users="?";permissions="Read"} -PSPath IIS:\ -location $FTPSiteName
	Add-Log "Allowed anonymous users read permissions to FTP $FTPSiteName root" -Level 3

	# Check for ftp folder
	if (!(Test-Path $FTPSitePhysPath)) 
		{
		Add-Log "ERROR:   FTP root $FTPSitePhysPath does not exist." -Level 1
		Add-Log "ERROR:   Aborting FTP site configuraion" -Level 1
		[Environment]::Exit("-1")
	}
	
	# Add dead end
	Add-Log "Trying to create FTP dead end folder $FTPSitePhysPath\DeadEnd" -Level 4
	New-Item "$FTPSitePhysPath\DeadEnd" -Type Directory -ErrorAction 'SilentlyContinue'
	
	#Create AccessCheck file
	New-Item "$FTPSitePhysPath\AccessCheck.txt" -Type File -ErrorAction 'SilentlyContinue'
	"This is the Storepoint FTP access check text file." | Out-File "$FTPSitePhysPath\AccessCheck.txt"
	"The true FTP structure is only available to computers specified in alias POS_STP_FtpAccess." | Out-File "$FTPSitePhysPath\AccessCheck.txt"
	Add-Log "Created AccessCheck.txt" -level 4

	#Set "List Virtual directories" in root (DisplayVirtualDirectories)
	Set-ItemProperty "IIS:\Sites\$FTPSiteName" -Name ftpServer.directoryBrowse.showFlags -Value 32
	Add-Log "Enabled Virtual Directory browsing" -Level 3

	# Set User Name Directory
	# 0 - StartInUsersDirectory
	# 1 - IsolateRootDirectoryOnly
	# 2 - ActiveDirectory
	# 3 - IsolateAllDirectories
	# 4 - None
	# 5 - Custom
	Set-ItemProperty "IIS:\Sites\$FTPSiteName" -Name ftpserver.userisolation.mode -Value 0
	Add-Log "Enabled User Name Directory mode" -Level 3
}


function Set-PriceBookFtpFolder
	{
	<#
		.SYNOPSIS
			Sets up the SOSIF Price book folders.
	
		.DESCRIPTION
			Creates the folders rcv, xmt and log required by SOSIF integration and adds them as
			virtual FTP folders.
	
		.PARAMETER  FTPSiteName
			FTP Site name where to add the virual folders.
	
		.PARAMETER  FTPpath
			The physical path of the folder in where to create the SOSIF folders.
	
		.PARAMETER  FtpVirtualFolder
			Array of virtual FTP folder names to use with SOSIF price book.
	
		.PARAMETER  RestrictedIP
			Array of IP:s for restricted FTP access.
	
		.EXAMPLE
			Get-Something -ParameterA 'One value' -ParameterB 32
	
		.EXAMPLE
			Get-Something 'One value' 32
	
		.INPUTS
			System.String,System.Array
	
		.OUTPUTS
			None
	
	#>
	
	param (
		[string]$FTPSiteName,
		[string]$FTPpath = "$ProgramFiles\Office", # $FTPpath = "$ProgramFilesX86\Office"
		[Array]$FtpVirtualFolder = ("rcv","xmt","log"),
		[Array]$RestrictedIP
	)
	
	# Clean out all current virtual directories
	Remove-Item "IIS:Sites\$FTPSiteName\default" -Force
	Add-Log "Current virtual direcory Default and subdirectories removed" -Level 1
	
	#Create default virtual root directory
	Create-FtpVirtualDirectory -FTPSiteName $FTPSiteName -PhysicalFTPpath "$FTPPath\rcv" -VirtualFolder "default" -RestrictedIP $RestrictedIP
	
	#Create virtual subfolders
	foreach ($Folder in $FtpVirtualFolder) # Create folders, virtual folders and set ACL
		{
		Create-FtpVirtualDirectory -FTPSiteName $FTPSiteName -PhysicalFTPpath "$FTPPath\$Folder" -VirtualFolder "default/$Folder" -RestrictedIP $RestrictedIP
	}
}


function Set-SarecFtpFolder
	{
	<#
		.SYNOPSIS
			Sets up SAREC FTP folder.
	
		.DESCRIPTION
			Creates a virtual FTP folder for SAREC and also a hidden SMB/CIFS share.
	
		.PARAMETER  FTPSiteName
			FTP Site name where to add the virual folders.
	
		.PARAMETER  FTPpath
			The physical path of the folder in where to create the SAREC folder.
	
		.PARAMETER  RestrictedIP
			Array of IP:s for restricted FTP access.
	
		.EXAMPLE
			Get-Something -ParameterA 'One value' -ParameterB 32
	
		.EXAMPLE
			Get-Something 'One value' 32
	
		.INPUTS
			System.String,System.Int32
	
		.OUTPUTS
			System.String
	
		.NOTES
			Additional information about the function go here.
	
		.LINK
			about_functions_advanced
	
		.LINK
			about_comment_based_help
	
	#>
	
	param (
		[String]$FTPSiteName,
		[String]$FTPPath  = "$ProgramFiles\Office",
		[Array]$RestrictedIP
	)
	
	# Create SAREC+ virtual folder
	Create-FtpVirtualDirectory -FTPSiteName $FTPSiteName -PhysicalFTPpath "$FTPPath\xmt\SAREC_Outbound" -VirtualFolder "default/SAREC_Outbound" -RestrictedIP $RestrictedIP
	
}# end function



function Set-SarecShare
	{ 
		<#
		.SYNOPSIS
			Sets up SAREC Share.
	
		.DESCRIPTION
			Creates a hidden SMB/CIFS SAREC share.
	
		.PARAMETER  ShareName
			Name of share to create. 
	
		.PARAMETER  FolderPath
			Path of folder to share as SAREC share.
	
		.EXAMPLE
			Get-Something -ParameterA 'One value' -ParameterB 32
	
		.EXAMPLE
			Get-Something 'One value' 32
	
		.INPUTS
			System.String,System.Int32
	
		.OUTPUTS
			System.String
	
		.NOTES
			Additional information about the function go here.
	
		.LINK
			about_functions_advanced
	
		.LINK
			about_comment_based_help
	
	#>
	
	param (
		[string]$ShareName = "XMT$",
		[string]$FolderPath
	)
	
	# Create SAREC+ folder share
	Set-Share -ShareName $ShareName -FolderPath $FolderPath -Access "Read" -Description "SAREC Share"
}


