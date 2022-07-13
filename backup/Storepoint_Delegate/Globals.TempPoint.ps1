<#
.NOTES 
  Created with: SAPIEN Technologies, Inc., PowerShell Studio 2012 v3.1.34
  Created on:   2016-10-05 15:16
  Created by:   Dennis Lindqvist
  Organization: 
  Filename: 
  Version: 3.0.0.1
 Rev 3.0.0.12	15:30 2016-14-11	Remote access desktop user group added
 Rev 3.0.0.13	11:54 2016-16-11	Remove delegate handled
 Rev 3.0.0.19	10:14 2016-17-11	Remove delegate commandline parameter string corrected, 
									Remote desktop user group will work for nt machine only
 Rev 3.0.0.20   12:11 2016-05-12    Code to change the RDU at installatoin 
 Rev 3.0.0.21   12:47 2016-05-12    Code cleanup and corrected issue of removal of old users of Remote desktop users
 
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
	[string]$global:MyProjectName = "Presetup"
	[string]$global:MyName = "Presetup_Delegate"

	[string]$global:MyLogFileFolder = "C:\IKEALogs\IFS"

	[string]$global:MyProgramData = $ProgramData + "\IKEA\$MyProjectName\" + $MyVersion
#	[string]$global:MyProgramData = $ProgramData + "\IKEA\$MyBinaryName\" + $MyVersion

	[string]$global:MyVersion = "3,0,0,21"

	# should actually use 
	# Set-Variable global:MyVersion -Value ([string]"0,3,0,8") -option Constant
	# but that's to messy to read :(

# Global variables

