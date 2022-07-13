<#
 Created with: SAPIEN Technologies, Inc., PowerShell Studio 2012 v3.1.35
 Created on:   2009-08-04
 Created by:   James Brundage. Assembled as monolithic file by Dennis Lindqvist
 Organization: Microsoft
 Filename:     lib.SchedTask.ps1

  Rev 1.0.0.2	19:05 2016-09-23	Initial conversion.
  Rev 1.0.0.3	13:53 2016-10-17	Changed ErrorAction from Stop to Continue
  Rev 1.0.0.4	15:22 2016-12-13	Force initiate [__ComObject] type
  Rev 1.0.0.5	21:33 2016-12-13	Added -SYSTEM switch to Register-ScheduledTask()
  Rev 1.0.0.9	10:38 2016-12-14	Removed -SYSTEM switch and made Register-ScheduledTask() generic
  Rev 1.0.0.11	15:22 2016-12-14	RemoveScheduledTask also removes folder if empty
#>

# Global Constants
	[string]$global:libSchedTaskVer = "1.0.0.11"

# Initiate DataTypes
	$scheduleObject = New-Object -ComObject schedule.service
	Remove-Variable scheduleObject -Force

#region Load Functions

function Add-TaskAction
{
    <#
    .Synopsis
        Adds an action to a task definition
    .Description
        Adds an action to a task definition.
        You can create a task definition with New-Task, or use an existing definition from Get-ScheduledTask
    .Example
        New-Task -Disabled |
            Add-TaskTrigger  $EVT[0] |
            Add-TaskAction -Path Calc |
            Register-ScheduledTask "$(Get-Random)" 
    .Link
        Register-ScheduledTask
    .Link
        Add-TaskTrigger
    .Link
        Get-ScheduledTask
    .Link
        New-Task
    #>
    [CmdletBinding(DefaultParameterSetName="Script")]
    param(
    # The Scheduled Task Definition
    [Parameter(Mandatory=$true, 
        ValueFromPipeline=$true)]
    [__ComObject]
    $Task,
 
    # The script to run       
    [Parameter(Mandatory=$true,ParameterSetName="Script")]
    [ScriptBlock]
    $Script,
    
    # If set, will run PowerShell.exe with -WindowStyle Minimized
    [Parameter(ParameterSetName="Script")]
    [Switch]
    $Hidden,
    
    # If set, will run PowerShell.exe
    [Parameter(ParameterSetName="Script")]    
    [Switch]
    $Sta,
    
    # The path to the program.
    [Parameter(Mandatory=$true,ParameterSetName="Path")]
    [string]
    $Path,
    
    # The arguments to pass to the program.
    [Parameter(ParameterSetName="Path")]
    [string]
    $Arguments,    
    
    # The working directory the action will run in.  
    # By default, this will be the current directory
    [String]
    $WorkingDirectory = $PWD,
    
    # If set, the powershell script will not exit when it is completed
    [Parameter(ParameterSetName="Script")]
    [Switch]
    $NoExit,
    
    # The identifier of the task
    [String]
    $Id
    )
    
    begin {
        Set-StrictMode -Off
    }

    process {
        if ($Task.Definition) {  $Task = $Task.Definition }

        $Action = $Task.Actions.Create(0)
        if ($Id) { $Action.ID = $Id }
        $Action.WorkingDirectory = $WorkingDirectory
        switch ($psCmdlet.ParameterSetName) {
            Script {
                $action.Path = Join-Path $psHome "PowerShell.exe"
                $action.WorkingDirectory = $pwd
                $action.Arguments = ""
                if ($Hidden) {
                    $action.Arguments += " -WindowStyle Hidden"
                }
                if ($sta) {
                    $action.Arguments += " -Sta"
                }
                if ($NoExit) {
                    $Action.Arguments += " -NoExit"
                }
                $encodedScriptBlock = 
                $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($script))
                $action.Arguments+= " -encodedCommand $encodedCommand"
            }
            Path {
                $action.Path = $Path
                $action.Arguments = $Arguments
            }
        }
        $Task
    }
}


