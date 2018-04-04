package service;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import DBUtil.Common;
import DBUtil.JdbcHelper;

public class TDM_mes_item {
	protected static Logger logger = LogManager.getLogger(TDM_mes_item.class);

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static int exec() {
		try {
			int toolState = 0;
			String sql_insert_tools = "INSERT INTO MES_TOOL (toolID, desc1, desc2, toolClassID, cadID, toolType, toolState, cuttingDiameter, gaugeLength, cuttingLength, machiningDepth, updateTime, recMark, dataStatus) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
			
			//1. query all tools from [TDM_COMP]
			String sql_query_all_tools = "SELECT COMPID, NAME, NAME2, TOOLCLASSID, CADID, STATEID2 FROM TDM_COMP ";
			List toolList = JdbcHelper.query(sql_query_all_tools);
			
			//2. use TOOLCLASSID, query (Dc/Ys, Xs, Ls, L4)TOOLCLASSFIELDPOS from [TDM_TOOLCLASSFIELDS]
			String sql_query_fields_pos = "SELECT TOOLCLASSID, NAME, TOOLCLASSFIELDSPOS FROM TDM_TOOLCLASSFIELDS WHERE NAME IN ('Dc', 'Ys', 'Xs', 'Ls', 'L4') AND TOOLCLASSID = ? ";
			String sql_query_fields_val = "SELECT VALNUM FROM TDM_COMPVALUES WHERE COMPID = ? AND TOOLCLASSFIELDSPOS = ? ";
			for(Object o : toolList){
				Map tm = (Map)o;
				Object toolClassID = tm.get("TOOLCLASSID");
				
				//query field positions
				List fieldPosList = JdbcHelper.query(sql_query_fields_pos, toolClassID);
				
				//3. use COMPID and TOOLCLASSFIELDPOS, query VALNUM from [TDM_COMPVALUES], then put in toolMap
				for(Object fo : fieldPosList){
					Map fm = (Map) fo;
					Object val = JdbcHelper.getSingle(sql_query_fields_val, tm.get("COMPID"), fm.get("TOOLCLASSFIELDSPOS"));
					tm.put(fm.get("NAME"), val);
				}
				
				//4. add the tool into mes_tool
				boolean flag = false;
				boolean booDc = tm.containsKey("Dc");
				boolean booYs = tm.containsKey("Ys");
				
				if(!booDc && booYs){
					flag = true;
				}
				
				//toolState
				if("MULT".equals(tm.get("STATEID2"))){
					toolState = 1;
				}else{
					toolState = 0;
				}
				
				if(flag){
					JdbcHelper.update(sql_insert_tools, tm.get("COMPID"), tm.get("NAME"), tm.get("NAME2"), tm.get("TOOLCLASSID"), tm.get("CADID"), 0, toolState, tm.get("Ys"), tm.get("Xs"), tm.get("Ls"), tm.get("L4"), Common.getTimestamp(), "!", "A");
				}else{
					JdbcHelper.update(sql_insert_tools, tm.get("COMPID"), tm.get("NAME"), tm.get("NAME2"), tm.get("TOOLCLASSID"), tm.get("CADID"), 0, toolState, tm.get("Dc"), tm.get("Xs"), tm.get("Ls"), tm.get("L4"), Common.getTimestamp(), "!", "A");
				}
			}
			return 0;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return -1;
		}

	}
	
	public static void main(String[] args) {
		logger.info("Start TDM_mes_item process");
		int result = exec();
		if(result == 0){
			logger.info("Execte End Successful");
		}else if(result > 0){
			logger.info("Execte End But Unsuccessful");
		}else {
			logger.info("Execte End But Error");
		}
	}

}
