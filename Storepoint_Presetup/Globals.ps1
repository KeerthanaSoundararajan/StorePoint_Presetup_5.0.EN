#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------


# Global Constants
	[string]$global:MyProjectName = "StorePoint_Presetup"
	[string]$global:MyName = "StorePoint_Presetup"

	[string]$global:MyLogFileFolder = "C:\IKEALogs\IFS"

	[string]$global:ProgramData = [Environment]::GetFolderPath('CommonApplicationData')
	[string]$global:MyProgramData = $ProgramData + "\IKEA\$MyProjectName\" + $MyVersion
#	[string]$global:MyProgramData = $ProgramData + "\IKEA\$MyBinaryName\" + $MyVersion

#	[string]$global:BOS_PriceBookPath = $ProgramFiles + "\Office" # Path is hardcoded :/

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
				$POS_STP_MissingSales_LoginURL
				$POS_STP_MissingSales_SessionURL
				$POS_STP_MissingSales_UploadURL
				$POS_STP_MissingSales_UserName
				$POS_STP_MissingSalse_UserPass
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

	# GeoID hashtable. http://msdn.microsoft.com/en-us/library/dd374073%28VS.85%29.aspx
	$Script:GeoID = @{
		2 = "Antigua and Barbuda";
		3 = "Afghanistan";
		4 = "Algeria";
		5 = "Azerbaijan";
		6 = "Albania";
		7 = "Armenia";
		8 = "Andorra";
		9 = "Angola";
		10 = "American Samoa";
		11 = "Argentina";
		12 = "Australia";
		14 = "Austria";
		17 = "Bahrain";
		18 = "Barbados";
		19 = "Botswana";
		20 = "Bermuda";
		21 = "Belgium";
		22 = "Bahamas, The";
		23 = "Bangladesh";
		24 = "Belize";
		25 = "Bosnia and Herzegovina";
		26 = "Bolivia";
		27 = "Myanmar";
		28 = "Benin";
		29 = "Belarus";
		30 = "Solomon Islands";
		32 = "Brazil";
		34 = "Bhutan";
		35 = "Bulgaria";
		37 = "Brunei";
		38 = "Burundi";
		39 = "Canada";
		40 = "Cambodia";
		41 = "Chad";
		42 = "Sri Lanka";
		43 = "Congo";
		44 = "Congo (DRC)";
		45 = "China";
		46 = "Chile";
		49 = "Cameroon";
		50 = "Comoros";
		51 = "Colombia";
		54 = "Costa Rica";
		55 = "Central African Republic";
		56 = "Cuba";
		57 = "Cape Verde";
		59 = "Cyprus";
		61 = "Denmark";
		62 = "Djibouti";
		63 = "Dominica";
		65 = "Dominican Republic";
		66 = "Ecuador";
		67 = "Egypt";
		68 = "Ireland";
		69 = "Equatorial Guinea";
		70 = "Estonia";
		71 = "Eritrea";
		72 = "El Salvador";
		73 = "Ethiopia";
		75 = "Czech Republic";
		77 = "Finland";
		78 = "Fiji Islands";
		80 = "Micronesia";
		81 = "Faroe Islands";
		84 = "France";
		86 = "Gambia, The";
		87 = "Gabon";
		88 = "Georgia";
		89 = "Ghana";
		90 = "Gibraltar";
		91 = "Grenada";
		93 = "Greenland";
		94 = "Germany";
		98 = "Greece";
		99 = "Guatemala";
		100 = "Guinea";
		101 = "Guyana";
		103 = "Haiti";
		104 = "Hong Kong S.A.R.";
		106 = "Honduras";
		108 = "Croatia";
		109 = "Hungary";
		110 = "Iceland";
		111 = "Indonesia";
		113 = "India";
		114 = "British Indian Ocean Territory";
		116 = "Iran";
		117 = "Israel";
		118 = "Italy";
		119 = "Côte d'Ivoire";
		121 = "Iraq";
		122 = "Japan";
		124 = "Jamaica";
		125 = "Jan Mayen";
		126 = "Jordan";
		127 = "Johnston Atoll";
		129 = "Kenya";
		130 = "Kyrgyzstan";
		131 = "North Korea";
		133 = "Kiribati";
		134 = "Korea";
		136 = "Kuwait";
		137 = "Kazakhstan";
		138 = "Laos";
		139 = "Lebanon";
		140 = "Latvia";
		141 = "Lithuania";
		142 = "Liberia";
		143 = "Slovakia";
		145 = "Liechtenstein";
		146 = "Lesotho";
		147 = "Luxembourg";
		148 = "Libya";
		149 = "Madagascar";
		151 = "Macao S.A.R.";
		152 = "Moldova";
		154 = "Mongolia";
		156 = "Malawi";
		157 = "Mali";
		158 = "Monaco";
		159 = "Morocco";
		160 = "Mauritius";
		162 = "Mauritania";
		163 = "Malta";
		164 = "Oman";
		165 = "Maldives";
		166 = "Mexico";
		167 = "Malaysia";
		168 = "Mozambique";
		173 = "Niger";
		174 = "Vanuatu";
		175 = "Nigeria";
		176 = "Netherlands";
		177 = "Norway";
		178 = "Nepal";
		180 = "Nauru";
		181 = "Suriname";
		182 = "Nicaragua";
		183 = "New Zealand";
		184 = "Palestinian Authority";
		185 = "Paraguay";
		187 = "Peru";
		190 = "Pakistan";
		191 = "Poland";
		192 = "Panama";
		193 = "Portugal";
		194 = "Papua New Guinea";
		195 = "Palau";
		196 = "Guinea-Bissau";
		197 = "Qatar";
		198 = "Reunion";
		199 = "Marshall Islands";
		200 = "Romania";
		201 = "Philippines";
		202 = "Puerto Rico";
		203 = "Russia";
		204 = "Rwanda";
		205 = "Saudi Arabia";
		206 = "St. Pierre and Miquelon";
		207 = "St. Kitts and Nevis";
		208 = "Seychelles";
		209 = "South Africa";
		210 = "Senegal";
		212 = "Slovenia";
		213 = "Sierra Leone";
		214 = "San Marino";
		215 = "Singapore";
		216 = "Somalia";
		217 = "Spain";
		218 = "St. Lucia";
		219 = "Sudan";
		220 = "Svalbard";
		221 = "Sweden";
		222 = "Syria";
		223 = "Switzerland";
		224 = "United Arab Emirates";
		225 = "Trinidad and Tobago";
		227 = "Thailand";
		228 = "Tajikistan";
		231 = "Tonga";
		232 = "Togo";
		233 = "São Tomé and Príncipe";
		234 = "Tunisia";
		235 = "Turkey";
		236 = "Tuvalu";
		237 = "Taiwan";
		238 = "Turkmenistan";
		239 = "Tanzania";
		240 = "Uganda";
		241 = "Ukraine";
		242 = "United Kingdom";
		244 = "United States";
		245 = "Burkina Faso";
		246 = "Uruguay";
		247 = "Uzbekistan";
		248 = "St. Vincent and the Grenadines";
		249 = "Venezuela";
		251 = "Vietnam";
		252 = "Virgin Islands";
		253 = "Vatican City";
		254 = "Namibia";
		257 = "Western Sahara (disputed)";
		258 = "Wake Island";
		259 = "Samoa";
		260 = "Swaziland";
		261 = "Yemen";
		263 = "Zambia";
		264 = "Zimbabwe";
		269 = "Serbia and Montenegro (Former)";
		270 = "Montenegro";
		271 = "Serbia";
		273 = "Curaçao";
		276 = "South Sudan";
		300 = "Anguilla";
		301 = "Antarctica";
		302 = "Aruba";
		303 = "Ascension Island";
		304 = "Ashmore and Cartier Islands";
		305 = "Baker Island";
		306 = "Bouvet Island";
		307 = "Cayman Islands";
		309 = "Christmas Island";
		310 = "Clipperton Island";
		311 = "Cocos (Keeling) Islands";
		312 = "Cook Islands";
		313 = "Coral Sea Islands";
		314 = "Diego Garcia";
		315 = "Falkland Islands (Islas Malvinas)";
		317 = "French Guiana";
		318 = "French Polynesia";
		319 = "French Southern and Antarctic Lands";
		321 = "Guadeloupe";
		322 = "Guam";
		323 = "Guantanamo Bay";
		324 = "Guernsey";
		325 = "Heard Island and McDonald Islands";
		326 = "Howland Island";
		327 = "Jarvis Island";
		328 = "Jersey";
		329 = "Kingman Reef";
		330 = "Martinique";
		331 = "Mayotte";
		332 = "Montserrat";
		334 = "New Caledonia";
		335 = "Niue";
		336 = "Norfolk Island";
		337 = "Northern Mariana Islands";
		338 = "Palmyra Atoll";
		339 = "Pitcairn Islands";
		340 = "Rota Island";
		341 = "Saipan";
		342 = "South Georgia and the South Sandwich Islands";
		343 = "St. Helena";
		346 = "Tinian Island";
		347 = "Tokelau";
		348 = "Tristan da Cunha";
		349 = "Turks and Caicos Islands";
		351 = "Virgin Islands, British";
		352 = "Wallis and Futuna";
		15126 = "Man, Isle of";
		19618 = "Macedonia, Former Yugoslav Republic of";
		21242 = "Midway Islands";
		30967 = "Sint Maarten (Dutch part)";
		31706 = "Saint Martin (French part)";
		7299303 = "Democratic Republic of Timor-Leste";
		10028789 = "Åland Islands";
		161832015 = "Saint Barthélemy";
		161832256 = "U.S. Minor Outlying Islands";
		161832258 = "Bonaire, Saint Eustatius and Saba"
	}
	
	#SOSIF Pwd hashtable
	$Script:SOSIF_Pwd = @{
		"AT" = "k'G0";
		"AU" = "k'F";
		"BE" = 'k$V';
		"CA" = 'k%R';
		"CH" = 'k%[7';
		"CN" = 'k%]';
		"CZ" = 'k%I';
		"DE" = 'k"V';
		"Delft" = 'k"V\Q1';
		"DK" = 'k"X';
		"ES" = 'k#@';
		"FI" = 'k Z';
		"FR" = 'k A';
		"GB" = 'k!Q0';
		"HR" = 'k.A';
		"HU" = 'k.F';
		"IE" = 'k/V';
		"IN" = 'k/]';
		"IT" = 'k/G0';
		"JP" = 'k,C';
		"KR" = 'k-A';
		"NL" = 'k(_0';
		"NO" = 'k(\';
		"PL" = 'k6_';
		"PT" = 'k6G';
		"RO" = 'k4\';
		"RS" = 'k4@';
		"RU" = 'k4F7';
		"SE" = 'k5V';
		"US" = 'k3@0'
	}
	
	# GeoID hashtable.
	$Script:GeoIdShort = @{
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
	$Script:MyLocaleGenericName = $MyLocaleName.remove(0,2).Insert(0,"xx")
	
	[string]$ComputerDomain = (Get-WmiObject Win32_ComputerSystem).Domain.split(".")[0].ToUpper()
	
	if ($ComputerDomain -like "IKEADT")
		{[int]$Script:TimeOut = 30} # Time out value for Pricebook download in IKEADT
	else
		{[int]$Script:TimeOut = 120} # Time out value for Pricebook download in IKEA

	# Get aliases
	if ($ENV:COMPUTERNAME.Split("-")[1] -like "nt4*") #BOS
		{$Script:POS_STP_Type = "Server"}
	elseif ($ENV:COMPUTERNAME.Split("-")[1] -like "nt1*") #GlobalClient
		{ $Script:POS_STP_Type = "GlobalClient" }
	else #Client
		{ $Script:POS_STP_Type = "Client" }
	
	$Script:REG_GeoID = Get-LocalAlias REG_GeoID -Mandatory
	$Script:REG_GeoID = [convert]::ToInt32($REG_GeoID.SubString(2),16)
	
	$Script:POS_STP_FiscalState = Get-LocalAlias POS_STP_FiscalState #will override GeoID

	if ($ENV:COMPUTERNAME.Split("-")[1] -notlike "nt4*") {# Client and POS
		$Script:POS_Server = Get-LocalAlias POS_STP_ServerName -Mandatory
	}
	
	
	
	$Script:POS_SiteName = Get-LocalAlias POS_STP_SiteName
	
	$Script:POS_SiteID = Get-LocalAlias POS_STP_SiteID
	
	$Script:POS_STP_RetailerID = Get-LocalAlias POS_STP_RetailerID
	
	if ($ENV:COMPUTERNAME -like "*if*"){
		$Script:POS_TerminalID = Get-LocalAlias POS_STP_TerminalID
	}

	# Calculated install params
	$Script:POS_BussinessName = Get-LocalAlias POS_STP_BusinessUnitName

	if (!$POS_BussinessName) {$Script:POS_BussinessName = ($ENV:COMPUTERNAME).Split("-")[0]}
	if (!$POS_SiteID) {$Script:POS_SiteID = $POS_BussinessName.SubString($POS_BussinessName.Length - 3,3)}

	
	[String]$SiteNumber = ""
	[int]$int = $null
	Add-Log "POS_SiteID: $POS_SiteID" -Level 4
	Add-Log "POS_STP_RetailerID: $POS_STP_RetailerID" -Level 4
	foreach ($char in $POS_SiteID.ToCharArray())
		{
		if ([int32]::TryParse($char, [ref]$int))# char can be used as integer use it as is
			{
			$SiteNumber = $SiteNumber + $char
			Add-Log "DEBUG:   Char: $char"  -Level 5
		}
		else  #if letter, use last digit of [char] number
			{
			$SiteNumber = $SiteNumber + ([string][int][char]$char)[-1]
			Add-Log ("DEBUG:   Char: $char   Int: " + [int][char]$char + "   Last: " + ([string][int][char]$char)[-1])  -Level 5
			Add-Log "DIAG:   POS_SiteID contains a letter and have been converted." -Level 4
		} # end if
	}# end foreach
	$Script:POS_SiteID = $SiteNumber
	Add-Log "DEBUG:   SiteNumber: $SiteNumber" -Level 5
	
	if (!$POS_SiteName) {$Script:POS_SiteName = "IFS" + $POS_SiteID}
	
	if ($ENV:COMPUTERNAME -like "*nt4*") #BOS check Pricebook DL
		{
		[Bool]$Script:POS_DownloadPricebook = [System.Convert]::ToBoolean((Get-RegValueData -RegKey $AliasRegKey -ValueName POS_STP_DownloadPricebook))
		if (!$POS_DownloadPricebook)
		{ Add-Log "WARNING:   Presetup will NOT wait for SOSIF Pricebook download" -Level 2 }
		
	}
	
	if ($ENV:COMPUTERNAME -like "*NT4*") { # BOS add missing sales structure
		$CountryShort = $GeoIdShort[$REG_GeoID]
		
		$Script:POS_STP_MissingSales_SessionURL = Get-LocalAlias -alias POS_STP_MissingSales_SessionURL -Mandatory
		$Script:POS_STP_MissingSales_UserName = Get-LocalAlias -alias POS_STP_MissingSales_UserName
		$Script:POS_STP_MissingSalse_UserPass = Get-LocalAlias -alias POS_STP_MissingSalse_UserPass
		$Script:POS_STP_MissingSales_LoginURL = Get-LocalAlias -alias POS_STP_MissingSales_LoginURL
		$Script:POS_STP_MissingSales_UploadURL = Get-LocalAlias -alias POS_STP_MissingSales_UploadURL
		$Script:SOSIF_Web_Service = $POS_STP_MissingSales_SessionURL.Split("/")[2]
		
		if (!$POS_STP_MissingSales_LoginURL) {# Optional alias LoginURL not specified
			$Script:POS_STP_MissingSales_LoginURL = "http://$SOSIF_Web_Service/HQCoreWS/Authorization/Login.asmx"
			Add-Log ("Constructed POS_MissingSales_LoginURL= $POS_STP_MissingSales_LoginURL") -Level 2
		}
		
		if (!$POS_STP_MissingSales_UploadURL) {# Optional alias UploadURL not specified
			$Script:POS_STP_MissingSales_UploadURL = "http://$SOSIF_Web_Service/HQCoreWS/StoreUpload/StoreUpload.asmx"
			Add-Log ("Constructed POS_STP_MissingSales_UploadURL= $POS_STP_MissingSales_UploadURL") -Level 2
		}
		
		if (!$POS_STP_MissingSales_UserName) {# Optional alias UserName not specified
			$Script:POS_STP_MissingSales_UserName = "WS$CountryShort"
			Add-Log ("Constructed POS_STP_MissingSales_UserName= $POS_STP_MissingSales_UserName") -Level 2
		}
		
		if (!$POS_STP_MissingSales_UserPass) {	# Optional alias UserPass not specified
			$Script:POS_STP_MissingSalse_UserPass = $SOSIF_Pwd[$CountryShort]
			Add-Log ("Constructed POS_STP_MissingSalse_UserPass= $POS_STP_MissingSalse_UserPass") -Level 2
		}
		
	} # endif Get Missing Sales
	
	# Set Storepoint InstallShield params
	$Script:POS_STP_SilentInstall = "1"
	$Script:POS_STP_Country = $GeoID[$REG_GeoID]
	if ($POS_STP_FiscalState) # Fiscal State will over ride generic Country selection
		{
		Add-Log "Country setting $POS_STP_Country over ridden with State Fiscal data $POS_STP_FiscalState" -Level 1
		$Script:POS_STP_Country = $POS_STP_FiscalState
	}
	$Script:POS_STP_PriceBook = "C:\\Program Files\\Office\\rcv" # Hard coded by HQimport script and Install Shield :/
	$Script:POS_STP_DisableMessageBox = "yes"
	$Script:POS_STP_DisableBoot = "yes"
	
	if (!($ENV:COMPUTERNAME -like "*IF0*")) # BOS or BOS Client
		{$Script:ConfigRegKey = "HKLM:SOFTWARE\Positive\VersionControl\BOSConfig"}
	else # POS
		{$Script:ConfigRegKey = "HKLM:SOFTWARE\Positive\VersionControl\POSConfig"}
	
	$Script:RetalixISRegKey = "HKLM:SOFTWARE\RetalixInstallShield"
	
	if ($env:COMPUTERNAME -like "*NT4*") {# Missing Sales keys are only set on BOS
		$Script:MissingSalesRegKey = "HKLM:SOFTWARE\Positive\WebServices\HQ"
	}
	
} # end function Set-ScriptVariable


