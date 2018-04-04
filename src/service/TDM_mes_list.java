package service;

import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import DBUtil.Common;
import DBUtil.JdbcHelper;

public class TDM_mes_list {
	protected static Logger logger = LogManager.getLogger(TDM_mes_list.class);

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static int exec() {
		try {

			String firstUsage = "";
			String version = "";
			// 1. query all technology and insert mes_technology
			String sql_query_list = "SELECT LISTID, NCPROGRAM, PARTNAME, MATERIALID, MACHINEID FROM TDM_LIST ";
			String sql_insert_mes = "INSERT INTO mes_list (listID, desc1, desc2, firstUsage, version, machine, material, updateTime,recMark, dataStatus) VALUES(?,?,?,?,?,?,?,?,?,?)";
			String sql_query_machine = "SELECT ISNULL(NAME17,NAME) AS MACHINENAME FROM TDM_MACHINE WHERE MACHINEID=? ";
			String sql_query_material = "SELECT  ISNULL(NAME17,NAME) AS MATERIALNAME FROM TDM_MATERIAL WHERE MATERIALID=? ";
			String sql_query_values = "SELECT VAL FROM TDM_LISTVALUES WHERE WORKPIECECLASSFIELDSPOS = ? AND LISTID=?";
			
			List list = JdbcHelper.query(sql_query_list);
			for (Object o : list) {
				Map m = (Map) o;
				Object machine = JdbcHelper.getSingle(sql_query_machine, m.get("MACHINEID"));
				Object material = JdbcHelper.getSingle(sql_query_material, m.get("MATERIALID"));
				if(machine == null || m.get("MACHINEID")==null){
					machine="";
					m.put("MACHINEID", "");
				}
				if(material == null || m.get("MATERIALID")==null){
					material="";
					m.put("MATERIALID", "");
				}
				
				firstUsage = Common.objectToString(JdbcHelper.getSingle(sql_query_values, 100, m.get("LISTID")));
				version = Common.objectToString(JdbcHelper.getSingle(sql_query_values, 101, m.get("LISTID")));
				
				JdbcHelper.update(sql_insert_mes, m.get("LISTID"), m.get("NCPROGRAM"), m.get("PARTNAME"), firstUsage, version, m.get("MACHINEID")+"-"+machine.toString(), m.get("MATERIALID")+"-"+material.toString(), Common.getTimestamp(), "!", "A");
			}
			return 0;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return -1;
		}
	}

	public static void main(String[] args) {
		logger.info("Start TDM_mes_list process");
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
