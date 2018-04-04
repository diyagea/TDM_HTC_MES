GO
create trigger tgr_TDM_TOOL_LIST_update
on TMS.TDM_LISTLISTB
    after update
as
    --定义变量
    declare @listID nvarchar(50),@itemID nvarchar(50),@toolID nvarchar(50),@pos numeric(4, 0),@techIndex numeric(4, 0),@exceTime nvarchar(14);

	select @listID=LISTID,@itemID=COMPID,@toolID=TOOLID,@pos=LISTLISTPOS,@techIndex=TECHNOPOS from inserted;

	--Get Now time
	set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));
	

	declare @count numeric(4,0);
	select @count=count(1) from mes_tool_list where listID=@listID and pos=@pos and recMark=N'!' and dataStatus <> N'D';

	IF @itemID is not null
	BEGIN
		IF @count > 0
		BEGIN
			update mes_tool_list set toolID=@itemID where listID=@listID and pos=@pos and recMark=N'!' and dataStatus <> N'D';
		END
		ELSE IF @count<= 0
		BEGIN
			insert into mes_tool_list (listID,toolID,pos,techIndex,updateTime,recMark,dataStatus) values (@listID,@itemID,@pos,@techIndex,@exceTime,N'!',N'M');
		END
	END
	
	ELSE IF @toolID is not null
	BEGIN
		IF @count > 0
		BEGIN
			update mes_tool_list set toolID=@toolID, techIndex=@techIndex where listID=@listID and pos=@pos and recMark=N'!' and dataStatus <> N'D';
		END
		ELSE IF @count<= 0
		BEGIN
			insert into mes_tool_list (listID,toolID,pos,techIndex,updateTime,recMark,dataStatus) values (@listID,@toolID,@pos,@techIndex,@exceTime,N'!',N'M');
		END
	END
	
go
