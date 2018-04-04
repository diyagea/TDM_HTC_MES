package DBUtil;
 
import java.io.FileInputStream;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
 
/**
 * 数据库配置文件读取方法
 * @author Allen.Wang
 *
 */
public class DBConfig {
    
	protected static Logger logger = LogManager.getLogger(DBConfig.class);
    private String driver;
    private String url;
    private String userName;
    private String password;
     
    public DBConfig() {
		String path = System.getProperty("user.dir").replace("\\", "/") + "/dbConfig.properties";
		// InputStream inputStream =
		// this.getClass().getClassLoader().getResourceAsStream("DBUtil/dbConfig.properties");
		// InputStream inputStream =
		// this.getClass().getClassLoader().getResourceAsStream(path);

		try {
			FileInputStream inputStream = new FileInputStream(path);
			Properties p = new Properties();
			p.load(inputStream);
			this.driver = p.getProperty("driver");
			this.url = p.getProperty("url");
			this.userName = p.getProperty("username");
			this.password = p.getProperty("password");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

	}
     
    public String getDriver() {
        return driver;
    }
    public String getUrl() {
        return url;
    }
    public String getUserName() {
        return userName;
    }
    public String getPassword() {
        return password;
    }
     
     
 
}