GO
create trigger tgr_TDM_COMP_TOOL_delete
on TMS.TDM_TOOLLIST
    after delete --删除触发
as
    --定义变量
    declare @itemID nvarchar(50), @toolID nvarchar(50),@pos numeric(4, 0), @quantity numeric(4, 0), @exceTime nvarchar(14);
    
	--Get Now time
	set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));

	select @itemID=COMPID,@toolID=TOOLID,@quantity=QUANTITY,@pos=TOOLLISTPOS from deleted;

	--在中间表中插入删除记录
	insert into mes_item_tool (toolID,itemID,pos,quantity,updateTime,recMark,dataStatus) values(@toolID,@itemID,@pos,@quantity,@exceTime,N'!',N'D');
    
go
