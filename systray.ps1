
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")  
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void] [System.Windows.Forms.Application]::EnableVisualStyles() 



function Show-NotifyIcon
{ 
	$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 

	$objNotifyIcon.Icon = $ico
	$objNotifyIcon.BalloonTipText = "You have new notifications." 
	$objNotifyIcon.BalloonTipTitle = "Notification." 

	$objNotifyIcon.Visible = $True 
	$objNotifyIcon.ShowBalloonTip(10000)

	#$objNotifyIcon.BalloonTipIcon = "Info" 
	#$objNotifyIcon.BalloonTipText = "Retrieving files from C:\Windows." 
	#$objNotifyIcon.BalloonTipTitle = "Retrieving Files" 

} 

function GenerateForm {
    
    $form1 = New-Object System.Windows.Forms.Form
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
    
	# ===========================================
    #	Icon generation and loading into form
	#	Drawing.Pens (intx1, intey1, intx2,inty2)
	#	(x1,y1) = specify starting point, (x2,y2) = specify ending point
    # ===========================================
		$bmp = New-Object System.Drawing.Bitmap(16,16)
			$g = [System.Drawing.Graphics]::FromImage($bmp)
			$g.drawline([System.Drawing.Pens]::Black,5,0,10,0)
			$g.drawline([System.Drawing.Pens]::Black,3,1,14,1)
			$g.drawline([System.Drawing.Pens]::Black,2,2,15,2)
			#$g.drawline([System.Drawing.Pens]::Black,10,4,10,15)
			#$g.drawline([System.Drawing.Pens]::Black,10,15,6,15)
			#$g.drawline([System.Drawing.Pens]::Black,6,15,6,4)
			#$g.drawline([System.Drawing.Pens]::Black,6,4,0,4)
			#$g.drawline([System.Drawing.Pens]::Black,0,4,0,0)
			#$g.drawline([System.Drawing.Pens]::Blue,1,1,14,1)
			#$g.drawline([System.Drawing.Pens]::Blue,1,2,14,2)
			#$g.drawline([System.Drawing.Pens]::Blue,1,3,14,3)
			#$g.drawline([System.Drawing.Pens]::Blue,7,4,7,14)
			#$g.drawline([System.Drawing.Pens]::Blue,8,4,8,14)
			#$g.drawline([System.Drawing.Pens]::Blue,9,4,9,14)
		if($ico -eq $null){$ico= [System.Drawing.Icon]::FromHandle($bmp.GetHicon())}
	    
    # ===========================================
    # End of the icon generation and loading
    # ===========================================
	
    $form1.Text = "Icon Form"
    $form1.Name = "form1"
	$form1.Icon = $ico
    $form1.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 400
    $System_Drawing_Size.Height = 350
    $form1.ClientSize = $System_Drawing_Size
    $InitialFormWindowState = $form1.WindowState
	

	


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
		
		$Form1.Controls.Add($LblCname1)
		$Form1.Controls.Add($LblCname2) 
		
	# IP-address
	# ===========================================
		$LblIP1 = New-Object System.Windows.Forms.Label 
		$LblIP1.Text = "IP-Address:"
		$LblIP1.Font = $FontBold
		$LblIP1.AutoSize = $true 
		$LblIP1.Location = '10,30' 
		
		$LblIP2 = New-Object System.Windows.Forms.Label 
		$LblIP2.Text = $networks.ipaddress[0]
		$LblIP2.AutoSize = $true 
		$LblIP2.Location = '130,30'		
		
		$Form1.Controls.Add($LblIP1)
		$Form1.Controls.Add($LblIP2)
		
	# Notification message
	# ===========================================
		$Lblnot1 = New-Object System.Windows.Forms.Label 
		$Lblnot1.Text = "Message:"
		$Lblnot1.Font = $FontBold
		$Lblnot1.AutoSize = $true 
		$Lblnot1.Location = '10,55'
		
	
		$Lblnot2 = New-Object System.Windows.Forms.RichTextbox
		$Lblnot2.Text = $textnot
		$Lblnot2.Size = '200,110'	
		$lblnot2.Scrollbars = "Vertical"
		$lblnot2.multiline = $true
		$Lblnot2.Location = '130,55'
		$Lblnot2.anchor = 'top,left,right,bottom'
		
		$Form1.Controls.Add($Lblnot1)
		$Form1.Controls.Add($Lblnot2)

	# Contacts
	# ===========================================
		$Lblcontact1 = New-Object System.Windows.Forms.Label 
		$Lblcontact1.Text = "Contact:"
		$Lblcontact1.Font = $FontBold
		$Lblcontact1.AutoSize = $true 
		$Lblcontact1.Location = '10,170' 

		
		$Lblcontact2 = New-Object System.Windows.Forms.Label 
		$Lblcontact2.Text = "076- 007 09 55"
		$Lblcontact2.Font = $FontH1
		#$Lblcontact2.AutoSize = $true 
		$Lblcontact2.Location = '130,170'
		$Lblcontact2.Anchor = 'top,left,right,bottom'
		
		$Form1.Controls.Add($Lblcontact1)
		$Form1.Controls.Add($Lblcontact2)
				
	# Button(s)
	# ===========================================
		$Okbutton = New-Object System.Windows.Forms.Button 
		$Okbutton.Location = '10,130'
		$Okbutton.Size = '90,30' 
		$Okbutton.Text = "OK" 
		#$Okbutton.Add_Click({MinimizeForm}) 
		$Okbutton.Add_Click({[System.Environment]::Exit(0)}) 
		$Form1.Controls.Add($okbutton)

				
	$form1.add_Load($OnLoadForm_StateCorrection)
	$form1.ShowDialog()| Out-Null

}

function MinimizeForm{
	
	$form1.Windowstate = "Minimized"
	#If($form1.Windowstate -eq 1){	
	Show-NotifyIcon #$NotifyIcon $BalloonTipText $BalloonTipTitle $BalloonTipIcon
	#$form1.WindowState = "Normal"
	$form1.ShowInTaskbar = $true		
	
	$objNotifyIcon_MouseDoubleClick=[System.Windows.Forms.MouseEventHandler]{
#Event Argument: $_ = [System.Windows.Forms.MouseEventArgs]
#TODO: Place custom script here
$form1.ShowInTaskbar = $true
$form1.WindowState = "Normal"
} 

	
	
	$form1.ShowDialog()
	
	
	
	
	}






# Parameters
# =========================================== 
	$computername = Get-WmiObject -Class Win32_ComputerSystem | select name 
	$Networks = Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.ipenabled}
	$textnot = Get-content -Path ".\notification.txt" -Encoding UTF8
	

# Fonts
# ===========================================
	$FontNormal = New-Object System.Drawing.Font("Calibri",12) 
	$FontBold = New-Object System.Drawing.Font("Calibri",12,[System.Drawing.FontStyle]::Bold) 
	$FontH1 = New-Object System.Drawing.Font("Calibri",14,[System.Drawing.FontStyle]::Bold) 
	$ico = #"c:\temp\Temperature-1.ico"

GenerateForm







<#

# Form
# ===========================================
	$Form = New-Object system.Windows.Forms.Form 
	$formIcon = "C:\Temp\Temperature-5.ico"
	$form.Icon = $formicon 
	$Form.Size = New-Object System.Drawing.Size(400,350) 
	$form.autosize = $true
	#$form.MaximizeBox = $false 
	$Form.StartPosition = "CenterScreen" 
	$Form.FormBorderStyle = 'Fixed3D' 
	$Form.Text = "HLP" 
	$form.Font = $FontNormal
	



	
	$Form.ShowDialog() 	 
	#>
	
	