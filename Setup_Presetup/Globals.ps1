<#
.NOTES 
  Created with: SAPIEN Technologies, Inc., PowerShell Studio 2012 v3.1.34
  Created on:   2016-11-14 16:12
  Created by:   Dennis Lindqvist
  Organization: 
  Filename: 

  Requirements:
	o	

  Dependencies:
	[Dependencies here]

  Aliases used:
	[ICC4 specific registry settings used by the script]

  Known issues:
	[Issues not yet solved]

  Online Help: 
	http://technet.microsoft.com/en-us/magazine/hh500719.aspx

  Rev 3.0.0.1	16:12 2016-11-14	Initial version
  Rev 3.0.0.2   12:56 2016-11-16    Corrected binary name spelling
  Rev 3.0.0.4	15:30 2016-12-13	Rebuilt with new version of SchedTask lib
  Rev 3.0.0.5	15:54 2016-12-13	Corrected path to Storepoint_Delegate
  Rev 3.0.0.7	09:53 2016-12-14	Adding Scheduled task as SYSTEM
  Rev 3.0.0.9	15:30 2016-12-14	Removes Scheduled Task folder as well when it's empty
									Fixed not launching newly created task
  Rev 3.0.0.11	19:43 2016-12-15	Cleaned out unnessesary alias
									Added exit log on removal as well
									Changed remove task to be runs as SYSTEM

.SYNOPSIS
  [Short description]

.DESCRIPTION
  [Long description]

.PARAMETER [None]
  [Paramters and syntax for script]

.EXAMPLE
  [Examples of using script]
  [Just add more EXAMPLE]


.INPUTS 
  [Type of input data required] 
 
.OUTPUTS 
  [Output data generated]
#>

#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------


#Sample function that provides the location of the script
function Get-ScriptDirectory
{ 
	if($hostinvocation -ne $null)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory


# Global Constants
	[string]$global:MyProjectName = "ModuleName"
	[string]$global:MyName = "Setup_Presetup"

	[string]$global:MyVersion = "3,0,0,11"

	[string]$global:MyLogFileFolder = "C:\IKEALogs\IFS"

	[string]$global:ProgramData = [Environment]::GetFolderPath('CommonApplicationData')
	[string]$global:MyProgramData = $ProgramData + "\IKEA\$MyProjectName\" + $MyVersion
#	[string]$global:MyProgramData = $ProgramData + "\IKEA\$MyName\" + $MyVersion


function Set-ScriptVariable {
	<#
		.SYNOPSIS
			Set the aliases for the script.
	
		.DESCRIPTION
			Set the following aliases
			  $POSshellApplication, ICC alias POS_Shell_Application
	
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
	
}# _Set-ScriptVariable
