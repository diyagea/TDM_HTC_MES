package service;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import DBUtil.Common;
import DBUtil.JdbcHelper;

public class TDM_mes_tool_list {
	protected static Logger logger = LogManager.getLogger(TDM_mes_tool_list.class);

	@SuppressWarnings({ "rawtypes" })
	public static int exec() {
		try {

			// 1. query all technology and insert mes_technology
			String sql_query_tool_list = "SELECT LISTID, LISTLISTPOS, COMPID, TOOLID, TECHNOPOS FROM TDM_LISTLISTB ";
			String sql_insert_mes = "INSERT INTO mes_tool_list (listID, toolID, pos, techIndex, updateTime,recMark, dataStatus) VALUES(?,?,?,?,?,?,?)";
			List toolList = JdbcHelper.query(sql_query_tool_list);
			for (Object o : toolList) {
				Map m = (Map) o;
				if(m.get("COMPID") == null || m.get("COMPID").equals(null)){
					JdbcHelper.update(sql_insert_mes, m.get("LISTID"), m.get("TOOLID"), m.get("LISTLISTPOS"), m.get("TECHNOPOS"), Common.getTimestamp(), "!", "A");
				}else{
					JdbcHelper.update(sql_insert_mes, m.get("LISTID"), m.get("COMPID"), m.get("LISTLISTPOS"), m.get("TECHNOPOS"), Common.getTimestamp(), "!", "A");
				}
			}
			return 0;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return -1;
		}
	}

	public static void main(String[] args) {
		logger.info("Start TDM_mes_tool_list process");
		int result = exec();
		if (result == 0) {
			logger.info("Execte End Successful");
		} else if (result > 0) {
			logger.info("Execte End But Unsuccessful");
		} else {
			logger.info("Execte End But Error");
		}
	}

}
