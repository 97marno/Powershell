[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')

$MainForm = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.RadioButton]$InstanceNamed = $null
[System.Windows.Forms.RadioButton]$InstanceDefault = $null
[System.Windows.Forms.GroupBox]$grpInstance = $null
[System.Windows.Forms.TextBox]$InstanceName = $null

[System.Windows.Forms.GroupBox]$grpEnv = $null
[System.Windows.Forms.RadioButton]$EnvProd = $null
[System.Windows.Forms.RadioButton]$EnvStage = $null
[System.Windows.Forms.RadioButton]$EnvTest = $null
[System.Windows.Forms.RadioButton]$EnvDev = $null

[System.Windows.Forms.GroupBox]$grpEdition = $null
[System.Windows.Forms.RadioButton]$EditionDev = $null
[System.Windows.Forms.RadioButton]$EditionEnt = $null
[System.Windows.Forms.RadioButton]$EditionStd = $null

[System.Windows.Forms.GroupBox]$grpDataDirs = $null
[System.Windows.Forms.ComboBox]$cboxInstDir = $null
[System.Windows.Forms.ComboBox]$cboxDataDir = $null 
[System.Windows.Forms.ComboBox]$cboxLogDir = $null
[System.Windows.Forms.ComboBox]$cboxTempDir = $null
[System.Windows.Forms.ComboBox]$cboxBkpDir = $null
[System.Windows.Forms.Label]$lblInstDir = $null
[System.Windows.Forms.Label]$lblDataDir = $null
[System.Windows.Forms.Label]$lblLogDir = $null
[System.Windows.Forms.Label]$lblTempDir = $null
[System.Windows.Forms.Label]$lblBkpDir = $null

[System.Windows.Forms.ComboBox]$cboxcollation = $null
[System.Windows.Forms.Label]$lblCollation = $null

[System.Windows.Forms.GroupBox]$GrpAccounts = $null
#[System.Windows.Forms.MaskedTextBox]$saPwd = $null
#[System.Windows.Forms.Label]$lblsaPwd = $null
[System.Windows.Forms.MaskedTextBox]$SvcPwd = $null
[System.Windows.Forms.Label]$lblSvcPwd = $null
[System.Windows.Forms.CheckBox]$CreateSvcAcc = $null
[System.Windows.Forms.TextBox]$SvcAcc = $null
[System.Windows.Forms.Label]$lblSvcAcc = $null

[System.Windows.Forms.Button]$btnOK = $null