function Set-ScriptVariable
{
	<#
		.SYNOPSIS
			Set the aliases for the script.
	
		.DESCRIPTION
			Set the following script variables
				$GeoID
				$TimeOut
				$POS_STP_Type
				$REG_GeoID, ICC Alias REG_GeoID
				$POS_STP_FiscalState, ICC Alias POS_STP_FiscalState
				$POS_Server, ICC Alias POS_STP_ServerName
				$POS_SiteName, ICC Alias POS_STP_SiteName
				$POS_SiteID, ICC Alias POS_STP_SiteID
				$POS_TerminalID, ICC Alias POS_STP_TerminalID
				$POS_BussinessName, ICC Alias POS_STP_BusinessUnitName
				$POS_DownloadPricebook, ICC Alias POS_STP_DownloadPricebook
				$POS_STP_SilentInstall
				$POS_STP_Country
				$POS_STP_PriceBook
				$POS_STP_DisableMessageBox
				$POS_STP_DisableBoot
				$ConfigRegKey
				$RetalixISRegKey
				
									
		.EXAMPLE
			Set-ScriptAlias
	
		.INPUTS
			None
	
		.OUTPUTS
			None
	
		.NOTES
			https://icchandbook.ikea.com/kb/SitePages/DisplayPopUpPage.aspx?KBID=121&IsDlg=1
	
	#>
	
	$Script:AliasRegKey = "HKLM:\SOFTWARE\IKEA\IDEM\Config\Aliases"
	
	Set-LogLevel
	
	# GeoID hashtable.
	$Script:GeoIDHash = @{
		2 = "AG";
		3 = "AF";
		4 = "DZ";
		5 = "AZ";
		6 = "AL";
		7 = "AM";
		8 = "AD";
		9 = "AO";
		10 = "AS";
		11 = "AR";
		12 = "AU";
		14 = "AT";
		17 = "BH";
		18 = "BB";
		19 = "BW";
		20 = "BM";
		21 = "BE";
		22 = "BS";
		23 = "BD";
		24 = "BZ";
		25 = "BA";
		26 = "BO";
		27 = "MM";
		28 = "Benin";
		29 = "BY";
		30 = "SB";
		32 = "BR";
		34 = "BT";
		35 = "BG";
		37 = "BN";
		38 = "BI";
		39 = "CA";
		40 = "KH";
		41 = "TD";
		42 = "LK";
		43 = "CG";
		44 = "CD";
		45 = "CN";
		46 = "CL";
		49 = "CM";
		50 = "KM";
		51 = "CO";
		54 = "CR";
		55 = "CF";
		56 = "CU";
		57 = "CV";
		59 = "CY";
		61 = "DK";
		62 = "DJ";
		63 = "DM";
		65 = "DO";
		66 = "EC";
		67 = "EG";
		68 = "IE";
		69 = "GQ";
		70 = "EE";
		71 = "ER";
		72 = "SV";
		73 = "ET";
		75 = "CZ";
		77 = "FI";
		78 = "FJ";
		80 = "FM";
		81 = "FO";
		84 = "FR";
		86 = "GM";
		87 = "GA";
		88 = "GE";
		89 = "GH";
		90 = "GI";
		91 = "GD";
		93 = "GL";
		94 = "DE";
		98 = "GR";
		99 = "GT";
		100 = "GN";
		101 = "GY";
		103 = "HT";
		104 = "HK";
		106 = "HN";
		108 = "HR";
		109 = "HU";
		110 = "IS";
		111 = "ID";
		113 = "IN";
		114 = "IO";
		116 = "IR";
		117 = "IL";
		118 = "IT";
		119 = "CI";
		121 = "IQ";
		122 = "JP";
		124 = "JM";
		125 = "SJ";
		126 = "JO";
		127 = "Johnston Atoll";
		129 = "KE";
		130 = "KG";
		131 = "KP";
		133 = "KI";
		134 = "KR";
		136 = "KW";
		137 = "KZ";
		138 = "Laos";
		139 = "LB";
		140 = "LV";
		141 = "LT";
		142 = "LR";
		143 = "SK";
		145 = "LI";
		146 = "LS";
		147 = "LU";
		148 = "LY";
		149 = "MG";
		151 = "MO";
		152 = "MD";
		154 = "MN";
		156 = "MW";
		157 = "ML";
		158 = "MC";
		159 = "MA";
		160 = "MU";
		162 = "MR";
		163 = "MT";
		164 = "OM";
		165 = "MV";
		166 = "MX";
		167 = "MY";
		168 = "MZ";
		173 = "NE";
		174 = "VU";
		175 = "NG";
		176 = "NL";
		177 = "NO";
		178 = "NP";
		180 = "NR";
		181 = "SR";
		182 = "NI";
		183 = "NZ";
		184 = "Palestinian Authority";
		185 = "PY";
		187 = "PE";
		190 = "PK";
		191 = "PL";
		192 = "PA";
		193 = "PT";
		194 = "PG";
		195 = "PW";
		196 = "GW";
		197 = "QA";
		198 = "RE";
		199 = "MH";
		200 = "RO";
		201 = "PH";
		202 = "PR";
		203 = "RU";
		204 = "RW";
		205 = "SA";
		206 = "PM";
		207 = "KN";
		208 = "SC";
		209 = "ZA";
		210 = "SN";
		212 = "SI";
		213 = "SL";
		214 = "SM";
		215 = "SG";
		216 = "SO";
		217 = "ES";
		218 = "LC";
		219 = "SD";
		220 = "SJ";
		221 = "SE";
		222 = "SY";
		223 = "CH";
		224 = "AE";
		225 = "TT";
		227 = "TH";
		228 = "TJ";
		231 = "TO";
		232 = "Togo";
		233 = "São Tomé and Príncipe";
		234 = "TN";
		235 = "TR";
		236 = "TV";
		237 = "TW";
		238 = "TM";
		239 = "TZ";
		240 = "UG";
		241 = "UA";
		242 = "GB";
		244 = "US";
		245 = "BF";
		246 = "UY";
		247 = "UZ";
		248 = "VC";
		249 = "VE";
		251 = "VN";
		252 = "VI";
		253 = "VA";
		254 = "NA";
		257 = "EH";
		258 = "Wake Island";
		259 = "WS";
		260 = "SZ";
		261 = "YE";
		263 = "ZM";
		264 = "ZW";
		269 = "Serbia and Montenegro (Former)";
		270 = "ME";
		271 = "RS";
		273 = "Curaçao";
		276 = "SS";
		300 = "AI";
		301 = "AQ";
		302 = "AW";
		303 = "Ascension Island";
		304 = "Ashmore and Cartier Islands";
		305 = "Baker Island";
		306 = "BV";
		307 = "KY";
		309 = "CX";
		310 = "Clipperton Island";
		311 = "CC";
		312 = "CK";
		313 = "Coral Sea Islands";
		314 = "Diego Garcia";
		315 = "FK";
		317 = "GF";
		318 = "PF";
		319 = "French Southern and Antarctic Lands";
		321 = "GP";
		322 = "GU";
		323 = "Guantanamo Bay";
		324 = "GG";
		325 = "HM";
		326 = "Howland Island";
		327 = "Jarvis Island";
		328 = "JE";
		329 = "Kingman Reef";
		330 = "MQ";
		331 = "YT";
		332 = "MS";
		334 = "NC";
		335 = "NU";
		336 = "NF";
		337 = "MP";
		338 = "Palmyra Atoll";
		339 = "PN";
		340 = "Rota Island";
		341 = "Saipan";
		342 = "GS";
		343 = "SH";
		346 = "Tinian Island";
		347 = "TK";
		348 = "Tristan da Cunha";
		349 = "TC";
		351 = "VG";
		352 = "WF";
		15126 = "IM";
		19618 = "MK";
		21242 = "Midway Islands";
		30967 = "SX";
		31706 = "MF";
		7299303 = "TL";
		10028789 = "Åland Islands";
		161832015 = "Saint Barthélemy";
		161832256 = "UM";
		161832258 = "BQ"
		
	}
	
	
	
	$Script:MyLocaleName = Get-RegValueData -RegKey "HKCU:\Control Panel\International" -ValueName LocaleName
	$Script:MyLocaleGenericName = $MyLocaleName.remove(0, 2).Insert(0, "xx")
	
	# Get aliases
	if ($ENV:COMPUTERNAME.Split("-")[1] -like "nt4*") #BOS
	{ $Script:POS_STP_Type = "Server" }
	else
	{ $Script:POS_STP_Type = "Client" }
	
	$Script:REG_GeoID = Get-LocalAlias REG_GeoID -Mandatory
	$Script:REG_GeoID = [convert]::ToInt32($REG_GeoID.SubString(2), 16)
	Add-Log ("Evaluated Reg_GeoID after convertion from Hexadecimal to int: $REG_GeoID") -Level 5
	
	if ($ENV:COMPUTERNAME.Split("-")[1] -notlike "nt4*")
	{
		# Client and POS
		$Script:POS_Server = Get-LocalAlias POS_STP_ServerName -Mandatory
	}
	
	
	#Add code to handle GeoID from POS_STP_Country , use Hashtable
	$Script:POS_STP_Country = $GeoIDHash[$REG_GeoID]
	
	Add-Log("Evaluated Output from Hashtable for Reg_GeoID: $POS_STP_Country") -Level 5
	if (!$POS_STP_Country)
	{
		
		If ($env:COMPUTERNAME.StartsWith("*IT*")) # Computer ITXX
		{
			$POS_STP_Country = $env:COMPUTERNAME.Substring(2, 2)
		}
		If ($env:COMPUTERNAME.StartsWith("*RET*")) # Computer RETXX
		{
			$POS_STP_Country = $env:COMPUTERNAME.Substring(3, 2)
		}
	}
} # end function Set-ScriptVariable