function Add-TaskTrigger
{
    <#
    .Synopsis
        Adds a trigger to an existing task.
    .Description
        Adds a trigger to an existing task.
        The task is outputted to the pipeline, so that additional triggers can be added.
    .Example
        New-task | 
            Add-TaskTrigger -DayOfWeek Monday, Wednesday, Friday -WeeksInterval 2 -At "3:00 PM" |
            Add-TaskAction -Script { Get-Process | Out-GridView } |
            Register-ScheduledTask TestTask    
    .Link
        Add-TaskAction
    .Link
        Register-ScheduledTask
    .Link
        New-Task
    #>
    [CmdletBinding(DefaultParameterSetName="OneTime")]
    param(
    # The Scheduled Task Definition.  A New definition can be created by using New-Task
    [Parameter(Mandatory=$true, 
        ValueFromPipeline=$true)]
    [Alias('Definition')]
    [__ComObject]
    $Task,
    
    # The At parameter is used as the start time of the task for several different trigger types.
    [Parameter(Mandatory=$true,ParameterSetName="Daily")]        
    [Parameter(Mandatory=$true,ParameterSetName="DayInterval")]    
    [Parameter(Mandatory=$true,ParameterSetName="Monthly")]
    [Parameter(Mandatory=$true,ParameterSetName="MonthlyDayOfWeek")]
    [Parameter(Mandatory=$true,ParameterSetName="OneTime")]    
    [Parameter(Mandatory=$true,ParameterSetName="Weekly")]
    [DateTime]
    $At,
    
    # Day of Week Trigger
    [Parameter(Mandatory=$true, ParameterSetName="Weekly")]
    [Parameter(Mandatory=$true, ParameterSetName="MonthlyDayOfWeek")]
    [ValidateSet("Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")]
    [string[]]
    $DayOfWeek,
    
    # If set, will only run the task N number of weeks
    [Parameter(ParameterSetName="Weekly")]
    [Int]
    $WeeksInterval = 1,
    
    # Months of Year
    [Parameter(Mandatory=$true, ParameterSetName="Monthly")]
    [Parameter(Mandatory=$true, ParameterSetName="MonthlyDayOfWeek")]
    [ValidateSet("January","February", "March", "April", "May", "June", 
        "July", "August", "September","October", "November", "December")]
    [string[]]
    $MonthOfYear,
    
    # The day of the month to run the task on
    [Parameter(Mandatory=$true, ParameterSetName="Monthly")]
    [ValidateRange(1,31)]
    [int[]]
    $DayOfMonth,
    
    # The weeks of the month to run the task on.  
    [Parameter(Mandatory=$true, ParameterSetName="MonthlyDayOfWeek")]    
    [ValidateRange(1,6)]
    [int[]]
    $WeekOfMonth,
    
    # The timespan to run the task in.
    [Parameter(Mandatory=$true,ParameterSetName="In")]
    [Timespan]
    $In,
        
    # If set, the task will trigger at a specific time every day
    [Parameter(ParameterSetName="Daily")]
    [Switch]
    $Daily,

    # If set, the task will trigger every N days
    [Parameter(ParameterSetName="DaysInterval")]    
    [Int]
    $DaysInterval,             
    
    # If set, a registration trigger will be created
    [Parameter(Mandatory=$true,ParameterSetName="Registration")]
    [Switch]
    $OnRegistration,
    
    # If set, the task will be triggered on boot
    [Parameter(Mandatory=$true,ParameterSetName="Boot")]
    [Switch]
    $OnBoot,
    
    # If set, the task will be triggered on logon.
    # Use the OfUser parameter to only trigger the task for certain users
    [Parameter(Mandatory=$true,ParameterSetName="Logon")]
    [Switch]
    $OnLogon,
    
    # In Session State tasks or logon tasks, determines what type of users will launch the task
    [Parameter(ParameterSetName="Logon")]
    [Parameter(ParameterSetName="StateChanged")]
    [string]
    $OfUser,
    
    # In Session State triggers, this parameter is used to determine what state change will trigger the task
    [Parameter(Mandatory=$true,ParameterSetName="StateChanged")]
    [ValidateSet("Connect", "Disconnect", "RemoteConnect", "RemoteDisconnect", "Lock", "Unlock")]
    [string]
    $OnStateChanged,
    
    # If set, the task will be triggered on Idle
    [Parameter(Mandatory=$true,ParameterSetName="Idle")]
    [Switch]
    $OnIdle,
    
    # If set, the task will be triggered whenever the event occurs.  To get an event record, use Get-WinEvent
    [Parameter(Mandatory=$true, ParameterSetName="Event")]
    [Diagnostics.Eventing.Reader.EventLogRecord]
    $OnEvent,
    
    # If set, the task will be triggered whenever the event query occurs.  The query is in xpath.
    [Parameter(Mandatory=$true, ParameterSetName="EventQuery")]
    [string]
    $OnEventQuery,

    # The interval the task should be repeated at.
    [Timespan]
    $Repeat,
    
    # The amount of time to repeat the task for
    [Timespan]
    $For,
    
    # The time the task should stop being valid
    [DateTime]
    $Until    
    )
    
    begin {
        Set-StrictMode -Off
    }
    process {
        if ($Task.Definition) {  $Task = $Task.Definition }
        
        switch ($psCmdlet.ParameterSetName) {
            StateChanged {
                $Trigger = $Task.Triggers.Create(11)
                if ($OfUser) {
                    $Trigger.UserID = $OfUser
                }
                switch ($OnStateChanged) {
                    Connect { $Trigger.StateChange = 1 }
                    Disconnect { $Trigger.StateChange = 2 }
                    RemoteConnect { $Trigger.StateChange = 3 }
                    RemoteDisconnect { $Trigger.StateChange = 4 }
                    Lock { $Trigger.StateChange = 7 }
                    Unlock { $Trigger.StateChange = 8 } 
                }
            }
            Logon {
                $Trigger = $Task.Triggers.Create(9)
                if ($OfUser) {
                    $Trigger.UserID = $OfUser
                }
            }
            Boot {
                $Trigger = $Task.Triggers.Create(8)
            }
            Registration {
                $Trigger = $Task.Triggers.Create(7)
            }
            OneTime {
                $Trigger = $Task.Triggers.Create(1)
                $Trigger.StartBoundary = $at.ToString("s")
            }            
            Daily {
                $Trigger = $Task.Triggers.Create(2)
                $Trigger.StartBoundary = $at.ToString("s")
                $Trigger.DaysInterval = 1
            }
            DaysInterval {
                $Trigger = $Task.Triggers.Create(2)
                $Trigger.StartBoundary = $at.ToString("s")
                $Trigger.DaysInterval = $DaysInterval                
            }
            Idle {
                $Trigger = $Task.Triggers.Create(6)
            }
            Monthly {
                $Trigger =  $Task.Triggers.Create(4)
                $Trigger.StartBoundary = $at.ToString("s")
                $value = 0
                foreach ($month in $MonthOfYear) {
                    switch ($month) {
                        January { $value = $value -bor 1 }
                        February { $value = $value -bor 2 }
                        March { $value = $value -bor 4 }
                        April { $value = $value -bor 8 }
                        May { $value = $value -bor 16 }
                        June { $value = $value -bor 32 }
                        July { $value = $value -bor 64 }
                        August { $value = $value -bor 128 }
                        September { $value = $value -bor 256 }
                        October { $value = $value -bor 512 } 
                        November { $value = $value -bor 1024 } 
                        December { $value = $value -bor 2048 } 
                    } 
                }
                $Trigger.MonthsOfYear = $Value
                $value = 0
                foreach ($day in $DayofMonth) {
                    $value = $value -bor ([Math]::Pow(2, $day - 1))
                }
                $Trigger.DaysOfMonth  = $value
            }
            MonthlyDayOfWeek {
                $Trigger =  $Task.Triggers.Create(5)
                $Trigger.StartBoundary = $at.ToString("s")
                $value = 0
                foreach ($month in $MonthOfYear) {
                    switch ($month) {
                        January { $value = $value -bor 1 }
                        February { $value = $value -bor 2 }
                        March { $value = $value -bor 4 }
                        April { $value = $value -bor 8 }
                        May { $value = $value -bor 16 }
                        June { $value = $value -bor 32 }
                        July { $value = $value -bor 64 }
                        August { $value = $value -bor 128 }
                        September { $value = $value -bor 256 }
                        October { $value = $value -bor 512 } 
                        November { $value = $value -bor 1024 } 
                        December { $value = $value -bor 2048 } 
                    } 
                }
                $Trigger.MonthsOfYear = $Value
                $value = 0
                foreach ($week in $WeekofMonth) {
                    $value = $value -bor ([Math]::Pow(2, $week - 1))
                }
                $Trigger.WeeksOfMonth = $value            
                $value = 0
                foreach ($day in $DayOfWeek) {
                    switch ($day) {
                        Sunday { $value = $value -bor 1 }
                        Monday { $value = $value -bor 2 }
                        Tuesday { $value = $value -bor 4 }
                        Wednesday { $value = $value -bor 8 }
                        Thursday { $value = $value -bor 16 }
                        Friday { $value = $value -bor 32 }
                        Saturday { $value = $value -bor 64 }
                    }   
                }
                $Trigger.DaysOfWeek = $value

            }
            Weekly {
                $Trigger = $Task.Triggers.Create(3)
                $Trigger.StartBoundary = $at.ToString("s")
                $value = 0
                foreach ($day in $DayOfWeek) {
                    switch ($day) {
                        Sunday { $value = $value -bor 1 }
                        Monday { $value = $value -bor 2 }
                        Tuesday { $value = $value -bor 4 }
                        Wednesday { $value = $value -bor 8 }
                        Thursday { $value = $value -bor 16 }
                        Friday { $value = $value -bor 32 }
                        Saturday { $value = $value -bor 64 }
                    }   
                }
                $Trigger.DaysOfWeek = $value
                $Trigger.WeeksInterval = $WeeksInterval
            }
            In {
                $Trigger = $Task.Triggers.Create(1)
                $at = (Get-Date) + $in
                $Trigger.StartBoundary = $at.ToString("s")
            }
            Event {
                $Query = $Task.Triggers.Create(0)
                $Query.Subscription = "
<QueryList>
    <Query Id='0' Path='$($OnEvent.LogName)'>
        <Select Path='$($OnEvent.LogName)'>
            *[System[Provider[@Name='$($OnEvent.ProviderName)'] and EventID=$($OnEvent.Id)]]
        </Select>
    </Query>
</QueryList>                
                "
            }
            EventQuery {
                $Query = $Task.Triggers.Create(0)
                $Query.Subscription = $OnEventQuery
            }
        }
        if ($Until) {
            $Trigger.EndBoundary = $until.ToString("s")
        }
        if ($Repeat.TotalSeconds) {
            $Trigger.Repetition.Interval = "PT$([Math]::Floor($Repeat.TotalHours))H$($Repeat.Minutes)M"
        }
        if ($For.TotalSeconds) {
            $Trigger.Repetition.Duration = "PT$([Math]::Floor($For.TotalHours))H$([int]$For.Minutes)M$($For.Seconds)S"
        }
        $Task
    }
}


