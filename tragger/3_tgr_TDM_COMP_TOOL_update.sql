GO
create trigger tgr_TDM_COMP_TOOL_update
on TMS.TDM_TOOLLIST
    after update --���´���
as
    --�������
    declare @itemID_new nvarchar(50), @itemID_old nvarchar(50), @toolID nvarchar(50),@pos numeric(4, 0), @quantity numeric(4, 0), @exceTime nvarchar(14);
    
	--Get Now time
	set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));

	--query info
	select @itemID_new=COMPID,@toolID=TOOLID,@quantity=QUANTITY,@pos=TOOLLISTPOS from inserted;
    select @itemID_old=COMPID from deleted;

	--because of delete will send a update pos command. so there must judge if itemID is null or not.
	if @itemID_old is not null and @itemID_new is not null
	BEGIN
		--�ж��м���Ƿ����δ��������,�еĻ�ֱ�Ӹ��¸����ݣ�û�������
		DECLARE @count int;
		select @count=count(1) from mes_item_tool where toolID=@toolID and itemID=@itemID_old and recMark='!' and dataStatus <> 'D' and pos=@pos;

		if @count > 0
			BEGIN
				--�������м�¼
				update mes_item_tool set itemID=@itemID_new,quantity=@quantity where toolID=@toolID and itemID=@itemID_old and recMark = '!' and pos=@pos;
			END
		else if @count <= 0
			BEGIN
				--���м������¼
				insert into mes_item_tool (toolID,itemID,pos,quantity,updateTime,recMark, dataStatus) values(@toolID,@itemID_new,@pos,@quantity,@exceTime,N'!',N'M');
			END
	END


go