function InitializeComponent
{
$grpInstance = New-Object -TypeName System.Windows.Forms.GroupBox
$InstanceDefault = New-Object -TypeName System.Windows.Forms.RadioButton
$InstanceNamed = New-Object -TypeName System.Windows.Forms.RadioButton
$InstanceName = New-Object -TypeName System.Windows.Forms.TextBox

$grpEnv = New-Object -TypeName System.Windows.Forms.GroupBox
$EnvProd = New-Object -TypeName System.Windows.Forms.RadioButton
$EnvStage = New-Object -TypeName System.Windows.Forms.RadioButton
$EnvTest = New-Object -TypeName System.Windows.Forms.RadioButton
$EnvDev = New-Object -TypeName System.Windows.Forms.RadioButton

$grpEdition = New-Object -TypeName System.Windows.Forms.GroupBox
$EditionDev = New-Object -TypeName System.Windows.Forms.RadioButton
$EditionEnt = New-Object -TypeName System.Windows.Forms.RadioButton
$EditionStd = New-Object -TypeName System.Windows.Forms.RadioButton

$grpDataDirs = New-Object -TypeName System.Windows.Forms.GroupBox
$cboxInstDir = New-Object -TypeName System.Windows.Forms.ComboBox
$cboxDataDir = New-Object -TypeName System.Windows.Forms.ComboBox
$cboxTempDir = New-Object -TypeName System.Windows.Forms.ComboBox
$cboxBkpDir = New-Object -TypeName System.Windows.Forms.ComboBox
$lblInstDir = New-Object -TypeName System.Windows.Forms.Label
$lblDataDir = New-Object -TypeName System.Windows.Forms.Label
$lblTempDir= New-Object -TypeName System.Windows.Forms.Label
$lblBkpDir = New-Object -TypeName System.Windows.Forms.Label
$cboxLogDir = New-Object -TypeName System.Windows.Forms.ComboBox
$lblLogDir = New-Object -TypeName System.Windows.Forms.Label

$lblCollation = New-Object -TypeName System.Windows.Forms.Label
$cboxcollation = New-Object -TypeName System.Windows.Forms.ComboBox

$GrpAccounts = New-Object -TypeName System.Windows.Forms.GroupBox
#$saPwd = New-Object -TypeName System.Windows.Forms.MaskedTextBox
#$lblsaPwd = New-Object -TypeName System.Windows.Forms.Label
$SvcPwd = New-Object -TypeName System.Windows.Forms.MaskedTextBox
$lblSvcPwd = New-Object -TypeName System.Windows.Forms.Label
$CreateSvcAcc = New-Object -TypeName System.Windows.Forms.CheckBox
$SvcAcc = New-Object -TypeName System.Windows.Forms.TextBox
$lblSvcAcc = New-Object -TypeName System.Windows.Forms.Label

$btnOK = New-Object -TypeName System.Windows.Forms.Button

$grpInstance.SuspendLayout()
$grpEnv.SuspendLayout()
$grpEdition.SuspendLayout()
$grpDataDirs.SuspendLayout()
$GrpAccounts.SuspendLayout()
$MainForm.SuspendLayout()
	
# -------------------- ICON --------------------
#
#	Icon generation and loading into form
#	Drawing.Pens (intx1, intey1, intx2,inty2)
#	(x1,y1) = specify starting point, (x2,y2) = specify ending point
# 
$bmp = New-Object System.Drawing.Bitmap(16,16)
	$g = [System.Drawing.Graphics]::FromImage($bmp)
	$g.drawline([System.Drawing.Pens]::Black,5,0,11,0)
	$g.drawline([System.Drawing.Pens]::Black,3,1,5,1)
	$g.drawline([System.Drawing.Pens]::Orange,6,1,10,1)
	$g.drawline([System.Drawing.Pens]::Black,11,1,12,1)
	$g.drawline([System.Drawing.Pens]::Black,2,2,4,2)
	$g.drawline([System.Drawing.Pens]::Orange,5,2,12,2)
	$g.drawline([System.Drawing.Pens]::Black,12,2,13,2)
	$g.drawline([System.Drawing.Pens]::Black,1,3,3,3)
	$g.drawline([System.Drawing.Pens]::Orange,4,3,13,3)
	$g.drawline([System.Drawing.Pens]::Black,13,3,14,3)
	$g.drawline([System.Drawing.Pens]::Black,1,4,3,4)
	$g.drawline([System.Drawing.Pens]::Orange,4,4,13,4)
	$g.drawline([System.Drawing.Pens]::Black,13,4,14,4)
	$g.drawline([System.Drawing.Pens]::Black,0,5,3,5)
	$g.drawline([System.Drawing.Pens]::Orange,4,5,14,5)
	$g.drawline([System.Drawing.Pens]::Black,14,5,15,5)
	$g.drawline([System.Drawing.Pens]::Black,0,6,4,6)
	$g.drawline([System.Drawing.Pens]::Orange,5,6,14,6)
	$g.drawline([System.Drawing.Pens]::Black,14,6,15,6)
	$g.drawline([System.Drawing.Pens]::Black,0,7,8,7)
	$g.drawline([System.Drawing.Pens]::Orange,9,7,14,7)
	$g.drawline([System.Drawing.Pens]::Black,14,7,15,7)
	$g.drawline([System.Drawing.Pens]::Black,0,8,10,8)
	$g.drawline([System.Drawing.Pens]::Orange,11,8,14,8)
	$g.drawline([System.Drawing.Pens]::Black,14,8,15,8)
	$g.drawline([System.Drawing.Pens]::Black,0,9,11,9)
	$g.drawline([System.Drawing.Pens]::Orange,12,9,14,9)
	$g.drawline([System.Drawing.Pens]::Black,14,9,15,9)
	$g.drawline([System.Drawing.Pens]::Black,0,10,11,10)
	$g.drawline([System.Drawing.Pens]::Orange,12,10,14,10)
	$g.drawline([System.Drawing.Pens]::Black,14,10,15,10)
	$g.drawline([System.Drawing.Pens]::Black,1,11,11,11)
	$g.drawline([System.Drawing.Pens]::Orange,12,11,13,11)
	$g.drawline([System.Drawing.Pens]::Black,13,11,14,11)
	$g.drawline([System.Drawing.Pens]::Black,1,12,11,12)
	$g.drawline([System.Drawing.Pens]::Orange,12,12,13,12)
	$g.drawline([System.Drawing.Pens]::Black,13,12,14,12)
	$g.drawline([System.Drawing.Pens]::Black,2,13,10,13)
	$g.drawline([System.Drawing.Pens]::Orange,11,13,12,13)
	$g.drawline([System.Drawing.Pens]::Black,12,13,13,13)
	$g.drawline([System.Drawing.Pens]::Black,3,14,12,14)
	$g.drawline([System.Drawing.Pens]::Black,5,15,11,15)
	
if($ico -eq ""){$ico = [System.Drawing.Icon]::FromHandle($bmp.GetHicon())}
#
# -------------------- INSTANCE --------------------
#
#grpInstance
#
$grpInstance.Controls.Add($InstanceNamed)
$grpInstance.Controls.Add($InstanceDefault)
$grpInstance.Controls.Add($InstanceName)
$grpInstance.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,20)
$grpInstance.Name = 'grpInstance'
$grpInstance.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(260,80)
$grpInstance.TabIndex = 0
$grpInstance.TabStop = $false
$grpInstance.Text = 'Instance'
#
#InstanceDefault
#
$InstanceDefault.AutoSize = $true
$InstanceDefault.Checked = $true
$InstanceDefault.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,20)
$InstanceDefault.Name = 'InstanceDefault'
$InstanceDefault.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(102,17)
$InstanceDefault.TabIndex = 1
$InstanceDefault.TabStop = $true
$InstanceDefault.Text = 'Default instance'
$InstanceDefault.UseVisualStyleBackColor = $true
#
#InstanceNamed
#
$InstanceNamed.AutoSize = $true
$InstanceNamed.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,40)
$InstanceNamed.Name = 'InstanceNamed'
$InstanceNamed.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(103,17)
$InstanceNamed.TabIndex = 2
$InstanceNamed.Text = 'Named Instance'
$InstanceNamed.UseVisualStyleBackColor = $true
#$InstanceNamed.Checked = $true
#
#InstanceName
#
$InstanceName.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(125,40)
$InstanceName.Name = 'InstanceName'
$InstanceName.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(118,20)
$InstanceName.TabIndex = 3
$InstanceName.Text = 'MSSQLSERVER'
$InstanceName.add_Click({$InstanceNamed.checked=$true}) 
#
# -------------------- ENVIRONMENT --------------------
#
#grpEnv
$grpEnv.Controls.Add($EnvProd)
$grpEnv.Controls.Add($EnvStage)
$grpEnv.Controls.Add($EnvTest)
$grpEnv.Controls.Add($EnvDev)
$grpEnv.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,110)
$grpEnv.Name = 'grpEnv'
$grpEnv.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(260,80)
$grpEnv.TabIndex = 4
$grpEnv.TabStop = $false
$grpEnv.Text = 'Environment'
#
#$EnvProd
#
$EnvProd.AutoSize = $true
$EnvProd.Checked = $true
$EnvProd.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,20)
$EnvProd.Name = 'EnvProd'
$EnvProd.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(102,17)
$EnvProd.TabIndex = 5
$EnvProd.TabStop = $true
$EnvProd.Text = 'Prod'
$EnvProd.UseVisualStyleBackColor = $true
$EnvProd.add_Click({
	$EditionDev.enabled=$false
	$EditionStd.checked=$true
}) 
#
#$EnvStage
#
$EnvStage.AutoSize = $true
$EnvStage.Checked = $false
$EnvStage.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,40)
$EnvStage.Name = 'EnvStage'
$EnvStage.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(102,17)
$EnvStage.TabIndex = 6
$EnvStage.TabStop = $true
$EnvStage.Text = 'Stage'
$EnvStage.UseVisualStyleBackColor = $true
$EnvStage.add_Click({
	$EditionDev.enabled=$false
	$EditionStd.checked=$true
}) 
#
#$EnvTest
#
$EnvTest.AutoSize = $true
$EnvTest.Checked = $false
$EnvTest.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(125,20)
$EnvTest.Name = 'EnvTest'
$EnvTest.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(102,17)
$EnvTest.TabIndex = 7
$EnvTest.TabStop = $true
$EnvTest.Text = 'Test'
$EnvTest.UseVisualStyleBackColor = $true
$EnvTest.add_Click({$EditionDev.enabled=$true}) 
#
#$EnvDev
#
$EnvDev.AutoSize = $true
$EnvDev.Checked = $false
$EnvDev.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(125,40)
$EnvDev.Name = 'EnvDev'
$EnvDev.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(102,17)
$EnvDev.TabIndex = 8
$EnvDev.TabStop = $true
$EnvDev.Text = 'Dev'
$EnvDev.UseVisualStyleBackColor = $true
$EnvDev.add_Click({$EditionDev.enabled=$true}) 
#
# -------------------- EDITION --------------------
#
#grpEdition
#
$grpEdition.Controls.Add($EditionDev)
$grpEdition.Controls.Add($EditionEnt)
$grpEdition.Controls.Add($EditionStd)
$grpEdition.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,200)
$grpEdition.Name = 'grpEdition'
$grpEdition.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(260,80)
$grpEdition.TabIndex = 9
$grpEdition.TabStop = $false
$grpEdition.Text = 'Edition'
#
#EditionStd
#
$EditionStd.AutoSize = $true
$EditionStd.Checked = $true
$EditionStd.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,20)
$EditionStd.Name = 'EditionStd'
$EditionStd.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(68,17)
$EditionStd.TabIndex = 10
$EditionStd.TabStop = $true
$EditionStd.Text = 'Standard'
$EditionStd.UseVisualStyleBackColor = $true
#
#EditionEnt
#
$EditionEnt.AutoSize = $true
$EditionEnt.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,40)
$EditionEnt.Name = 'EditionEnt'
$EditionEnt.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(72,17)
$EditionEnt.TabIndex = 11
$EditionEnt.Text = 'Enterprise'
$EditionEnt.UseVisualStyleBackColor = $true
#
#EditionDev
#
$EditionDev.AutoSize = $true
$EditionDev.Enabled = $false
$EditionDev.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(125,20)
$EditionDev.Name = 'EditionDev'
$EditionDev.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(74,17)
$EditionDev.TabIndex = 12
$EditionDev.Text = 'Developer'
$EditionDev.UseVisualStyleBackColor = $true
#
# -------------------- COLLATION --------------------
#
#lblCollation
#
$lblCollation.AutoSize = $true
$lblCollation.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,295)
$lblCollation.Name = 'lblCollation'
$lblCollation.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(47,13)
$lblCollation.TabIndex = 13
$lblCollation.Text = 'Collation'
$lblCollation.add_Click($label4_Click)
#
#cboxcollation
#
$cboxcollation.FormattingEnabled = $true
Foreach($collation in $collations) {$cboxcollation.Items.AddRange($collation)}
$cboxcollation.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(80,295)
$cboxcollation.Name = 'cboxcollation'
$cboxcollation.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(157,21)
$cboxcollation.TabIndex = 14
$cboxcollation.Sorted = $True
$cboxcollation.SelectedIndex = 0 # Select the first item by default
#
# -------------------- DATA DIRECTORIES --------------------
#
#$grpDataDirs
#
$grpDataDirs.Controls.Add($lblInstDir)
$grpDataDirs.Controls.Add($cboxInstDir)
$grpDataDirs.Controls.Add($lblDataDir)
$grpDataDirs.Controls.Add($cboxDataDir)
$grpDataDirs.Controls.Add($lblLogDir)
$grpDataDirs.Controls.Add($cboxLogDir)
$grpDataDirs.Controls.Add($lblTempDir)
$grpDataDirs.Controls.Add($cboxTempDir)
$grpDataDirs.Controls.Add($lblBkpDir)
$grpDataDirs.Controls.Add($cboxBkpDir)
$grpDataDirs.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,325)
$grpDataDirs.Name = 'grpDataDirs'
$grpDataDirs.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(260,150)
$grpDataDirs.TabIndex = 15
$grpDataDirs.TabStop = $false
$grpDataDirs.Text = 'Data Directories'
	#
	# -------------------- INSTALL DIR --------------------
	#
	#lblInstDir
	#
	$lblInstDir.AutoSize = $true
	$lblInstDir.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,20)
	$lblInstDir.Name = 'lblInstDir'
	$lblInstDir.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(50,15)
	$lblInstDir.TabIndex = 16
	$lblInstDir.Text = 'Install dir'
	#
	#cboxInstDir
	#
	$cboxInstDir.FormattingEnabled = $true
	Foreach($drive in $drives) {
	$cboxInstDir.Items.Add($drive.name)
	}
	$cboxInstDir.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(100,20)
	$cboxInstDir.Name = 'cboxInstDir'
	$cboxInstDir.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(130,20)
	$cboxInstDir.TabIndex = 17
	$cboxInstDir.SelectedIndex = 0 # Select the first item by default

	# -------------------- DATA DIR --------------------
	#
	#lblDataDir
	#
	$lblDataDir.AutoSize = $true
	$lblDataDir.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,45)
	$lblDataDir.Name = 'lblDataDir'
	$lblDataDir.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(50,15)
	$lblDataDir.TabIndex = 18
	$lblDataDir.Text = 'Data dir'
	#
	#cboxDataDir
	#
	$cboxDataDir.FormattingEnabled = $true
	Foreach($drive in $drives) {
	$cboxDataDir.Items.Add($drive.name)
	}
	$cboxDataDir.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(100,45)
	$cboxDataDir.Name = 'cboxDataDir'
	$cboxDataDir.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(130,20)
	$cboxDataDir.TabIndex = 19
	$cboxDataDir.SelectedIndex = 0 # Select the first item by default

	# -------------------- LOG DIR --------------------
	#
	#lblLogDir
	#
	$lblLogDir.AutoSize = $true
	$lblLogDir.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,70)
	$lblLogDir.Name = 'lblLogDir'
	$lblLogDir.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(50,15)
	$lblLogDir.TabIndex = 20
	$lblLogDir.Text = 'Log dir'
	#
	#cboxLogDir
	#
	$cboxLogDir.FormattingEnabled = $true
	Foreach($drive in $drives) {
	$cboxLogDir.Items.Add($drive.name)
	}
	$cboxLogDir.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(100,70)
	$cboxLogDir.Name = 'cboxLogDir'
	$cboxLogDir.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(130,20)
	$cboxLogDir.TabIndex = 21
	$cboxLogDir.SelectedIndex = 0 # Select the first item by default
	$cboxTempDir
	# -------------------- TEMP DIR --------------------
	#
	#$lblTempDir
	#
	$lblTempDir.AutoSize = $true
	$lblTempDir.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,95)
	$lblTempDir.Name = 'lblTempDir'
	$lblTempDir.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(50,15)
	$lblTempDir.TabIndex = 22
	$lblTempDir.Text = 'Temp dir'
	#
	#$cboxTempDir
	#
	$cboxTempDir.FormattingEnabled = $true
	Foreach($drive in $drives) {
	$cboxTempDir.Items.Add($drive.name)
	}
	$cboxTempDir.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(100,95)
	$cboxTempDir.Name = 'cboxTempDir'
	$cboxTempDir.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(130,20)
	$cboxTempDir.TabIndex = 23
	$cboxTempDir.SelectedIndex = 0 # Select the first item by default

	# -------------------- BACKUP DIR --------------------
	#
	#lblBkpDir
	#
	$lblBkpDir.AutoSize = $true
	$lblBkpDir.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,120)
	$lblBkpDir.Name = 'lblBkpDir'
	$lblBkpDir.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(50,15)
	$lblBkpDir.TabIndex = 24
	$lblBkpDir.Text = 'Backup dir'
	#
	#cboxBkpDir
	#
	$cboxBkpDir.FormattingEnabled = $true
	Foreach($drive in $drives) {
	$cboxBkpDir.Items.Add($drive.name)
	}
	$cboxBkpDir.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(100,120)
	$cboxBkpDir.Name = 'cboxBkpDir'
	$cboxBkpDir.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(130,20)
	$cboxBkpDir.TabIndex = 25
	$cboxBkpDir.SelectedIndex = 0 # Select the first item by default