function Connect-ToTaskScheduler
{
    <#
    .Synopsis
        Connects to the scheduler service on a computer
    .Description
        Connects to the scheduler service on a computer
    .Example
        Connect-ToTaskScheduler
    #>
    param(
    # The name of the computer to connect to.
    $ComputerName,
    
    # The credential used to connect
    [Management.Automation.PSCredential]
    $Credential    
    )   
    
    $scheduler = New-Object -ComObject Schedule.Service
    if ($Credential) { 
        $NetworkCredential = $Credential.GetNetworkCredential()
        $scheduler.Connect($ComputerName, 
            $NetworkCredential.UserName, 
            $NetworkCredential.Domain, 
            $NetworkCredential.Password)            
    } else {
        $scheduler.Connect($ComputerName)        
    }    
    $scheduler
}


function Get-RunningTask
{
    <#
    .Synopsis
        Gets the tasks currently running on the system
    .Description
        A Detailed Description of what the command does
    .Example
        Get-RunningTask
    #>
    param(
    #The name of the task.  By default, all running tasks are shown
    $Name = "*",

    # If this is set, hidden tasks will also be shown.  
    # By default, only tasks that are not marked by Task Scheduler as hidden are shown.
    [Switch]
    $Hidden,    
    
    # The name of the computer to connect to.
    $ComputerName,
    
    # The credential used to connect
    [Management.Automation.PSCredential]
    $Credential
    )        
    
    process {
        $scheduler = Connect-ToTaskScheduler -ComputerName $ComputerName -Credential $Credential        
        if ($scheduler -and $scheduler.Connected) {
            $scheduler.GetRunningTasks($Hidden -as [bool]) | Where-Object { 
                $_.Path -like $Name -or 
                (Split-Path $_.Path -Leaf) -like $name
            }
        }
    }    
} 
 

