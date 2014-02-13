package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.QryTradeRecordDto;
import cn.com.enho.terminal.service.BusService;

/**
 * 		查询交易记录
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-25 上午10:30:49
 */
@Controller
@RequestMapping("/terminal")
public class QryTradeRecord {

	@Autowired
	private BusService busService;
	
	static Logger logger = Logger.getLogger(QryTradeRecord.class.getName());
	
	
	@RequestMapping(value="/qryTradeRecord")
	@ResponseBody 
	public Result qryTradeRecord(QryTradeRecordDto qryTradeRecordDto){
		logger.debug("*********************************************查询交易记录	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(qryTradeRecordDto,result);
			//验证成功
			if(result.getSuccess()){
				this.busService.qryTradeRecord(qryTradeRecordDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询交易记录出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(QryTradeRecordDto qryTradeRecordDto,Result result){
		if(StringUtils.isEmpty(qryTradeRecordDto.getUserid())){
			result.setSuccess(false);
			result.setMsg("用户id不能为空");
			return;
		}else if(StringUtils.isEmpty(qryTradeRecordDto.getUsertype())){
			result.setSuccess(false);
			result.setMsg("用户类型不能为空");
			return;
		}else if(qryTradeRecordDto.getUsertype()!=Constants.USER_GE && qryTradeRecordDto.getUsertype()!=Constants.USER_GP && qryTradeRecordDto.getUsertype()!=Constants.USER_CE && qryTradeRecordDto.getUsertype()!=Constants.USER_CP){
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}else{
			if(qryTradeRecordDto.getCurrentpage()==null || qryTradeRecordDto.getCurrentpage()<=0){
				qryTradeRecordDto.setCurrentpage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryTradeRecordDto.getPagesize()==null || qryTradeRecordDto.getPagesize()<=0){
				qryTradeRecordDto.setPagesize(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