function Remove-Presetup
	{
	<#
		.SYNOPSIS
			Removes any previous Storepoint presetup configuration.
	
		.DESCRIPTION
			Removes any previous Storepoint presetup configuration to make sure that a fresh configuration is
			used at reinstallations.
	
		.EXAMPLE
			Remove-Presetup
	
		.INPUTS
			None
	
		.OUTPUTS
			None
	
		.NOTES
			Deletes the registry keys containing the Storepoint presetup configuration.
	
	#>
	
	Remove-RegKey -RegKey $ConfigRegKey -Force
	
	Remove-RegKey -RegKey $RetalixISRegKey -Force
	
}# end function Remove-Presetup


function Set-Presetup
	{
	<#
		.SYNOPSIS
			Sets the Storepoint presetup configuration.
	
		.DESCRIPTION
			Sets the Storepoint presetup configuration needed based on if running a BOS Server,
			BOS Client or POS.
	
		.EXAMPLE
			Set-Presetup
	
		.INPUTS
			None
	
		.OUTPUTS
			None
	
		.NOTES
			If running on a BOS Server, will also call FTP configuration.
	
	#>
	
	Set-RegValueData -RegKey $ConfigRegKey -ValueName SilentInstall -ValueData $POS_STP_SilentInstall
	Set-RegValueData -RegKey $ConfigRegKey -ValueName Country -ValueData $POS_STP_Country
	if (!($ENV:COMPUTERNAME -like "*if*")) # not a POS
		{Set-RegValueData -RegKey $ConfigRegKey -ValueName BOSType -ValueData $POS_STP_Type}
	Set-RegValueData -RegKey $ConfigRegKey -ValueName SiteID -ValueData $POS_SiteID
	Set-RegValueData -RegKey $ConfigRegKey -ValueName SiteName -ValueData $POS_SiteName
	Set-RegValueData -RegKey $ConfigRegKey -ValueName HQRetailerID -ValueData $POS_STP_RetailerID
	
	if ($ENV:COMPUTERNAME -like "*nt4*") #BOS set Pricebook config
		{Set-RegValueData -RegKey $ConfigRegKey -ValueName PriceBook -ValueData	$POS_STP_PriceBook}
	
	
	
	if (!($ENV:COMPUTERNAME -like "*nt4*")) # POS or Client check for POS_Server name
		{
		if (!$POS_Server)
			{
			Add-Log "ERROR:   Alias POS_STP_ServerName missing." -Level 1
			Add-Log "ERROR:   ABORTING presetup. Storepoint setup will fail!" -Level 1
			
			Add-Log ("Process closing. Up time: " + $StopWatch.Elapsed.TotalSeconds + " seconds.") -Level 1
			return -1
		}
		Set-RegValueData -RegKey $ConfigRegKey -ValueName BOSSERVER -ValueData $POS_Server
	}


	Set-RegValueData -RegKey $RetalixISRegKey -ValueName DisableMessageBox -ValueData $POS_STP_DisableMessageBox
	Set-RegValueData -RegKey $RetalixISRegKey -ValueName DisableBoot -ValueData $POS_STP_DisableBoot


	if ($ENV:COMPUTERNAME -like "*nt4*") # BOS, find all tills for this BOS
		{
		# Get DN of any computer in BussinissUnit
		[string]$DNstr = Get-DN -cnName $POS_BussinessName -cnCategory "computer"

		# Construct Clients OU DN
		$OUstr = "OU=Clients," + ($DNstr.split(",")[2..99] -join ",")

		# Get all tills (computer objects and prestaged objects)
		$OU = [ADSI]("LDAP://"+$OUstr)
		$TillCol = $ou.PSbase.Children | where {$_.Name -like "*-IF0*" -and ($_.ObjectCategory -like "*computer*" -or $_.ObjectCategory -like "*person*")}

		$NumberOfTills = $TillCol.Count
		$TerminalNumberArray = $null
		$TerminalSequenceNumber = $null
		
		#Populate registry with all POS:es needed
		for ($i=1; $i -le $TillCol.Count; $i++)
			{	
			[string]$POSValueName = "POS" + $i
			[string]$MachineName = $TillCol[$i-1].name
			[string]$TerminalDescription = $TillCol[$i-1].description

#			if ($TillCol[$i-1].objectCategory -like "*person*") # then description also contains activationcode
#				{$TerminalDescription = $TerminalDescription.split(",")[-1].split(":")[-1].trimstart(' "').trimend('"')
#			}
			
			[string]$SiteID = $POS_SiteID
		
			# Check Till POS_Server
			$TillServer = Get-ICCAlias -ComputerName $MachineName -AliasName POS_STP_ServerName
			$TillServer = $TillServer.split(".")[0] # remove domain suffix if necessary
			
			if (!($TillServer -like $ENV:COMPUTERNAME)) # only add tills belonging to the BOS Server
				{
				$NumberOfTills--
				Add-Log "WARNING:   `$POS_STP_ServerName ($ENV:COMPUTERNAME) not found on $MachineName" -Level 2
				Add-Log "WARNING:   POS omitted from configuration!" -Level 2
				continue # with next Till in TillCol
			}# end if
			# end check POS_Server
			
			# Get TerminalNumber
			[int]$TerminalNumber = Get-ICCAlias -ComputerName $MachineName -AliasName POS_STP_TerminalID
		
			if (!$TerminalNumber) # TerminalId is missing, use computer number
				{
				$TerminalNumber = [INT]$MachineName.SubString($MachineName.Length -4,4)
				Add-Log "WARNING:   POS_STP_TerminalID not found on $MachineName" -Level 1
				Add-Log "WARNING:   TerminalID calculated from computer number." -Level 2
			}# end if
			
			if ($TerminalNumberArray -contains $TerminalNumber) # number is not unique
				{
				$NumberOfTills--
				Add-Log "ERROR:   TerminalID: $TerminalNumber configured with $MachineName is already added!" -Level 1
				Add-Log "ERROR:   POS omitted from configuration!" -Level 2
				continue # with next Till in TillCol
			}
			else
				{[Array]$TerminalNumberArray += $TerminalNumber} # add number to array of unique terminals
	
			if ($GroupID -ne "0")
				{[string]$TerminalName = "POS " + $TerminalNumber}
			else
				{
				[string]$TerminalName = "Calypso " + ($TerminalNumber)
				Add-Log "$Machinename GroupID defined as Calypso till." -Level 2
			}
			# end TerminalNumber
			
			# Site code example for store 012
			# Alias:Code:	Group name:		Short Name:
			#  1	   1	Calypso			Calypso
			#  0	  12	Rest012			Rest012
			# 01	1201	Bistro01201		Bistr01201
			# 02	1202	SFM01202		SFM01202
			# 03	1203	CoffeeBar01203	Cafe01203
			# 04	1204	Staff01204		Staff01204
			# 05	1205	External01205	Ext01205
			
#			switch ($GroupID) #Set real GroupID as POS_STP_Group combined with SiteID
#				{
#				"1" {$GroupID = "1"} # Calypso
#			
#				"0" {$GroupID = $SiteID} # POS Restaurant
#			
#				default {$GroupID = $SiteID + $GroupID} # POS Others
#			}
			
			# Get GroupID
			
			# 0	Calypso
			# 1	Restaurant
			# 2	Bistro
			# 3	SFM (Swedish Food Market)
			# 4	Cafe
			# 5	Staff
			# 6	External
		
			[string]$GroupID = Get-ICCAlias -ComputerName $MachineName -AliasName POS_STP_Group
			
			if (!$GroupID)
				{
				$GroupID = "1" # 1 - Restaurant
				Add-Log ("ERROR:   POS_STP_Group not found on $MachineName. Defaulting to 1 - Restaurant") -Level 1
			}
		
			# end GroupID
		
			[string]$LocationID = "0"
			
			$TerminalSequenceNumber++
			
			$POSvalue = "$TerminalSequenceNumber,$TerminalName,$GroupID,$LocationID,$SiteID,$MachineName"
			
			Set-RegValueData -RegKey $ConfigRegKey -ValueName $POSValueName -ValueData $POSvalue
			Add-Log ("Terminal added: " + $POSvalue) -Level 3
		} # endfor adding terminals

		Set-RegValueData -RegKey $ConfigRegKey -ValueName NumberOfTills -ValueData $NumberOfTills.ToString()
		if ($NumberOfTills -eq 0)
			{Add-Log "WARNING: NO tills found for BOS presetup configuration!" -Level 2}
	} # end find all tills for BOS

	if ($ENV:COMPUTERNAME -like "*IF0*")
		{
		if (!$POS_TerminalID) # TerminalId is missing, use computer number
			{
			$POS_TerminalID = [INT]$ENV:COMPUTERNAME.SubString($ENV:COMPUTERNAME.Length -4,4)
		}
		
		Set-RegValueData -RegKey $ConfigRegKey -ValueName TerminalID -ValueData $POS_TerminalID
		
		# Check BOS_SiteID
		$BOS_SiteID = Get-ICCAlias -ComputerName $POS_Server -AliasName POS_STP_SiteID
		Add-Log "SiteID at BOS is: $BOS_SiteID" -Level 5
		if (!$BOS_SiteID)
			{
			$BOS_BussinessUnitName = ($POS_Server.ToUpper()).Split("-")[0]
			$BOS_SiteID = $BOS_BussinessUnitName.SubString($BOS_BussinessUnitName.Length - 3,3)
			Add-Log "Calculated SiteID at BOS is: $BOS_SiteID" -Level 5
		}
		
#		if ($POS_SiteID -ne $BOS_SiteID)
#			{
#			Add-Log "ERROR:   SiteID: $POS_SiteID on till doesn't match SiteID: $BOS_SiteID on BOS $POS_Server" -Level 1
#			Add-Log "ERROR:   Presetup ABORTED. Storepoint setup will fail!" -Level 1
#			return -1 # POS presetup should be aborted at this stage
#		}
		# end check Till_SiteID
	} # end if *IF0*
	
	if ($ENV:COMPUTERNAME -like "*NT4*") {
		Set-RegValueData -RegKey $MissingSalesRegKey -ValueName SessionURL -ValueData $POS_STP_MissingSales_SessionURL
		Set-RegValueData -RegKey $MissingSalesRegKey -ValueName LoginUserName -ValueData $POS_STP_MissingSales_UserName
		Set-RegValueData -RegKey $MissingSalesRegKey -ValueName LoginUserPassword -ValueData $POS_STP_MissingSalse_UserPass
		Set-RegValueData -RegKey $MissingSalesRegKey -ValueName LoginURL -ValueData $POS_STP_MissingSales_LoginURL
		Set-RegValueData -RegKey $MissingSalesRegKey -ValueName StoreStatusUploadURL -ValueData $POS_STP_MissingSales_UploadURL
		Add-Log ("Added Missing Sales registry entries") -Level 1
		Add-Log ("SessionURL=$POS_STP_MissingSales_SessionURL") -Level 4
		Add-Log ("LoginUserName=$POS_STP_MissingSales_UserName") -Level 4
		Add-Log ("LoginUserPassword=$POS_STP_MissingSalse_UserPass") -Level 4
		Add-Log ("LoginURL=$POS_STP_MissingSales_LoginURL") -Level 4
		Add-Log ("StoreStatusUploadURL=$POS_STP_MissingSales_UploadURL") -Level 4
	}
	
} # end function Set-Presetup