function Get-ScheduledTask
{
    <#
    .Synopsis
        Gets tasks scheduled on the computer
    .Description
        Gets scheduled tasks that are registered on a computer
    .Example
        Get-ScheduleTask -Recurse
    #>
    param(
    # The name or name pattern of the scheduled task
    [Parameter()]
    $Name = "*",
    
    # The folder the scheduled task is in
    [Parameter()]
    [String[]]
    $Folder = "",
    
    # If this is set, hidden tasks will also be shown.  
    # By default, only tasks that are not marked by Task Scheduler as hidden are shown.
    [Switch]
    $Hidden,    
    
    # The name of the computer to connect to.
    $ComputerName,
    
    # The credential used to connect
    [Management.Automation.PSCredential]
    $Credential,
    
    # If set, will get tasks recursively beneath the specified folder
    [switch]
    $Recurse
    )
    
    process {
        $scheduler = Connect-ToTaskScheduler -ComputerName $ComputerName -Credential $Credential            
        $taskFolder = $scheduler.GetFolder($folder)
        $taskFolder.GetTasks($Hidden -as [bool]) | Where-Object {
            $_.Name -like $name
        }
        if ($Recurse) {
            $taskFolder.GetFolders(0) | ForEach-Object {
                $psBoundParameters.Folder = $_.Path
                Get-ScheduledTask @psBoundParameters
            }
        }        
    }
} 