function modify-localgroup
{
<#
.NOTES 
  Created with: SAPIEN Technologies, Inc., PowerShell Studio 2012 v3.1.31
  Created on:   2014-03-24 19:46
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
 
  Rev 0.1.0.1 2014-03-24 19:46    Initial version
  Rev 0.1.0.2 20:19 2014-03-24    Made the parameters mandatory
  Rev 0.1.0.4 20:59 2014-03-24    Added return codes
  Rev 0.1.0.5 21:11 2014-03-24    Packaged as Command to return exit codes
  Rev 0.1.0.6 21:12 2014-03-24    Removed exit codes
  Rev 0.1.0.8 21:17 2014-03-24    Added error message for missing action
 
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
	
	
	
	Param (
		[Parameter(Mandatory = $true)]
		[String]$localGroup = "",
		[Parameter(Mandatory = $true)]
		[String]$adObject = "",
		[Parameter(Mandatory = $true)]
		[String]$Action = ""
	)
	
	$Domain = ([adsi]'').name[0]
	$Computer = $ENV:COMPUTERNAME
	
	$localGroupObj = [ADSI]"WinNT://$computer/$localGroup,group"
	$adObjectPath = ([ADSI]"WinNT://$domain/$adObject").path
	
	switch ($Action)
	{
		
		"Add"
		{
			add-log ("Add Action Started") -level 5
			
			$localGroupObj.add($adObjectPath)
		}
		"Remove"
		{
			add-log ("Remove Action Started") -level 5
			$localGroupObj.remove($adObjectPath)
		}
		default
		{
			add-log ("ERROR: $Action is missing or wrong") -level 5
			'ERROR: $Action is missing or wrong' }
	}
	
}

