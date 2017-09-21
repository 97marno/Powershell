$global:ComputerList = Get-Content c:\HostList.txt

# This holds the choices fro the Drop Down Menu

[array]$OperatingSystemArray = "-------------","Windows XP", "Windows 7"

# This function will grab a list of computers to work with from a .txt file

function Get-ComputerList {
    Write-Output "   List of Computers VMRest is going to be applied to:`n"
    Foreach ($Computer in $global:ComputerList) {
        Write-Output "     $Computer"
    }
    Write-Output "`n--------------------------------------------------------`n"
}

# This function will return the results of the $OperatingSystemArray and the execute commands based on the selection

function Get-OperatingSystems {

$Choice = $OSChoice.SelectedItem.ToString()

# Call correct function to run correct code

if ($Choice -match 'XP') {
    Write-Output "$Choice Base Machines selected"
    OS-WindowsXp
}
elseif ($Choice -match '7') {
    Write-Output "$Choice Base Machines selected"
    OS-Windows7
}
else {
    Write-Output "No valid Operating System Seleted"
 }
}

# This function will be called for the base machines that are running Windows XP

function OS-WindowsXp {
    Foreach ($Computer in $global:ComputerList) {
        Write-Output "Starting VMReset on $Computer"
    }
}

# This function will be called for the base machines that are running Windows 7

function OS-Windows7 {
    Foreach ($Computer in $global:ComputerList) {
       Write-Output "Starting VMReset on $Computer"
   }
}

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
[void][System.Windows.Forms.Application]::EnableVisualStyles()
[void][System.Windows.Forms.ComboBoxStyle]::DropDown

# This creates a new form

$Main = New-Object System.Windows.Forms.Form

# This sets the form options

$Main.minimumSize = New-Object System.Drawing.Size(800,600)
$Main.maximumSize = New-Object System.Drawing.Size(800,600)
$Main.Text = "VMWare Reset"
$Main.StartPosition = "CenterScreen"
$Main.ShowInTaskbar = $False


# This sets the drop down options

$OSChoice = New-Object System.Windows.Forms.ComboBox
$OSChoice.Location = New-Object System.Drawing.Size(400,10)
$OSChoice.Font = New-Object System.Drawing.Font("Courier New",16,0,3,0)
$OSChoice.Size = New-Object System.Drawing.Size(200,30)
$OSChoice.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList

# This For-Loop populates the $OSChoice items from $OperatingSystemArray

ForEach ($Item in $OperatingSystemArray) {
  $OSChoice.Items.Add($Item)
}

# This adds the $OSChoice Item to the gui

$Main.Controls.Add($OSChoice)

# This sets the $OSChoice label options

$OSChoiceLabel = New-Object System.Windows.Forms.Label
$OSChoiceLabel.Location = New-Object System.Drawing.Size(10,10)
$OSChoiceLabel.Font = New-Object System.Drawing.Font("Courier New",16,0,3,0)
$OSChoiceLabel.Size = New-Object System.Drawing.Size(300,30)
$OSChoiceLabel.Text = "Base Machine Operating System"

# This adds the $OSChoiceLabel Item to the gui

$Main.Controls.Add($OSChoiceLabel)

# This sets up the button options
$ExecuteButton = New-Object System.Windows.Forms.Button
$ExecuteButton.Location = New-Object System.Drawing.Size(650,10)
$ExecuteButton.Size = New-Object System.Drawing.Size(100,30)
$ExecuteButton.Text = "Execute Reset"
$ExecuteButton.Add_Click( {

    Get-OperatingSystems

    if ($SaveToCheckBox.Checked -eq $True) {
        Write-Output "Saving output to file"
    }
    else {
        Write-Output "Not saving output to file"
    }
})

# This adds the $ExecuteButton Item to the gui

$Main.Controls.Add($ExecuteButton)

# This sets up the $CloseButton Item to the gui



# This sets up the output window for the gui

$OutputBox = New-Object System.Windows.Forms.RichTextBox
$OutputBox.Text = ''
$OutputBox.Name = 'OutputBox'
$OutputBox.Font = New-Object System.Drawing.Font("Courier New",16,0,3,0)
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 760
$System_Drawing_Size.Height = 460
$OutputBox.Size = $System_Drawing_Size
$OutputBox.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 50
$OutputBox.Location = $System_Drawing_Point

# This adds the Output box to the GUI

$Main.Controls.Add($OutputBox)

# This adds a checkbox to the GUI

$SaveToCheckBox = New-Object System.Windows.Forms.CheckBox
$SaveToCheckBox.Text = 'Save to File?'
$SaveToCheckBox.Name = 'SaveToCheckBox'
$SaveToCheckbox.Font = New-Object System.Drawing.Font("Courier New",16,0,3,0)
$SaveToCheckBox.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 200
$System_Drawing_Size.Height = 30
$SaveToCheckBox.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 550
$System_Drawing_Point.Y = 530
$SaveToCheckBox.Location = $System_Drawing_Point

# Default is set to false if you want to log the output to a file set to $True

$SaveToCheckBox.Checked = $Flase

$Main.Controls.Add($SaveToCheckBox)

Get-ComputerList

# This function displays the output to a text box within the gui

function Write-Output {
    param([string]$msg)
    $OutputBox.Text += "$msg`n"
    $OutputBox.SelectionStart = $OutputBox.Text.Length - 1;
    $OutputBox.ScrollToCaret();
}

# This activates and shows the gui
$Main.Add_Shown({
$Main.Activate()
})
[void]$Main.ShowDialog() | Out-Null#
# Script1.ps1
#


EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'min server memory (MB)', N'2048'
GO
EXEC sys.sp_configure N'max server memory (MB)', N'4096'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO

