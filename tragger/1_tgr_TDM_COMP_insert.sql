GO
create trigger tgr_TDM_COMP_insert
on TMS.TDM_COMP
    after insert --插入触发
as
    --定义变量
    declare @compID nvarchar(50), @desc1 nvarchar(60), @desc2 nvarchar(60),@toolClassID nvarchar(50),@cadID nvarchar(50), @exceTime nvarchar(14);
    
	select @compID=COMPID, @desc1=NAME, @desc2=ISNULL(NAME2,NAME201), @toolClassID=TOOLCLASSID, @cadID=CADID from inserted;

	--Get Now time
	set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));

	--在delete表中查询删除记录
	insert into mes_tool (toolID, desc1, desc2,toolClassID,cadID,toolType,updateTime,recMark, dataStatus) values(@compID, @desc1, @desc2,@toolClassID,@cadID,0,@exceTime, N'!', N'A');
    
go
