package cn.com.enho.mg.action;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.com.enho.comm.MgResult;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.mg.dto.QryUserListDto;
import cn.com.enho.mg.dto.UserDto;
import cn.com.enho.mg.service.MgService;

/**
 * 		查询用户列表
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-14 上午10:22:21
 */
@Controller
@RequestMapping("/mg")
public class QryUser4MgAction {

	@Autowired
	private MgService mgService;
	
	static Logger logger = Logger.getLogger(QryUser4MgAction.class.getName());
	
	/**
	 * 查询用户列表
	 * @param qryUserListDto
	 * @return
	 */
	@RequestMapping(value="/qryUserList")
	@ResponseBody 
	public MgResult qryUserList(HttpServletRequest request,QryUserListDto qryUserListDto){
		logger.debug("*********************************************后台_查询用户列表	start*********************************************");
		
		MgResult result=new MgResult();
		try{
			//表单验证
			validParam(qryUserListDto,result);
			//验证成功
			if(result.getSuccess()){
				String baseurl=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+ request.getContextPath();
				qryUserListDto.setBaseurl(baseurl);
				this.mgService.qryUserList(qryUserListDto,result);
			}else{//验证失败
			}
			return result;
		}catch(Exception e){
			e.printStackTrace();
			result.setSuccess(false);
			result.setMsg("查询异常");
			return result;
		}
		
	}
	
	@RequestMapping(value="/qryUserDtl")
	public ModelAndView qryUserDtl(UserDto userDto){
		logger.debug("*********************************************后台_查询用户详情	start*********************************************");
		ModelAndView mav=new ModelAndView();
		mav.addObject("phone", userDto.getPhone());
		mav.addObject("type", userDto.getType());
		mav.addObject("integral", userDto.getIntegral());
		mav.addObject("creditrating", userDto.getCreditrating());
		mav.addObject("isabled", userDto.getIsabled());
		mav.addObject("name", userDto.getName());
		mav.addObject("id", userDto.getId());
		mav.addObject("pwd", userDto.getPwd());
		mav.addObject("tel", userDto.getTel());
		mav.addObject("x", userDto.getX());
		mav.addObject("y", userDto.getY());
		mav.addObject("createtime", userDto.getCreatetime());
		mav.addObject("lastupdatetime", userDto.getLastupdatetime());
		mav.addObject("invitecode", userDto.getInvitecode());
		mav.addObject("invitecodecount", userDto.getInvitecodecount());
		mav.addObject("markcount", userDto.getMarkcount());
		
		mav.addObject("ent", userDto.getEnt());
		mav.addObject("cardurl", userDto.getCardurl());
		mav.addObject("bcardurl", userDto.getBcardurl());
		mav.addObject("blicenseurl", userDto.getBlicenseurl());
		mav.addObject("idcardurl", userDto.getIdcardurl());
		mav.addObject("dlicenseurl", userDto.getDlicenseurl());
		mav.addObject("rlicenseurl", userDto.getRlicenseurl());
		
		mav.setViewName("admin/userdtl");
		return mav;
	}
	
	//表单验证
	public void validParam(QryUserListDto qryUserListDto,MgResult result){
		if(qryUserListDto.getUsertype()!=null && qryUserListDto.getUsertype()!=0 && qryUserListDto.getUsertype()!=Constants.USER_GE && qryUserListDto.getUsertype()!=Constants.USER_GP && qryUserListDto.getUsertype()!=Constants.USER_CE && qryUserListDto.getUsertype()!=Constants.USER_CP){
			result.setSuccess(false);
			result.setMsg("用户类型不正确");
			return;
		}else if(!StringUtils.isEmpty(qryUserListDto.getPhoneno()) && !qryUserListDto.getPhoneno().matches("^\\d+$")){
			result.setSuccess(false);
			result.setMsg("手机号码格式不正确");
			return;
		}else if(qryUserListDto.getIsabled()!=null && qryUserListDto.getIsabled()!=0 && qryUserListDto.getIsabled()!=Constants.ABLE_YES && qryUserListDto.getIsabled()!=Constants.ABLE_NO){
			result.setSuccess(false);
			result.setMsg("是否启用不正确");
			return;
		}else{
			if(qryUserListDto.getPage()==null || qryUserListDto.getPage()<=0){
				qryUserListDto.setPage(Constants.DEFAULT_CURRENTPAGE);
			}
			if(qryUserListDto.getRows()==null || qryUserListDto.getRows()<=0){
				qryUserListDto.setRows(Constants.DEFAULT_PAGESIZE);
			}
			result.setSuccess(true);
			result.setMsg("验证成功");
			return;
		}
	}
}
