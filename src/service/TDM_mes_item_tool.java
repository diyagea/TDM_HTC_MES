package service;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import DBUtil.Common;
import DBUtil.JdbcHelper;

public class TDM_mes_item_tool {
	protected static Logger logger = LogManager.getLogger(TDM_mes_item_tool.class);

	@SuppressWarnings({ "rawtypes" })
	public static int exec() {
		try {

			// 1. query all item and insert mes_item_tool

			String sql_query_item_list = "SELECT TOOLID, COMPID, TOOLLISTPOS, QUANTITY FROM TDM_TOOLLIST";
			String sql_insert_mes = "INSERT INTO MES_ITEM_TOOL (toolID, itemID, pos, quantity, updateTime, recMark, dataStatus) VALUES(?,?,?,?,?,?,?)";
			List itemList = JdbcHelper.query(sql_query_item_list);
			for (Object o : itemList) {
				Map m = (Map) o;
				Object q = m.get("QUANTITY");
				if(q == null || q.equals(null)){
					q = new Integer(1);
				}
				JdbcHelper.update(sql_insert_mes, m.get("TOOLID"), m.get("COMPID"), m.get("TOOLLISTPOS"), q, Common.getTimestamp(), "!", "A");
			}

			return 0;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return -1;
		}

	}

	public static void main(String[] args) {
		logger.info("Start TDM_mes_item_tool process");
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
