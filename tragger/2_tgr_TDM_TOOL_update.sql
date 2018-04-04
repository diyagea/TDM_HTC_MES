GO
create trigger tgr_TDM_TOOL_update
on TMS.TDM_TOOL
    after update --���봥��
as
    --�������
    declare @compID nvarchar(50), @desc1 nvarchar(60), @desc2 nvarchar(60),@toolClassID nvarchar(50),@cadID nvarchar(50),@toolType numeric(1,0), @exceTime nvarchar(14);
    
	--Get Now time
	set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));
	
	--get tool info
	select @compID=TDM_TOOL.TOOLID, @desc1=TDM_TOOL.NAME, @desc2=ISNULL(TDM_TOOL.NAME2,TDM_TOOL.NAME201), @toolClassID=TDM_TOOL.TOOLCLASSID, @cadID=TDM_TOOL.CADID, @toolType=TDM_TOOL.TOOLTYPE from TDM_TOOL, inserted where TDM_TOOL.TOOLID = inserted.TOOLID;
	
	--�������߲���
	DECLARE @Dc nvarchar(50), @Xs nvarchar(50), @L4 nvarchar(50), @Ls nvarchar(50);
	--��ʼ������
	SET @Dc='';
	SET @Xs='';
	SET @L4='';
	SET @Ls='';
	
	--������ʱ����
	DECLARE @name nvarchar(60), @val numeric(18, 6), @command nvarchar(3000);
	
	--�����ڲ��α�  
	DECLARE @InCur CURSOR;

	--��ȡ����TOOL����ϸ����
	SET @InCur = CURSOR FOR 
		SELECT ISNULL(TDM_TOOLCLASSFIELDS.NAME01, TDM_TOOLCLASSFIELDS.NAME) AS TOOLCLASSFIELDSNAME, TDM_TOOLVALUES.VALNUM
		FROM TMS_FUNCTYPE
			LEFT JOIN TMS_UNIT FT_UNIT ON TMS_FUNCTYPE.UNITNR = FT_UNIT.UNITNR, TDM_TOOLCLASSFIELDS
				LEFT JOIN TMS_FUNCTYPEVALUES ON TDM_TOOLCLASSFIELDS.TOOLCLASSID = ISNULL(TMS_FUNCTYPEVALUES.CLASSID, TDM_TOOLCLASSFIELDS.TOOLCLASSID)
					AND TDM_TOOLCLASSFIELDS.FUNCTYPEID = TMS_FUNCTYPEVALUES.FUNCTYPEID
				LEFT JOIN TMS_UNIT ON TDM_TOOLCLASSFIELDS.UNITNR = TMS_UNIT.UNITNR
				LEFT JOIN TDM_TOOLVALUES ON TDM_TOOLCLASSFIELDS.TOOLCLASSFIELDSPOS = TDM_TOOLVALUES.TOOLCLASSFIELDSPOS
					AND TDM_TOOLCLASSFIELDS.INDEXID = TDM_TOOLVALUES.INDEXID
					AND TDM_TOOLVALUES.TOOLID = N''+@compID+''
		WHERE TDM_TOOLCLASSFIELDS.TOOLCLASSID = N''+@toolClassID+'' 
			AND TDM_TOOLCLASSFIELDS.NAME IN ('Dc', 'Ys', 'Xs', 'Ls', 'L4')
			AND ISNULL(TDM_TOOLCLASSFIELDS.COMPORTOOL, 3) IN (2, 3)
			AND TDM_TOOLCLASSFIELDS.MOD = TMS_FUNCTYPE.MOD
			AND TDM_TOOLCLASSFIELDS.FUNCTYPEID = TMS_FUNCTYPE.FUNCTYPEID
		GROUP BY TDM_TOOLCLASSFIELDS.POS, TDM_TOOLCLASSFIELDS.TOOLCLASSFIELDSPOS, TDM_TOOLVALUES.EMPTYFLAG, TDM_TOOLCLASSFIELDS.FIELDTYPEEX, TDM_TOOLCLASSFIELDS.NAME, TDM_TOOLCLASSFIELDS.NAME01, TMS_UNIT.NAME, TMS_UNIT.NAME01, TDM_TOOLCLASSFIELDS.NAME2, TDM_TOOLCLASSFIELDS.NAME201, TDM_TOOLVALUES.VAL, TDM_TOOLVALUES.VALNUM, ISNULL(TDM_TOOLCLASSFIELDS.UNITNR, FT_UNIT.UNITNR), ISNULL(TDM_TOOLCLASSFIELDS.FIELDTYPEID, TMS_FUNCTYPE.FIELDTYPEID), TDM_TOOLCLASSFIELDS.FUNCTYPEID, TDM_TOOLCLASSFIELDS.INDEXID, FT_UNIT.NAME01, FT_UNIT.NAME, ISNULL(TDM_TOOLCLASSFIELDS.UNITNR, FT_UNIT.UNITNR), ISNULL(TDM_TOOLCLASSFIELDS.FIELDTYPEID, TMS_FUNCTYPE.FIELDTYPEID)
		ORDER BY ISNULL(TDM_TOOLCLASSFIELDS.POS, 9999), TDM_TOOLCLASSFIELDS.TOOLCLASSFIELDSPOS
	
	--���ڲ��α�  
	OPEN @InCur
	FETCH NEXT FROM @InCur INTO @name, @val  
	WHILE(@@FETCH_STATUS=0)  
	BEGIN
		--����ʱ������ֵ
			
		if (@name=N'Dc' AND @val > 0)						
			BEGIN  
				set @Dc=@val;
			END
		else if @name=N'YS' AND @val > 0 AND (@Dc is null or @Dc='')	
			BEGIN  
				set @Dc=@val;
			END
		else if @name=N'Xs'						
			BEGIN
				set @Xs=@val;
			END
		else if @name=N'L4' 
			BEGIN  
				set @L4=@val;
			END
		else if @name=N'Ls' 
			BEGIN  
				set @Ls=@val;
			END
			
	--�ڲ��α�����һ��
	FETCH NEXT FROM @InCur INTO @name, @val 
	END

	--�رղ��ͷ��ڲ��α�
	CLOSE @InCur  
	DEALLOCATE @InCur	


	--�ж��м���Ƿ����δ��������,�еĻ�ֱ�Ӹ��¸����ݣ�û�������
    DECLARE @count int;
	select @count=count(1) from mes_tool where toolID=@compID and recMark='!' and dataStatus <> 'D';

	if @count > 0
		BEGIN
			--�������м�¼
			update mes_tool set toolID=@compID, desc1=@desc1, desc2=@desc2, toolClassID=@toolClassID, cadID=@cadID, toolType=@toolType where toolID=@compID and recMark = '!';
		END
	else if @count <= 0
		BEGIN
			--���м������¼
			insert into mes_tool (toolID, desc1, desc2, toolClassID, cadID,toolType, cuttingDiameter, gaugeLength, cuttingLength, machiningDepth,updateTime,recMark, dataStatus) values(@compID, @desc1, @desc2,@toolClassID,@cadID,@toolType,@Dc,@Xs,@Ls,@L4, @exceTime,N'!', N'M');
		END

go
