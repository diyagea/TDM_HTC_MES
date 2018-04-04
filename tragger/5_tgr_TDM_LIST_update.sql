GO
create trigger tgr_TDM_LIST_update
on TMS.TDM_LIST
    after update --update����
as
    --�������
    declare @listID nvarchar(50),@desc1 nvarchar(60),@desc2 nvarchar(60),@machineID nvarchar(50),@machineName nvarchar(50),@materialID nvarchar(50),@materialName nvarchar(50),@exceTime nvarchar(14);

	select @listID=LISTID,@desc1=NCPROGRAM,@desc2=PARTNAME,@machineID=MACHINEID,@materialID=MATERIALID from inserted;

	--Machine Name and Material Name
	IF @machineID is not null
	BEGIN
		select @machineName=ISNULL(NAME17,NAME) FROM TDM_MACHINE WHERE MACHINEID=@machineID;
	END

		IF @materialID is not null
	BEGIN
		select @materialName=ISNULL(NAME17,NAME) FROM TDM_MATERIAL WHERE MATERIALID=@materialID;
	END

	--Get Now time
	set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));
	
	--�ж��м���Ƿ����δ��������,�еĻ�ֱ�Ӹ��¸����ݣ�û�������
	DECLARE @count int;
	select @count=count(1) from mes_list where listID=@listID and recMark='!' and dataStatus <> 'D'; 

	IF @count > 0
	BEGIN
		--�����м��δ��ȡ������
		update mes_list set desc1=@desc1,desc2=@desc2,machine=@machineID+'-'+@machineName,material=@materialID+'-'+@materialName,updateTime=@exceTime where listID=@listID and recMark='!';
	
	END
	ELSE IF @count <=0
	BEGIN
		--��mes_list�в�������
		insert into mes_list (listID,desc1,desc2,machine,material,updateTime,recMark,dataStatus) values (@listID,@desc1,@desc2,@machineID+'-'+@machineName,@materialID+'-'+@materialName,@exceTime,N'!',N'M');
	END
go
