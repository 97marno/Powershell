/*------------------------
	NETWORK
.........................*/
SELECT B.[ComputerName], B.[MACAddress] into #tmp
FROM dbo.network AS B
  LEFT 
  JOIN dbo.tmpnetwork AS A 
    ON A.[ComputerName] = B.[ComputerName] 
   where B.[MACAddress] != A.[MACAddress];

select computername, macaddress into #tmp2 from #tmp
 EXCEPT select computername, macaddress from dbo.tmpnetwork

Update dbo.network
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where MACAddress in(select MACAddress from #tmp2)

drop table #tmp
drop table #tmp2

select * from dbo.network where ComputerName = 'S1WEBDB-P'
select * from dbo.tmpnetwork where ComputerName = 'S1WEBDB-P'

/*------------------------
	DISK
.........................*/
SELECT B.[ComputerName], B.[VolumeName] into #tmp
FROM dbo.diskinfo AS B
  LEFT 
  JOIN dbo.tmpdiskinfo AS A 
    ON A.[ComputerName] = B.[ComputerName] 
   where B.[VolumeName] != A.[VolumeName];

select computername, VolumeName into #tmp2 from #tmp
 EXCEPT select computername, VolumeName from dbo.tmpdiskinfo

Update dbo.diskinfo
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where ComputerName in(select ComputerName from #tmp2) and Volumename in(select Volumename from #tmp2)

drop table #tmp
drop table #tmp2

/*------------------------
	SoftWare
.........................*/
SELECT B.[ComputerName], B.[Name], B.[SWversion] into #tmp
FROM dbo.software AS B
  LEFT 
  JOIN dbo.tmpsoftware AS A 
    ON A.[ComputerName] = B.[ComputerName] 
   where B.[Name] != A.[Name] or 
   (B.[Name] = A.[Name] and B.[SWversion] != A.[SWversion]);

select computername, Name, SWversion into #tmp2 from #tmp
 EXCEPT select computername, Name, SWversion from dbo.tmpsoftware

Update dbo.software 
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where ComputerName in(select ComputerName from #tmp2) and Name in(select Name from #tmp2) and SWversion in(select SWversion from #tmp2)

drop table #tmp
drop table #tmp2

/*------------------------
	Services
.........................*/
SELECT B.[ComputerName], B.[Name] into #tmp
FROM dbo.serviceinv AS B
  LEFT 
  JOIN dbo.tmpserviceinv AS A 
    ON A.[ComputerName] = B.[ComputerName] 
   where B.[Name] != A.[Name];

select computername, Name  into #tmp2 from #tmp
 EXCEPT select computername, Name from dbo.tmpserviceinv

Update dbo.serviceinv
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where ComputerName in(select ComputerName from #tmp2) and Name in(select Name from #tmp2)

drop table #tmp
drop table #tmp2

/*--------------------------------
	Update all when decomission
..................................*/
select Computername, Decomissioned into #tmp from dbo.computers where Decomissioned = 1
Update dbo.contactinfo
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where ComputerName in(select ComputerName from #tmp)
Update dbo.diskinfo
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where ComputerName in(select ComputerName from #tmp)
Update dbo.network
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where ComputerName in(select ComputerName from #tmp)
Update dbo.serviceinv
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where ComputerName in(select ComputerName from #tmp)
Update dbo.software
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where ComputerName in(select ComputerName from #tmp)
Update dbo.sqlinfo
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where ComputerName in(select ComputerName from #tmp)
Update dbo.sysinfo
	Set [Decomissioned]=1, [ModifyDate] = (GETDATE()) where ComputerName in(select ComputerName from #tmp)

drop table #tmp
	
/*
select * from dbo.serviceinv where ComputerName = 'S1ORCH'
select * from dbo.serviceinv where ComputerName = 'S-K3SAP-T'

select * from sysinfo where Decomissioned = 1
select * from diskinfo where Decomissioned = 1
select * from network where Decomissioned = 1
select * from software where Decomissioned = 1 
select * from serviceinv where Decomissioned = 1
select * from sqlinfo where Decomissioned = 1
select * from contactinfo where Decomissioned = 1

Update dbo.computers set Decomissioned = 1 where id = '37'
select * from #tmp
select * from #tmp2
*/