function Invoke-FtpConfig
	{
	$MyExecutablePath = (Get-Process -Id $Pid).path
	$MyExecutable = $MyExecutablePath.Split("\")[-1]
	if ($MyExecutable -like "powershell.exe" -or $MyExecutable -like "scriptdriver32.exe") # script
		{
		$MyExecutablePathDir = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path.ToString())
		Start-MyProcess "$ENV:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe" -Argument "$MyExecutablePathDir\Storepoint_FTP_Config.Export.PS1"
	}
	else # binary
		{
		$MyExecutablePathDir = [System.IO.Path]::GetDirectoryName($MyExecutablePath)
		Start-MyProcess "$MyExecutablePathDir\Storepoint_FTP_Config.exe"
	}
}# end function Invoke-FtpConfig


function Wait-FtpSessionStart
	{
	[Array]$FTP_ClientIP = ""
	Add-Log "Waiting for FTP session to start..." -Level 3
	Add-Log "Timeout value: $TimeOut minutes" -Level 4
	
	$FTP_ClientIP = Get-NetworkStatistics -Port 21 | where {$_.state -eq "Established"}
	
	while (!$FTP_ClientIP -and ($StopWatch.Elapsed.TotalMinutes -le $TimeOut)) # no FTP session
		{
		$FTP_ClientIP = Get-NetworkStatistics -Port 21 | where {$_.state -eq "Established"}
		sleep 5
	}
	
	if ($FTP_ClientIP)
		{
		Add-Log ([string]$FTP_ClientIP[0]) -Level 5
		Add-Log "FTP session started" -Level 1
	}# end if
	
	if ($StopWatch.Elapsed.TotalMinutes -ge $TimeOut) 
		{
		Add-Log "ERROR:   FTP session start timed out" -Level 1
	}
}# end function Wait-FtpSessionStart