#
# -------------------- ACCOUNTS --------------------
#
#GrpAccounts
#
#$GrpAccounts.Controls.Add($saPwd)
#$GrpAccounts.Controls.Add($lblsaPwd)
$GrpAccounts.Controls.Add($SvcPwd)
$GrpAccounts.Controls.Add($lblSvcPwd)
$GrpAccounts.Controls.Add($CreateSvcAcc)
$GrpAccounts.Controls.Add($SvcAcc)
$GrpAccounts.Controls.Add($lblSvcAcc)
$GrpAccounts.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,485)
$GrpAccounts.Name = 'GrpAccounts'
$GrpAccounts.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(320,105)
$GrpAccounts.TabIndex = 26
$GrpAccounts.TabStop = $false
$GrpAccounts.Text = 'Accounts'
#
#lblSvcAcc
#
$lblSvcAcc.AutoSize = $true
$lblSvcAcc.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,23)
$lblSvcAcc.Name = 'lblSvcAcc'
$lblSvcAcc.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(85,13)
$lblSvcAcc.TabIndex = 27
$lblSvcAcc.Text = 'Service account'
#
#SvcAcc
#
$SvcAcc.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(110,20)
$SvcAcc.Name = 'SvcAcc'
$SvcAcc.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(130,20)
$SvcAcc.TabIndex = 28
#
#lblSvcPwd
#
$lblSvcPwd.AutoSize = $true
$lblSvcPwd.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,49)
$lblSvcPwd.Name = 'lblSvcPwd'
$lblSvcPwd.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(53,13)
$lblSvcPwd.TabIndex = 29
$lblSvcPwd.text = 'Password'
$SvcAcc.Enabled = $false
#
#SvcPwd
#
$SvcPwd.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(110,46)
$SvcPwd.Name = 'SvcPwd'
$SvcPwd.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(130,20)
$SvcPwd.TabIndex = 30
$SvcPwd.PasswordChar = '*'
$SvcPwd.Enabled = $false
<#
#lblsaPwd
#
$lblsaPwd.AutoSize = $true
$lblsaPwd.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(20,75)
$lblsaPwd.Name = 'lblsaPwd'
$lblsaPwd.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(66,13)
$lblsaPwd.TabIndex = 5
$lblsaPwd.Text = 'sa password'
#
#saPwd
#
$saPwd.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(110,72)
$saPwd.Name = 'saPwd'
$saPwd.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(131,20)
$saPwd.TabIndex = 6
$saPwd.PasswordChar = '*'
#>
#CreateSvcAcc
#
$CreateSvcAcc.AutoSize = $true
$CreateSvcAcc.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(245,23)
$CreateSvcAcc.Name = 'CreateSvcAcc'
$CreateSvcAcc.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(57,17)
$CreateSvcAcc.TabIndex = 2
$CreateSvcAcc.Text = 'Create'
$CreateSvcAcc.UseVisualStyleBackColor = $true
$CreateSvcAcc.Checked = $true
$CreateSvcAcc.add_Click({
	if ($CreateSvcAcc.Checked -eq $true)
    {
        $SvcAcc.Enabled = $false
		$SvcPwd.Enabled = $false
		#$SvcAccStr = "svcSQL$env:COMPUTERNAME"
    }
    elseif ($CreateSvcAcc.Checked -eq $false)
    {
        $SvcAcc.Enabled = $true
		$SvcPwd.Enabled = $true
    }   
}) 
#
# -------------------- BUTTONS --------------------
#
#btnOK
#
$btnOK.Location = New-Object -TypeName System.Drawing.Point -ArgumentList @(246,600)
$btnOK.Name = 'btnOK'
$btnOK.Size = New-Object -TypeName System.Drawing.Size -ArgumentList @(75,40)
$btnOK.TabIndex = 31
$btnOK.Text = 'OK'
$btnOK.UseVisualStyleBackColor = $true
$btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
#
# -------------------- MAIN FORM --------------------
#
#MainForm
#
$MainForm.ClientSize = New-Object -TypeName System.Drawing.Size -ArgumentList @(350,700)
$MainForm.Controls.Add($btnOK)
#$MainForm.Controls.Add($lblLogDir)
#$MainForm.Controls.Add($cboxLogDir)
#$MainForm.Controls.Add($lblBkpDir)
#$MainForm.Controls.Add($lblDataDir)
#$MainForm.Controls.Add($lblInstDir)
#$MainForm.Controls.Add($cboxBkpDir)
#$MainForm.Controls.Add($lblTempDir)
#$MainForm.Controls.Add($cboxTempDir)
#$MainForm.Controls.Add($cboxDataDir)
#$MainForm.Controls.Add($cboxInstDir)
$MainForm.Controls.Add($grpInstance)
$MainForm.Controls.Add($grpEnv)
$MainForm.Controls.Add($grpEdition)
$MainForm.Controls.Add($cboxcollation)
$MainForm.Controls.Add($lblCollation)
$MainForm.Controls.Add($grpDataDirs)
$MainForm.Controls.Add($GrpAccounts)


$MainForm.Name = 'MainForm'
$MainForm.Text = "INSTALL SQL SERVER"
$MainForm.Icon = $ico
$grpDataDirs.ResumeLayout($false)
$grpDataDirs.PerformLayout()
$grpInstance.ResumeLayout($false)
$grpInstance.PerformLayout()
$grpEdition.ResumeLayout($false)
$grpEdition.PerformLayout()
$GrpAccounts.ResumeLayout($false)
$GrpAccounts.PerformLayout()
$MainForm.ResumeLayout($false)
$MainForm.PerformLayout()
$MainForm.AcceptButton = $btnOK
}

#If ($InstanceName.Select()) {[System.Windows.MessageBox]::Show("TEST")}  #{$InstanceNamed.checked()}


. InitializeComponent
