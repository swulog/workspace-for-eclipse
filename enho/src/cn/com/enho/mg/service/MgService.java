package cn.com.enho.mg.service;

import java.util.List;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.ExcelUserBean;
import cn.com.enho.comm.MgResult;
import cn.com.enho.comm.Result;
import cn.com.enho.mg.dto.AppDto;
import cn.com.enho.mg.dto.AppdocDto;
import cn.com.enho.mg.dto.CarDto;
import cn.com.enho.mg.dto.DelDto;
import cn.com.enho.mg.dto.GoodsDto;
import cn.com.enho.mg.dto.QryAppListDto;
import cn.com.enho.mg.dto.QryAppdocListDto;
import cn.com.enho.mg.dto.QryCarListDto;
import cn.com.enho.mg.dto.QryFeedBackListDto;
import cn.com.enho.mg.dto.QryGoodsListDto;
import cn.com.enho.mg.dto.QryRGroupListDto;
import cn.com.enho.mg.dto.QryRuleListDto;
import cn.com.enho.mg.dto.QryUserListDto;
import cn.com.enho.mg.dto.RGroupDto;
import cn.com.enho.mg.dto.RuleDto;
import cn.com.enho.mg.dto.UserDto;
import cn.com.enho.mg.entity.Rule;

/**
 * 		后台管理Service
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-16 下午12:21:22
 */
public interface MgService extends BaseService{

	public void getMenu(Result result);
	public void qryGoodsList(QryGoodsListDto qryGoodsListDto, MgResult result);
	public void qryCarList(QryCarListDto qryCarListDto, MgResult result);
	public void qryFeedBackList(QryFeedBackListDto qryFeedBackDto,MgResult result);
	public void addRule(RuleDto ruleDto,MgResult result);
	public void updateRule(RuleDto ruleDto,MgResult result);
	public void delRule(DelDto delDto,MgResult result);
	public void qryRuleList(QryRuleListDto qryRuleListDto,MgResult result);
	public List<Rule> qryRuleList(DelDto delDto);
	public void qryUserList(QryUserListDto qryUserListDto,MgResult result);
	public void qryUserDtl(String userid,String baseurl,Result result);
	public void addUser(UserDto userDto,Result result);
	public void updateUser(UserDto userDto,Result result);
	public void delUser(DelDto delDto,String desdir,MgResult result);
	public void addGoods(GoodsDto goodsDto,MgResult result);
	public void updateGoods(GoodsDto goodsDto,MgResult result);
	public void delGoods(DelDto delDto,MgResult result);
	public void addCar(CarDto carDto,MgResult result);
	public void updateCar(CarDto carDto,MgResult result);
	public void delCar(DelDto delDto,MgResult result);
	public void delFeedback(DelDto delDto,MgResult result);
	public void addRGroup(RGroupDto RGroupDto,MgResult result);
	public void qryRGroupList(QryRGroupListDto qryRGroupDto,MgResult result);
	public void updateRGroup(RGroupDto rGroupDto,MgResult result);
	public void delRGroup(DelDto delDto,MgResult result);
	public void qryAppList(QryAppListDto qryAppListDto,MgResult result);
	public void addApp(AppDto appDto,MgResult result);
	public void updateApp(AppDto appDto,MgResult result);
	public void delApp(DelDto delDto,String desdir,MgResult result);
	public void importUser(List<ExcelUserBean> list,String baseurl,Result result);
	public void qryAppdocList(QryAppdocListDto qryAppdocListDto,MgResult result);
	public void addAppdoc(AppdocDto appdocDto,MgResult result);
	public void updateAppdoc(AppdocDto appdocDto,MgResult result);
	public void delAppdoc(DelDto delDto,MgResult result);
	
}
