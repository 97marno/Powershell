function OnApplicationLoad {
#Note: This function is not called in Projects
#Note: This function runs before the form is created
#Note: To get the script directory in the Packager use: Split-Path $hostinvocation.MyCommand.path
#Note: To get the console output in the Packager (Windows Mode) use: $ConsoleOutput (Type: System.Collections.ArrayList)
#Important: Form controls cannot be accessed in this function
#TODO: Add snapins and custom code to validate the application load

return $true #return true for success or false for failure
}
function OnApplicationExit {
#Note: This function is not called in Projects
#Note: This function runs after the form is closed
#TODO: Add custom code to clean up and unload snapins when the application exits

$script:ExitCode = 0 #Set the exit code for the Packager
}

$form1_Load={
#TODO: Initialize Form Controls here
Build-Table

}
#region Control Helper Functions
function Show-NotifyIcon
{
<#
.SYNOPSIS
Displays a NotifyIcon's balloon tip message in the taskbar's notification area.

.DESCRIPTION
Displays a NotifyIcon's a balloon tip message in the taskbar's notification area.

.PARAMETER BalloonTipText
Sets the text to display in the balloon tip.

.PARAMETER BalloonTipTitle
Sets the Title to display in the balloon tip.

.PARAMETER BalloonTipIcon 
The icon to display in the ballon tip.
#>
param(
[Parameter(Mandatory = $true, Position = 0)]
[ValidateNotNull()]
[System.Windows.Forms.NotifyIcon]$NotifyIcon,
[Parameter(Position = 1)]
[String]$BalloonTipText,
[Parameter(Position = 2)]
[String]$BalloonTipTitle,
[Parameter(Position = 3)]
[System.Windows.Forms.ToolTipIcon]$BalloonTipIcon
)

if($NotifyIcon.Icon -eq $null)
{
#Set a Default Icon otherwise the ballon will not show
$NotifyIcon1.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon([System.Windows.Forms.Application]::ExecutablePath)
}

if($BalloonTipText -ne $null -and $BalloonTipText.Length -ne 0)
{
$notifyicon1.BalloonTipText = $BalloonTipText 
}

if($BalloonTipTitle -ne $null -and $BalloonTipTitle.Length -ne 0)
{
$notifyicon1.BalloonTipTitle = $BalloonTipTitle 
}

if($BalloonTipIcon -ne $null -and $BalloonTipIcon.Length -ne 0)
{
$notifyicon1.BalloonTipIcon = $BalloonTipIcon 
}

$notifyicon1.ShowBalloonTip(0)
}

function Load-DataGridView{
<#
.SYNOPSIS
This functions helps you load items into a DataGridView.

.DESCRIPTION
Use this function to dynamically load items into the DataGridView control.

.PARAMETER DataGridView
The ComboBox control you want to add items to.

.PARAMETER Item
The object or objects you wish to load into the ComboBox's items collection.

.PARAMETER DataMember
Sets the name of the list or table in the data source for which the DataGridView is displaying data.

#>
Param (
[Parameter(Mandatory=$true)]
[System.Windows.Forms.DataGridView]$DataGridView,
[Parameter(Mandatory=$true)]
$Item,
[Parameter(Mandatory=$false)]
[string]$DataMember
)
$DataGridView.SuspendLayout()
$DataGridView.DataMember = $DataMember

if ($Item -is [System.ComponentModel.IListSource]`
-or $Item -is [System.ComponentModel.IBindingList] -or $Item -is [System.ComponentModel.IBindingListView] )
{
$DataGridView.DataSource = $Item
}
else
{
$array = New-Object System.Collections.ArrayList

if ($Item -is [System.Collections.IList])
{
$array.AddRange($Item)
}
else
{ 
$array.Add($Item) 
}
$DataGridView.DataSource = $array
}

$DataGridView.ResumeLayout()
}

function Build-Table{

$datagridview1.Rows.Clear()
1..8 | %{$datagridview1.Rows.Add($_,$_+1,$_+2,$_+3,$_+4)}
}

#endregion

$TotalTime = 10 #in seconds
$x = 1

$button1_Click={

Build-Table
}

$timer1_Tick={

#Use Get-Date for Time Accuracy
[TimeSpan]$span = $script:StartTime - (Get-Date)

#Update the display
$textbox1.Text = "{0:N0}" -f $span.TotalSeconds

if($span.TotalSeconds -le 0)
{
$timer1.Stop()
Build-Table
$textbox2.Text = "Count:$x";$x++

$TotalTime = 10
$script:StartTime = (Get-Date).AddSeconds($TotalTime)
$timer1.Start()
}
}

$checkbox1_CheckedChanged={

$NotifyIcon = New-Object System.Windows.Forms.NotifyIcon
$notifyicon1.Icon = New-object System.Drawing.Icon("icon.ico")
$BalloonTipText = "TipText"
$BalloonTipTitle = "TipTitle"
$BalloonTipIcon = "Info"

If($checkbox1.Checked){

$script:StartTime = (Get-Date).AddSeconds($TotalTime)

$button1.Enabled = $false
$button1.Text = "Auto"

$timer1.Start()

Start-Sleep 5
Show-NotifyIcon $NotifyIcon $BalloonTipText $BalloonTipTitle $BalloonTipIcon
$form1.WindowState = "Minimized"
$form1.ShowInTaskbar = $false
}

If(!$checkbox1.Checked){

$timer1.Stop()

$button1.Enabled = $true
$button1.Text = "Refresh"

$checkbox1.Text = "Auto Refresh: "
}
}

$notifyicon1_MouseDoubleClick=[System.Windows.Forms.MouseEventHandler]{
#Event Argument: $_ = [System.Windows.Forms.MouseEventArgs]
#TODO: Place custom script here
$form1.ShowInTaskbar = $true
$form1.WindowState = "Normal"
} 