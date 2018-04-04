GO
create trigger tgr_TDM_technology_update
on TMS.TDM_TOOLTECHNOLIST
    after update --���´���
as
    --�������
    declare @toolID nvarchar(50),@pos numeric(4, 0),@pos2 numeric(2, 0),@revolution numeric(6, 0),@cutSpeed numeric(9, 4),@feedRate numeric(8, 2), @exceTime nvarchar(14);

	select @toolID=TOOLID,@pos=TOOLTECHNOPOS ,@pos2=TOOLTECHNOLISTPOS, @revolution=REVOLUTIONS, @cutSpeed=CUTSPEED, @feedRate=FEEDRATE from inserted;

	if @pos2 = 1
	BEGIN
		--Get Now time
		set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));
		
		--��mes_technology���в�����¼�¼
		insert into mes_technology (toolID,techIndex,revolutionSpeed,cuttingSpeed,feedRate,updateTime,recMark,dataStatus) values(@toolID,@pos,@revolution,@cutSpeed,@feedRate,@exceTime, N'!', N'M');
	END

go
