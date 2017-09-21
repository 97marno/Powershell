@"
===============================================================================
Title:         Export-VMInfo.ps1
Description:   Exports VM Information from vCenter into a .CSV file for importing into anything
Usage:         .\Export-VMInfo.ps1
Date:          04/03/2010
===============================================================================
"@
 
filter Get-FolderPath {
    $_ | Get-View | % {
        $row = "" | select Name, Path
        $row.Name = $_.Name
 
        $current = Get-View $_.Parent
#        $path = $_.Name # Uncomment out this line if you do want the VM Name to appear at the end of the path
        $path = ""
        do {
            $parent = $current
            if($parent.Name -ne "vm"){$path = $parent.Name + "\" + $path}
            $current = Get-View $current.Parent
        } while ($current.Parent -ne $null)
        $row.Path = $path
        $row
    }
}
 
$VCServerName = "rtsvc01.skypoint.local"
$VC = Connect-VIServer $VCServerName
$VMFolder = "Kunder"
$ExportFilePath = "E:\Marlen\Export-VMInfo.csv"
 
$Report = @()
$VMs = Get-Folder $VMFolder | Get-VM
 
$Datastores = Get-Datastore | select Name, Id
$VMHosts = Get-VMHost | select Name, Parent
 
ForEach ($VM in $VMs) {
      $VMView = $VM | Get-View
      $VMInfo = {} | Select VMName,Powerstate,OS,Folder,IPAddress,ToolsStatus,Host,Cluster,Datastore,NumCPU,MemMb,ProvisionedSpaceGB, UsedSpaceGB, DiskFree
      $VMInfo.VMName = $vm.name
      $VMInfo.Powerstate = $vm.Powerstate
      $VMInfo.OS = $vm.Guest.OSFullName
      $VMInfo.Folder = ($vm | Get-Folderpath).Path
      $VMInfo.IPAddress = $vm.Guest.IPAddress[0]
      $VMInfo.ToolsStatus = $VMView.Guest.ToolsStatus
      $VMInfo.Host = $vm.host.name
      $VMInfo.Cluster = $vm.host.Parent.Name
      $VMInfo.Datastore = ($Datastores | where {$_.ID -match (($vmview.Datastore | Select -First 1) | Select Value).Value} | Select Name).Name
      $VMInfo.NumCPU = $vm.NumCPU
      $VMInfo.MemMb = [Math]::Round(($vm.MemoryMB),2)
	  $VMInfo.ProvisionedSpaceGB = $vm.ProvisionedSpaceGB
      $VMInfo.UsedSpaceGB = $vm.UsedSpaceGB
      $VMInfo.DiskFree = $VMInfo.ProvisionedSpaceGB - $VMInfo.UsedSpaceGB
      $Report += $VMInfo
}
$Report = $Report | Sort-Object VMName
IF ($Report -ne "") {
$report | Export-Csv $ExportFilePath -NoTypeInformation
}
$VC = Disconnect-VIServer -Confirm:$False