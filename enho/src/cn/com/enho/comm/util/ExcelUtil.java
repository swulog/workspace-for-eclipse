package cn.com.enho.comm.util;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import cn.com.enho.comm.ExcelUserBean;

/**
 * 		excel操作工具类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-10-23 下午1:38:20
 */
public class ExcelUtil {
	
    /**  
     * 读取xls文件内容  
     *  
     * @return List<ExcelUserBean>对象  
     * @throws IOException  
     *             输入/输出(i/o)异常  
     */ 
	public static List<ExcelUserBean> readXls(InputStream is) throws IOException {  
       // InputStream is = new FileInputStream("pldrxkxxmb.xls");  
    	Workbook book = null;
    	
    	int leng = is.available();  
		BufferedInputStream buff = new BufferedInputStream(is);  
		byte[] mapObj = new byte[leng];  
		buff.read(mapObj, 0, leng);  
    	
    	try{
    		 book = new HSSFWorkbook(new ByteArrayInputStream(mapObj));
    	}catch(Exception e){
    		 book = new XSSFWorkbook(new ByteArrayInputStream(mapObj));
    	}
         
        ExcelUserBean eu = null;  
        List<ExcelUserBean> list = new ArrayList<ExcelUserBean>();  
        
        // 循环工作表Sheet  
        for (int i=0,len=book.getNumberOfSheets();i<len;i++) {  
            Sheet sheet = book.getSheetAt(i);  
            if (sheet == null) {  
                continue;  
            }  
            // 循环行Row  
            for (int j=1,count=sheet.getLastRowNum();j<=count;j++) {  
                Row row = sheet.getRow(j);  
                if (row == null) {  
                    continue;  
                }  
                eu=new ExcelUserBean();
                //循环列
                for (short k= 0,num=row.getLastCellNum();k<=num;k++) {     
                     Cell cell = row.getCell(k); 
                     if(cell == null){
                    	 continue;
                     }
                     switch(k){
                     	case 0:eu.setPhone(getValue(cell));break;
                     	case 1:eu.setName(getValue(cell));break;
                     	case 2:eu.setEnt(getValue(cell));break;
                     	case 3:eu.setEnd(getValue(cell));break;
                     }
                }
                list.add(eu);
            }  
        }  
        return list;  
    }  
   
    /**  
     * 得到Excel表中的值  
     *  
     * @param hssfCell  
     *            Excel中的每一个格子  
     * @return Excel中每一个格子中的值  
     */ 
    @SuppressWarnings("static-access")
	private static String getValue(Cell cell) {  
    	// 返回布尔类型的值  
        if (cell.getCellType() == cell.CELL_TYPE_BOOLEAN) {  
            return String.valueOf(cell.getBooleanCellValue());  
        // 返回数值类型的值  
        } else if (cell.getCellType() == cell.CELL_TYPE_NUMERIC) {  
            return String.valueOf(cell.getNumericCellValue());  
        // 返回字符串类型的值  
        } else {  
            return String.valueOf(cell.getStringCellValue());  
        }  
    } 
}