function New-Task
{
    <#
    .Synopsis
        Creates a new task definition.
    .Description
        Creates a new task definition.
        Tasks are not scheduled until Register-ScheduledTask is run.
        To add triggers use Add-TaskTrigger.  
        To add actions, use Add-TaskActions
    .Link
        Add-TaskTrigger
        Add-TaskActions
        Register-ScheduledTask
    .Example
        An example of using the command        
    #>
    param(
    # The name of the computer to connect to.
    $ComputerName,
    
    # The credential used to connect
    [Management.Automation.PSCredential]
    $Credential,
    
    # If set, the task will wake the computer to run
    [Switch]
    $WakeToRun,
    
    # If set, the task will run on batteries and will not stop when going on batteries
    [Switch]
    $RunOnBattery,
    
    # If set, the task will run only if connected to the network
    [Switch]
    $RunOnlyIfNetworkAvailable,
    
    # If set, the task will run only if the computer is idle
    [Switch]
    $RunOnlyIfIdle,
    
    # If set, the task will run after its scheduled time as soon as it is possible
    [Switch]
    $StartWhenAvailable,
    
    # The maximum amount of time the task should run
    [Timespan]
    $ExecutionTimeLimit = (New-TimeSpan),
    
    # Sets how the task should behave when an existing instance of the task is running.
    # By default, a 2nd instance of the task will not be started
    [ValidateSet("Parallel", "Queue", "IgnoreNew", "StopExisting")]
    [String]
    $MultipleInstancePolicy = "IgnoreNew",

    # The priority of the running task    
    [ValidateRange(1, 10)]
    [int]
    $Priority = 6,
    
    # If set, the new task will be a hidden task
    [Switch]
    $Hidden,
    
    # If set, the task will be disabled 
    [Switch]
    $Disabled,
    
    # If set, the task will not be able to be started on demand
    [Switch]
    $DoNotStartOnDemand,
    
    # If Set, the task will not be able to be manually stopped
    [Switch]
    $DoNotAllowStop
    )
        
    $scheduler = Connect-ToTaskScheduler -ComputerName $ComputerName -Credential $Credential            
    $task = $scheduler.NewTask(0)
    $task.Settings.Priority = $Priority
    $task.Settings.WakeToRun = $WakeToRun
    $task.Settings.RunOnlyIfNetworkAvailable = $RunOnlyIfNetworkAvailable
    $task.Settings.StartWhenAvailable = $StartWhenAvailable
    $task.Settings.Hidden = $Hidden
    $task.Settings.RunOnlyIfIdle = $RunOnlyIfIdle
    $task.Settings.Enabled = -not $Disabled
    if ($RunOnBattery) {
        $task.Settings.StopIfGoingOnBatteries = $false
        $task.Settings.DisallowStartIfOnBatteries = $false
    }
    $task.Settings.AllowDemandStart = -not $DoNotStartOnDemand
    $task.Settings.AllowHardTerminate = -not $DoNotAllowStop
    switch ($MultipleInstancePolicy) {
        Parallel { $task.Settings.MultipleInstances = 0 }
        Queue { $task.Settings.MultipleInstances = 1 }
        IgnoreNew { $task.Settings.MultipleInstances = 2}
        StopExisting { $task.Settings.MultipleInstances = 3 } 
    }
    $task
}