function Wait-SosifContent
	{
	[array]$PriceBookRcvFolder = ""
	Add-Log "Waiting for PriceBook Rcv content..." -Level 3
	while (!$PriceBookRcvFolder  -and ($StopWatch.Elapsed.TotalMinutes -le $TimeOut))
		{
		$PriceBookRcvFolder = Get-ChildItem "$POS_STP_PriceBook"
		sleep 5
	}
	Add-Log "PriceBook Rcv content incoming..." -Level 3
	if ($StopWatch.Elapsed.TotalMinutes -gt $TimeOut) 
		{Add-Log "ERROR: Pricebook Rcv content not received..." -Level 1}
}# end function Wait-SosifContent


function Wait-FtpSessionEnd
	{
	# Wait for SOSIF to end. Timeout 2 min
	Add-Log "Waiting for FTP session to end..." -Level 3
	
	while ($FTP_ClientIP  -and ($StopWatch.Elapsed.TotalMinutes -le $TimeOut))
		{
		$FTP_ClientIP = Get-NetworkStatistics | where {$_.localport -eq 21 -and $_.state -eq "Established"}
		sleep 5
	}# end while
	
	if (!$FTP_ClientIP) 
		{Add-Log "FTP session/s ended" -Level 1}
	
	if ($StopWatch.Elapsed.TotalMinutes -gt $TimeOut) 
		{Add-Log "WARNING:   FTP session end timed out" -Level 1}
}# end function Wait-FtpSessionEnd