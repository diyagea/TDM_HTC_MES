package service;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class MainProcess {
	protected static Logger logger = LogManager.getLogger(MainProcess.class);
	public static void main(String[] args) {
		logger.info("Start Run Main Process");
		TDM_mes_item.main(args);;
		TDM_mes_tool.main(args);
		TDM_mes_item_tool.main(args);
		TDM_mes_technology.main(args);
		TDM_mes_list.main(args);
		TDM_mes_tool_list.main(args);
		logger.info("End Run Main Process");
	}
}