function Register-ScheduledTask 
{
    <#
    .Synopsis
        Registers a scheduled task.
	
    .Description
        Registers a scheduled task.
    #>
    param(
    # The name of the scheduled task to register inculding path
    [Parameter(Mandatory=$true,Position=0)]
    [string]
    $Name,
    
    # The Scheduled Task to Register
    [Parameter(ValueFromPipeline=$true,
        Mandatory=$true)]
    [__ComObject]
    $Task,
	
	# Task Creation Flag
	# 0x1 TASK_VALIDATE_ONLU
	# 0x2 TASK_CREATE
	# 0x4 TASK_UPDATE
	# 0x6 TASK_CREATE_OR_UPDATE
	# 0x8 TASK_DISABLE
	# 0x10 TASK_DONT_ADD_PRINCIPAL_ACE
	# 0x20 TASK_IGNORE_REGISTRATION_TRIGGERS
	[int]
	$TaskFlag = 6,
        
    # The name of the computer to connect to.
    [string[]]
    $ComputerName,
    
    # The credential used to connect
    [Management.Automation.PSCredential]
    $Credential,
	
	# The Username or Group (ONLY USED with clear password)
	[string]
	$UserName,
	
	# The Logon type for the task
	# 0 TASK_LOGON_NONE
	# 1 TASK_LOGON_PASSWORD
	# 2 TASK_LOGON_S4U
	# 3 TASK_LOGON_INTERACTIVE_TOKEN
	# 4 TASK_LOGON_GROUP
	# 5 TASK_LOGON_SERVICE_ACCOUNT
	# 6 TASK_LOGON_INTERACTIVE_TOKEN_OR_PASSWORD
	[ValidateSet(0,1,2,3,4,5,6)]
	[int]$LogonType = 5
    )  
    
    begin {
        Set-StrictMode -Off
    }
    process {
        if ($task.Definition) { $Task = $task.Definition } 
        foreach ($c in $computerName) {
			if ($Credential) {
				$scheduler = Connect-ToTaskScheduler -ComputerName $c -Credential $Credential            
			}
			else {
				$scheduler = Connect-ToTaskScheduler -ComputerName $c
			}
			
            if ($scheduler -and $scheduler.Connected) {
                $folder = $scheduler.GetFolder("")
                
				if ($UserName) {# Username can be added in addition to Credentials
					
					$folder.RegisterTaskDefinition($Name, 
                        $Task, 
                        $TaskFlag,
                        $UserName,
                        $null,
                        $LogonType,
                        $null)
					
					
				}
				else {
					
					$folder.RegisterTaskDefinition($Name, 
                        $Task, 
                        $TaskFlag,
                        $credential.UserName,
                        $credentail.GetNetworkCredential().Password,
                        $LogonType,
                        $null)
				}
				
            } 
        }
    }
}


function Remove-Task
{
    <#
    .Synopsis
        Removes a scheduled task
    .Description
        Removes a scheduled task from the computer.
    .Example
        New-Task | 
            Add-TaskAction -Script { 
                Get-Process | Out-GridView
                Start-Sleep 100
            } | 
            Register-ScheduledTask (Get-Random) |
            Remove-Task
    #>
    [CmdletBinding(DefaultParameterSetName="Task")]
    param(
    # The Name of the task to remove
    [Parameter(Mandatory=$true, 
        ParameterSetName="Name")]
    [String]
    $Name,
    
    # The scheduled task to remove.  This value can be supplied with the output of Get-ScheduledTask
    [Parameter(ParameterSetName="Task", 
        ValueFromPipeline=$true)]
    $Task,
        
    # The folder the scheduled task is in
    [Parameter()]
    [String[]]
    $Folder = "",
    
    # If this is set, hidden tasks will also be shown.  
    # By default, only tasks that are not marked by Task Scheduler as hidden are shown.
    [Switch]
    $Hidden,    
    
    # The name of the computer to connect to.
    $ComputerName,
    
    # The credential used to connect
    [Management.Automation.PSCredential]
    $Credential,
    
    # If set, will get tasks recursively beneath the specified folder
    [switch]
    $Recurse
    )
    
    process {
        switch ($psCmdlet.ParameterSetName) {
            Task { 
                $scheduler = Connect-ToTaskScheduler -ComputerName $ComputerName -Credential $Credential
				$FolderPath = $Task.Path.SubString(0,($Task.Path.Length) - ($Task.Name.Length) -1) 
                $folder =$scheduler.GetFolder($FolderPath)
                $folder.DeleteTask($task.Name, 0)
				
				if (($Folder.GetTasks($true)).count -eq 0) {# empty folder, delete it
					$Folder.DeleteFolder("",$null)
				}
            }
            Name {
                Get-ScheduledTask @PSBoundParameters | 
                    Remove-Task
            }
        }
    }
}


