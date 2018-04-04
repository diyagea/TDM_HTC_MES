GO
create trigger tgr_TDM_TOOL_insert
on TMS.TDM_TOOL
    after insert --���봥��
as
    --�������
    declare @compID nvarchar(50), @desc1 nvarchar(60), @desc2 nvarchar(60),@toolClassID nvarchar(50),@cadID nvarchar(50),@toolType numeric(1, 0),@exceTime nvarchar(14);
    
	select @compID=TOOLID, @desc1=NAME, @desc2=ISNULL(NAME2,NAME201), @toolClassID=TOOLCLASSID, @cadID=CADID,@toolType=TOOLTYPE from inserted;

	--Get Now time
	set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));

	--��delete���в�ѯɾ����¼
	insert into mes_tool (toolID, desc1, desc2,toolClassID,cadID,toolType,updateTime,recMark, dataStatus) values(@compID, @desc1, @desc2,@toolClassID,@cadID,@toolType,@exceTime, N'!', N'A');
    
go
