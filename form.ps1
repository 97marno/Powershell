[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")  
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void] [System.Windows.Forms.Application]::EnableVisualStyles() 


# Parameters
# =========================================== 
	$computername = Get-WmiObject -Class Win32_ComputerSystem | select name 
	$Networks = Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.ipenabled}
	$textnot = Get-content -Path ".\notification.txt" -Encoding UTF8 |fl | out-string;
	$serialnumber = Get-WmiObject -Class Win32_BIOS | Select SerialNumber

# Fonts
# ===========================================
$FontNormal = New-Object System.Drawing.Font("Calibri",12) 
$FontBold = New-Object System.Drawing.Font("Calibri",12,[System.Drawing.FontStyle]::Bold) 
$FontH1 = New-Object System.Drawing.Font("Calibri",14,[System.Drawing.FontStyle]::Bold) 
$ico = "" #"c:\temp\Temperature-1.ico"
$logo = "c:\temp\logo.png"

#Make icon
#	Drawing.Pens (intx1, inty1, intx2,inty2)
#	(x1,y1) = specify starting point, (x2,y2) = specify ending point
# ===========================================
$bmp = New-Object System.Drawing.Bitmap(16,16)
			$g = [System.Drawing.Graphics]::FromImage($bmp)
			$g.drawline([System.Drawing.Pens]::Black,4,0,12,0)
			$g.drawline([System.Drawing.Pens]::Black,3,1,13,1)
			$g.drawline([System.Drawing.Pens]::Black,2,2,14,2)
			$g.drawline([System.Drawing.Pens]::Black,1,3,12,3)
			$g.drawline([System.Drawing.Pens]::Orange,12,3,13,3)
			$g.drawline([System.Drawing.Pens]::Black,13,3,15,3)
			$g.drawline([System.Drawing.Pens]::Black,1,4,12,4)
			$g.drawline([System.Drawing.Pens]::Orange,12,4,14,4)
			$g.drawline([System.Drawing.Pens]::Black,14,4,15,4)
			
			#$g.drawline([System.Drawing.Pens]::Black,1,2,14,2)
			#$g.drawline([System.Drawing.Pens]::Black,1,3,14,3)
			#$g.drawline([System.Drawing.Pens]::Black,7,4,7,14)
			#$g.drawline([System.Drawing.Pens]::Black,8,4,8,14)
			#$g.drawline([System.Drawing.Pens]::Black,9,4,9,14)
	if($ico -eq ""){$ico = [System.Drawing.Icon]::FromHandle($bmp.GetHicon())}


#Form
Add-Type -AssemblyName System.Windows.Forms


$Form = New-Object system.Windows.Forms.Form
$Form.Text = "SDP - Contact: 076- 007 09 55"
$form.Name = "form"
$form.Icon = $ico
$Form.MinimizeBox = $True
$Form.MaximizeBox = $True
$Form.WindowState = "Normal"
$Form.ShowInTaskbar = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 450
$System_Drawing_Size.Height = 220
$form.ClientSize = $System_Drawing_Size