function Start-Task
{
    <#
    .Synopsis
        Starts a scheduled task
    .Description
        Starts running a scheduled task.
        The input to the command is the output of Get-ScheduledTask.
    .Example
        New-Task | 
            Add-TaskAction -Script { 
                Get-Process | Out-GridView
                Start-Sleep 100
            } | 
            Register-ScheduledTask (Get-Random) |
            Start-Task
    #>    
    param(
    # The Task to start.  To get tasks, use Get-ScheduledTask 
    [Parameter(ValueFromPipeline=$true,
        Mandatory=$true)]
    [__ComObject]
    $Task
    )
    
    process {
        $Task.Run(0)
    }
}


function Stop-Task
{
    <#
    .Synopsis
        Stops a scheduled task
    .Description
        Stops a scheduled task or a running task.  Scheduled tasks can be supplied with Get-Task and 
        
    .Example
        # Note, this is an example of the syntax.  You should never stop all running tasks, 
        # as they are used by the operating system.  Instead, use a filter to get the tasks
        Get-RunningTask | Stop-Task 
    #>    
    param(
    # The Task to stop.  The task can either be from the result of Get-ScheduledTask or Get-RunningTask
    [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
    [__ComObject]
    $Task
    )
    
    process {
        if ($Task.PSObject.TypeNames -contains 'System.__ComObject#{9c86f320-dee3-4dd1-b972-a303f26b061e}') {
            $Task.Stop(0)
        } else {
            $Task.Stop()
        }
    }
}

#endregion

#region Format and DataType

$SchedTaskFormat = @'
<Configuration>
    <ViewDefinitions>
        <View>
            <Name>System.__ComObject#{9c86f320-dee3-4dd1-b972-a303f26b061e}</Name>
            <ViewSelectedBy>
                <TypeName>System.__ComObject#{9c86f320-dee3-4dd1-b972-a303f26b061e}</TypeName>
            </ViewSelectedBy>        
            <TableControl>
                <TableHeaders>
                    <TableColumnHeader/>
                    <TableColumnHeader/>
                    <TableColumnHeader/>
                    <TableColumnHeader/>
                </TableHeaders>
                <TableRowEntries>
                    <TableRowEntry>
                        <TableColumnItems>
                            <TableColumnItem>
                                 <PropertyName>Name</PropertyName>
                            </TableColumnItem>
                            <TableColumnItem>
                                 <PropertyName>Status</PropertyName>
                            </TableColumnItem>
                            <TableColumnItem>
                                <PropertyName>LastRunTime</PropertyName>
                            </TableColumnItem>                            
                            <TableColumnItem>
                                <PropertyName>NextRunTime</PropertyName>
                            </TableColumnItem>                            
                        </TableColumnItems>
                    </TableRowEntry>
                </TableRowEntries>
            </TableControl>
        </View>
    </ViewDefinitions>
</Configuration>
'@

$SchedTaskFormat | Out-File "$env:TEMP\SchedTask.Format.ps1xml" -Force -ErrorAction 'Stop'
Update-FormatData "$env:TEMP\SchedTask.Format.ps1xml" -ErrorAction 'Continue'

$SchedTaskTypes = @'
<Types>
  <Type>
    <Name>System.__ComObject#{9c86f320-dee3-4dd1-b972-a303f26b061e}</Name>
    <Members>
      <ScriptProperty>
        <Name>Status</Name>
        <GetScriptBlock>
             switch ($this.State) { 
                1 { return "Disabled" }
                2 { return "Queued" }
                3 { return "Ready" } 
                4 { return "Running" }
                default { return "Unknown" } 
             }
        </GetScriptBlock>
      </ScriptProperty>      
    </Members>
  </Type> 
</Types>
'@

$SchedTaskTypes | Out-File "$env:TEMP\SchedTask.Types.ps1xml" -Force -ErrorAction 'Stop'
Update-TypeData "$env:TEMP\SchedTask.Types.ps1xml" -ErrorAction 'Continue'

#endregion