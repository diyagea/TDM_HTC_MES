package service;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import DBUtil.Common;
import DBUtil.JdbcHelper;

public class TDM_mes_technology {
	protected static Logger logger = LogManager.getLogger(TDM_mes_technology.class);

	@SuppressWarnings({ "rawtypes" })
	public static int exec() {
		try {

			// 1. query all technology and insert mes_technology
			String sql_query_technology_list = "SELECT TOOLID, TOOLTECHNOPOS, REVOLUTIONS, CUTSPEED, FEEDRATE FROM TDM_TOOLTECHNOLIST WHERE TOOLTECHNOLISTPOS = 1";
			String sql_insert_mes = "INSERT INTO mes_technology (toolID, techIndex, revolutionSpeed, cuttingSpeed, feedRate, updateTime,recMark,dataStatus) VALUES(?,?,?,?,?,?,?,?)";
			List techList = JdbcHelper.query(sql_query_technology_list);
			for (Object o : techList) {
				Map m = (Map) o;
				JdbcHelper.update(sql_insert_mes, m.get("TOOLID"), m.get("TOOLTECHNOPOS"), m.get("REVOLUTIONS"), m.get("CUTSPEED"), m.get("FEEDRATE"), Common.getTimestamp(), "!", "A");
			}
			return 0;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return -1;
		}
	}

	public static void main(String[] args) {
		logger.info("Start TDM_mes_technology process");
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
