package cn.com.enho.terminal.action;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.terminal.dto.TradeConfirmDto;
import cn.com.enho.terminal.service.BusService;

/**
 * 		交易确认（货主）
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-23 上午11:18:13
 */
@Controller
@RequestMapping("/terminal")
public class TradeConfirmAction {

	@Autowired
	private BusService busService;
	
	static Logger logger = Logger.getLogger(TradeConfirmAction.class.getName());
	
	
	@RequestMapping(value="/tradeConfirm")
	@ResponseBody 
	public Result collectCar(TradeConfirmDto tradeConfirmDto){
		logger.debug("*********************************************交易确认	start*********************************************");
		
		Result result=new Result();
		try{
			//表单验证
			validParam(tradeConfirmDto,result);
			//验证成功
			if(result.getSuccess()){
				this.busService.tradeConfirm(tradeConfirmDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("交易确认出现异常");
			return result;
		}
		
	}
	
	//表单验证
	public void validParam(TradeConfirmDto tradeConfirmDto,Result result){
		if(StringUtils.isEmpty(tradeConfirmDto.getInfoid())){
			result.setSuccess(false);
			result.setMsg("信息id不能为空");
			return;
		}else if(StringUtils.isEmpty(tradeConfirmDto.getInfotype())){
			result.setSuccess(false);
			result.setMsg("信息类型不能为空");
			return;
		}else if(tradeConfirmDto.getInfotype()!=Constants.INFO_G && tradeConfirmDto.getInfotype()!=Constants.INFO_C){
			result.setSuccess(false);
			result.setMsg("信息类型不正确");
			return;
		}else if(StringUtils.isEmpty(tradeConfirmDto.getRequserid())){
			result.setSuccess(false);
			result.setMsg("请求人id不能为空");
			return;
		}else if(StringUtils.isEmpty(tradeConfirmDto.getFlag())){
			result.setSuccess(false);
			result.setMsg("交易确认标识不能为空");
			return;
		}else if(tradeConfirmDto.getFlag()!=Constants.TRADE_FLAG_FAIL && tradeConfirmDto.getFlag()!=Constants.TRADE_FLAG_SUCCESS){
			result.setSuccess(false);
			result.setMsg("交易确认标识不正确");
			return;
		}else{
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
