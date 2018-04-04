GO
create trigger tgr_TDM_TOOL_LIST_insert
on TMS.TDM_LISTLISTB
    after insert --插入触发
as
    --定义变量
    declare @listID nvarchar(50),@itemID nvarchar(50),@toolID nvarchar(50),@pos numeric(4, 0),@techIndex numeric(4, 0),@exceTime nvarchar(14);

	select @listID=LISTID,@itemID=COMPID,@toolID=TOOLID,@pos=LISTLISTPOS,@techIndex=TECHNOPOS from inserted;

	--Get Now time
	set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));
	

	IF @itemID is not null
	BEGIN
		insert into mes_tool_list (listID,toolID,pos,techIndex,updateTime,recMark,dataStatus) values (@listID,@itemID,@pos,@techIndex,@exceTime,N'!',N'A');
	END
	ELSE IF @toolID is not null
	BEGIN
		insert into mes_tool_list (listID,toolID,pos,techIndex,updateTime,recMark,dataStatus) values (@listID,@toolID,@pos,@techIndex,@exceTime,N'!',N'A');
	END
	
go