# Labels
# ===========================================
	# ComputerName
	# ===========================================
		$LblCname1 = New-Object System.Windows.Forms.Label 
		$LblCname1.Text = "ComputerName:"
		$LblCname1.Font = $FontBold
		$LblCname1.AutoSize = $true 
		$LblCname1.Location = '10,10'
		
		$LblCname2 = New-Object System.Windows.Forms.Label 
		$LblCname2.Text = $computername.name
		$LblCname2.AutoSize = $true 
		$LblCname2.Location = '130,10'
				
	# Serialnumber
	# ===========================================
		$LblSn1 = New-Object System.Windows.Forms.Label 
		$LblSn1.Text = "SerialNumber:"
		$LblSn1.Font = $FontBold
		$LblSn1.AutoSize = $true 
		$LblSn1.Location = '10,30'
		
		$LblSn2 = New-Object System.Windows.Forms.Label 
		$LblSn2.Text = $serialnumber.serialnumber
		$LblSn2.AutoSize = $true 
		$LblSn2.Location = '130,30'
		
		
	# IP-address
	# ===========================================
		$LblIP1 = New-Object System.Windows.Forms.Label 
		$LblIP1.Text = "IP-Address:"
		$LblIP1.Font = $FontBold
		$LblIP1.AutoSize = $true 
		$LblIP1.Location = '10,50' 
		
		$LblIP2 = New-Object System.Windows.Forms.Label 
		$LblIP2.Text = $networks.ipaddress[0]
		$LblIP2.AutoSize = $true 
		$LblIP2.Location = '130,50'		
	
	# Notification message
	# ===========================================
		$Lblnot1 = New-Object System.Windows.Forms.Label 
		$Lblnot1.Text = "Message:"
		$Lblnot1.Font = $FontBold
		$Lblnot1.AutoSize = $true 
		$Lblnot1.Location = '10,75'
			
		$Lblnot2 = New-Object System.Windows.Forms.RichTextbox
		$Lblnot2.Text = $textnot
		#$Lblnot2.Size = New-Object System.Drawing.Size(200,110)
		$Lblnot2.Size =  '300,110'
		$Lblnot1.AutoSize = $true 
		$lblnot2.Scrollbars = "Vertical"
		$lblnot2.multiline = $true
		#$Lblnot2.Location = New-Object System.Drawing.Size(130,55)
		$Lblnot2.Location = '130,75'
		$Lblnot2.anchor = 'top,left,right,bottom'
	
	# Contacts
	# ===========================================
		<#
		$Lblcontact1 = New-Object System.Windows.Forms.Label 
		$Lblcontact1.Text = "Contact:"
		$Lblcontact1.Font = $FontBold
		$Lblcontact1.AutoSize = $true 
		$Lblcontact1.dock = 'Bottom'
		#>

		
		$Lblcontact2 = New-Object System.Windows.Forms.Label 
		$Lblcontact2.Text = "Contact: 076- 007 09 55"
		$Lblcontact2.Font = $FontH1
		#$Lblcontact2.AutoSize = $true 
		$Lblcontact2.dock = 'Bottom'
		$Lblcontact2.Location = '130,200'
		
	# Image
	# ===========================================
		$Image = [system.drawing.image]::FromFile($logo)
		$Lblimage = New-Object System.Windows.Forms.Label 
		$Lblimage.image = $Image
		$lblImage.Location = '380,10'
		$lblImage.anchor = 'right,top'
		$lblImage.size = '50,50'
		
	# Button(s)
	# ===========================================
		$Okbutton = New-Object System.Windows.Forms.Button 
		$Okbutton.Location = '10,130'
		$Okbutton.Size = '90,30' 
		$Okbutton.Text = "OK" 
		$Okbutton.Add_Click({$form.Windowstate = "Minimized"}) 
		#$Okbutton.Add_Click({[System.Environment]::Exit(0)}) 
		

#Form layout		
# ===========================================
	
	$Form.Controls.Add($LblCname1)
	$Form.Controls.Add($LblCname2) 
	$Form.Controls.Add($LblSn1)
	$Form.Controls.Add($LblSn2)
	$Form.Controls.Add($LblIP1)
	$Form.Controls.Add($LblIP2)	
	$Form.Controls.Add($Lblnot1)
	$Form.Controls.Add($Lblnot2)
	$Form.Controls.Add($Lblcontact1)
	$Form.Controls.Add($Lblcontact2)
	$Form.Controls.Add($LblImage)
	$Form.Controls.Add($okbutton)
	
<#

$tableLayoutPanel1 = New-Object System.Windows.Forms.TableLayoutPanel
#$tableLayoutPanel1.RowCount = 6
$tableLayoutPanel1.Dock = [System.Windows.Forms.DockStyle]::Fill
$tableLayoutPanel1.AutoSizeMode = [system.Windows.Forms.AutoSizeMode]::GrowAndShrink
$tableLayoutPanel1.AutoSize = True

$tableLayoutPanel1.Controls.Add($LblCname1, 0, 0);
$tableLayoutPanel1.Controls.Add($LblCname2, 1, 0);
$tableLayoutPanel1.Controls.Add($LblIP1, 0, 1);
$tableLayoutPanel1.Controls.Add($LblIP2, 1, 1);
$tableLayoutPanel1.Controls.Add($Lblnot1, 0, 2);
$tableLayoutPanel1.Controls.Add($Lblnot2, 1, 2);
$tableLayoutPanel1.Controls.Add($Lblcontact2, 1, 3);
$tableLayoutPanel1.Controls.Add($LblImage, 1, 4);
$tableLayoutPanel1.Controls.Add($okbutton, 0, 4);

$form.controls.add($tableLayoutPanel1)

#>

$Form.ShowDialog()