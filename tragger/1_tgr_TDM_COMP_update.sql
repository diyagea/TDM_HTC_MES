GO
create trigger tgr_TDM_COMP_update
on TMS.TDM_COMP
    after update --插入触发
as
    --定义变量
    declare @compID nvarchar(50), @desc1 nvarchar(60), @desc2 nvarchar(60),@toolClassID nvarchar(50),@cadID nvarchar(50), @exceTime nvarchar(14);
    
	--Get Now time
	set @exceTime=CONVERT(nvarchar(50), GETDATE(), 112)+CONVERT(nvarchar(50), DATEPART(HOUR, getdate()))+CONVERT(nvarchar(50), DATEPART(MINUTE, getdate()))+CONVERT(nvarchar(50), DATEPART(SECOND, getdate()));
	
	--get tool info
	select @compID=TDM_COMP.COMPID, @desc1=TDM_COMP.NAME, @desc2=ISNULL(TDM_COMP.NAME2,TDM_COMP.NAME201), @toolClassID=TDM_COMP.TOOLCLASSID, @cadID=TDM_COMP.CADID from TDM_COMP, inserted where TDM_COMP.COMPID = inserted.COMPID;
	
	--声明刀具参数
	DECLARE @Dc nvarchar(50), @Xs nvarchar(50), @L4 nvarchar(50), @Ls nvarchar(50);
	--初始化参数
	SET @Dc='';
	SET @Xs='';
	SET @L4='';
	SET @Ls='';
	
	--声明临时变量
	DECLARE @name nvarchar(60), @val numeric(18, 6), @command nvarchar(3000);
	
	--声明内层游标  
	DECLARE @InCur CURSOR;

	--获取刀具Item的详细参数
	SET @InCur = CURSOR FOR 
		SELECT   ISNULL(TDM_TOOLCLASSFIELDS.NAME01, TDM_TOOLCLASSFIELDS.NAME) TOOLCLASSFIELDSNAME,   
		ISNULL(TDM_COMPVALUES.VAL, CONVERT(VARCHAR(23), ISNULL(TDM_COMPVALUES.VALNUM, null))) VALVALNUM 
		FROM  TMS_FUNCTYPE  LEFT OUTER JOIN  TMS_UNIT FT_UNIT  ON  TMS_FUNCTYPE.UNITNR  = FT_UNIT.UNITNR ,  
		TDM_TOOLCLASSFIELDS  LEFT OUTER JOIN  TMS_FUNCTYPEVALUES  ON  TDM_TOOLCLASSFIELDS.TOOLCLASSID  = ISNULL(TMS_FUNCTYPEVALUES.CLASSID, 
		TDM_TOOLCLASSFIELDS.TOOLCLASSID)   AND TDM_TOOLCLASSFIELDS.FUNCTYPEID  = TMS_FUNCTYPEVALUES.FUNCTYPEID   LEFT OUTER JOIN  TMS_UNIT  ON  
		TDM_TOOLCLASSFIELDS.UNITNR  = TMS_UNIT.UNITNR   LEFT OUTER JOIN  TDM_COMPVALUES  ON  TDM_TOOLCLASSFIELDS.TOOLCLASSFIELDSPOS  = TDM_COMPVALUES.TOOLCLASSFIELDSPOS 
		AND TDM_TOOLCLASSFIELDS.INDEXID  = TDM_COMPVALUES.INDEXID   AND TDM_COMPVALUES.COMPID  = N''+@compID+''  WHERE  TDM_TOOLCLASSFIELDS.TOOLCLASSID  = N''+@toolClassID+'' 
		AND (TDM_TOOLCLASSFIELDS.NAME = N'Dc'or TDM_TOOLCLASSFIELDS.NAME01 = N'Dc'
		or TDM_TOOLCLASSFIELDS.NAME = N'Xs'or TDM_TOOLCLASSFIELDS.NAME01 = N'Xs'
		or TDM_TOOLCLASSFIELDS.NAME = N'L4'or TDM_TOOLCLASSFIELDS.NAME01 = N'L4'
		or TDM_TOOLCLASSFIELDS.NAME = N'Ls'or TDM_TOOLCLASSFIELDS.NAME01 = N'Ls'
		or TDM_TOOLCLASSFIELDS.NAME = N'Ys'or TDM_TOOLCLASSFIELDS.NAME01 = N'Ys')
		AND ISNULL(TDM_TOOLCLASSFIELDS.COMPORTOOL, 3)  in ( 1  , 3  )  AND TDM_TOOLCLASSFIELDS.MOD  = TMS_FUNCTYPE.MOD 
		AND TDM_TOOLCLASSFIELDS.FUNCTYPEID  = TMS_FUNCTYPE.FUNCTYPEID GROUP BY TDM_TOOLCLASSFIELDS.POS,   TDM_TOOLCLASSFIELDS.TOOLCLASSFIELDSPOS,   
		TDM_COMPVALUES.EMPTYFLAG,   TDM_TOOLCLASSFIELDS.FIELDTYPEEX,   TDM_TOOLCLASSFIELDS.NAME,   TDM_TOOLCLASSFIELDS.NAME01,   TMS_UNIT.NAME,  
		TMS_UNIT.NAME01,   TDM_TOOLCLASSFIELDS.NAME2,   TDM_TOOLCLASSFIELDS.NAME201,   TDM_COMPVALUES.VAL,   TDM_COMPVALUES.VALNUM,   ISNULL(TDM_TOOLCLASSFIELDS.UNITNR,
		FT_UNIT.UNITNR),   ISNULL(TDM_TOOLCLASSFIELDS.FIELDTYPEID, TMS_FUNCTYPE.FIELDTYPEID),   TDM_TOOLCLASSFIELDS.FUNCTYPEID,   TDM_TOOLCLASSFIELDS.INDEXID,   FT_UNIT.NAME01,
		FT_UNIT.NAME,   ISNULL(TDM_TOOLCLASSFIELDS.UNITNR, FT_UNIT.UNITNR),    ISNULL(TDM_TOOLCLASSFIELDS.FIELDTYPEID, TMS_FUNCTYPE.FIELDTYPEID)  ORDER BY ISNULL(TDM_TOOLCLASSFIELDS.POS, 9999),   TDM_TOOLCLASSFIELDS.TOOLCLASSFIELDSPOS  

	
	--打开内层游标  
	OPEN @InCur
	FETCH NEXT FROM @InCur INTO @name, @val  
	WHILE(@@FETCH_STATUS=0)  
	BEGIN
		--给临时变量赋值
			
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
			
	--内层游标下移一行
	FETCH NEXT FROM @InCur INTO @name, @val 
	END

	--关闭并释放内层游标
	CLOSE @InCur  
	DEALLOCATE @InCur	


	--判断中间表是否存在未更新数据,有的话直接更新该数据，没有则插入
    DECLARE @count int;
	select @count=count(1) from mes_tool where toolID=@compID and recMark='!'  and dataStatus <> 'D';

	if @count > 0
		BEGIN
			--更新已有记录
			update mes_tool set toolID=@compID, desc1=@desc1, desc2=@desc2, toolClassID=@toolClassID, cadID=@cadID where toolID=@compID and recMark = '!' ;
		END
	else if @count <= 0
		BEGIN
			--在中间表插入记录
			insert into mes_tool (toolID, desc1, desc2, toolClassID, cadID,toolType, cuttingDiameter, gaugeLength, cuttingLength, machiningDepth,updateTime,recMark, dataStatus) values(@compID, @desc1, @desc2,@toolClassID,@cadID,0,@Dc,@Xs,@Ls,@L4, @exceTime,N'!', N'M');
		END

go
