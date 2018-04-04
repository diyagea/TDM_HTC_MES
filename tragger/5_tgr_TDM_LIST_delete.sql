GO
create trigger tgr_TDM_LIST_delete
on TMS.TDM_LIST
    after delete --delete触发
as
    --定义变量
    declare @listID nvarchar(50),@desc1 nvarchar(60),@desc2 nvarchar(60),@machine nvarchar(50),@material nvarchar(50),@exceTime nvarchar(14);

	select @listID=LISTID,@desc1=NCPROGRAM,@desc2=PARTNAME,@machine=MACHINEID,@material=MATERIALID from deleted;

	--Get Now time
	set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));
		
	--在mes_list中插入数据
	insert into mes_list (listID,desc1,desc2,machine,material,updateTime,recMark,dataStatus) values (@listID,@desc1,@desc2,@machine,@material,@exceTime,N'!',N'D');
	
go
