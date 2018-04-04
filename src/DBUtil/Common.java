package DBUtil;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Common {
	/**
	 * check blank string
	 * 
	 * @param s
	 * @return
	 */
	public static boolean isBlankStr(String s) {
		if ("".equals(s) || " ".equals(s) || "".equals(s.trim())) {
			return true;
		}
		return false;
	}

	/**
	 * convert object to String
	 */
	public static String objectToString(Object o) {
		String str = "";
		if (o == null) {
			return str;
		} else {
			return o.toString();
		}
	}

	/**
	 * convert object to Int
	 */
	public static Integer objectToInt(Object o) {
		if (o == null) {
			return 0;
		} else {
			return new Integer(o.toString());
		}
	}

	/**
	 * 获得随机数
	 * @param digit 位数
	 * @return 随机数
	 */
	public static int getRandom(int digit){
		int max = (int) Math.pow(10, digit);
		int randomNumber = (int) Math.round(Math.random()*(max-1)+1);  
		return randomNumber;
	}
	
	/**
	 * 获得时间字符串（毫秒级别，17位）
	 * @return : 20170626095621123
	 */
	public static String getTimestamp2(){
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		return sdf.format(date);
	}
	
	/**
	 * 获得时间字符串（秒级别，14位）
	 * @return : 20170626095621
	 */
	public static String getTimestamp(){
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		return sdf.format(date);
	}
	
	/**
	 * 获得标准年月日时分秒
	 * @return : 2017-06-26 09:56:21
	 */
	public static String getYMDHMS(){
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sdf.format(date);
	}
	
	public static void main(String[] args) {
		
	}
	
}