function Invoke-Delegate
{
	$MyExecutablePath = (Get-Process -Id $Pid).path
	$MyExecutable = $MyExecutablePath.Split("\")[-1]
	if ($MyExecutable -like "powershell.exe" -or $MyExecutable -like "scriptdriver32.exe") # script
	{
		$MyExecutablePathDir = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path.ToString())
		Start-MyProcess "$ENV:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe" -Argument "$MyExecutablePathDir\Storepoint_Delegate.PS1"
	}
	else # binary
	{
		$MyExecutablePathDir = [System.IO.Path]::GetDirectoryName($MyExecutablePath)
		Start-MyProcess "$MyExecutablePathDir\Storepoint_Delegate.exe"
	}
} # end function Invoke-Delegate

function Remove-Delegate
{
	modify-localgroup -localGroup "Administrators" -adObject "A-StorepointSupport" -Action "Remove"
	Add-Log ("Remove usergroup to the local Administrators") -Level 1
	if ($ENV:COMPUTERNAME -like "*nt*")
	{
		modify-localgroup -localGroup "Remote Desktop Users" -adObject "A-StorepointBOS-$POS_STP_Country" -Action "Remove"
		Add-Log ("Remove usergroup to the Remote Desktop Users") -Level 1
	}
}

function Add-Delegate
{
	modify-localgroup -localGroup "Administrators" -adObject "A-StorepointSupport" -Action "Add"
	Add-Log ("Add usergroup to the local Administrators") -Level 1
	if ($ENV:COMPUTERNAME -like "*nt*")
	{
		$members = Get-LocalMembers -LocalGroup "Remote Desktop Users"
		$currGroup = $members | Where-Object{ $_ -like "A-StorepointBOS*" }
		if ($currGroup)
		{
			Add-Log ("Found preadded Remote Desktop Users group") -Level 4
			foreach ($Group in $currGroup) {
				modify-localgroup -localGroup "Remote Desktop Users" -adObject $Group -Action "Remove"
				Add-Log ("$Group was removed from Remote Desktop Users") -Level 4
			} 
		}
		modify-localgroup -localGroup "Remote Desktop Users" -adObject ("A-StorepointBOS-$POS_STP_Country") -Action "Add"
		Add-Log ("Add usergroup to the Remote Desktop Users") -Level 1
		Add-Log ("Country was evaluated to $POS_STP_Country") -Level 5
		Add-Log ("Store point BOS group was evaluated to A-StorepointBOS-$POS_STP_Country") -Level 5
	}
}

function Get-LocalMembers ($LocalGroup)
{
	$Computer = $ENV:COMPUTERNAME
	$group = [ADSI]"WinNT://$Computer/$localgroup,group"
	
	$members = $group.psbase.Invoke("Members") | ForEach-Object { $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) }
	return $members
}




