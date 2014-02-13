package cn.com.enho.mg.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import ch.hsr.geohash.GeoHash;
import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.ExcelUserBean;
import cn.com.enho.comm.MgResult;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.DateUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.comm.util.UUIDUtil;
import cn.com.enho.mg.dao.MgDao;
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
import cn.com.enho.mg.entity.AppInfo;
import cn.com.enho.mg.entity.Menu;
import cn.com.enho.mg.entity.RGroup;
import cn.com.enho.mg.entity.Rule;
import cn.com.enho.mg.service.MgService;
import cn.com.enho.terminal.entity.CarInfo;
import cn.com.enho.terminal.entity.Doc;
import cn.com.enho.terminal.entity.FeedBack;
import cn.com.enho.terminal.entity.GoodsInfo;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.entity.UserExtend;
import cn.com.enho.terminal.entity.Wayline;

/**
 * 		后台管理Service
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-16 下午12:20:45
 */
public class MgServiceImpl extends BaseServiceImpl implements MgService{

	@Autowired
	private MgDao mgDao;
	
	/**
	 * 获取菜单
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void getMenu(Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from Menu m where m.parent.t_menu_id=0 and m.t_menu_isabled=1 and m.parent.t_menu_id is not null order by m.parent.t_menu_id,m.t_menu_order asc");
		//List<Menu> list=(List<Menu>)this.mgDao.findByHql(sb.toString());
		List<Menu> list=(List<Menu>)this.mgDao.findByHql(sb.toString());
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				Map<Object,Object> attrs=new HashMap<Object,Object>();
				mapData.put("id", list.get(i).getT_menu_code());
				mapData.put("text", StringUtil.nullToStr(list.get(i).getT_menu_name()));
				mapData.put("url", StringUtil.nullToStr(list.get(i).getT_menu_url()));
				
				//二级菜单
				List<Menu> children=list.get(i).getChildren();
				List<Map<Object,Object>> childrenList=new ArrayList<Map<Object,Object>>();
				if(children!=null && children.size()>0){
					for(Iterator<Menu> it=children.iterator();it.hasNext();){
						Menu menu=it.next();
						Map<Object,Object> childMap=new HashMap<Object,Object>();
						Map<Object,Object> childAttrs=new HashMap<Object,Object>();
						childMap.put("id", menu.getT_menu_code());
						childMap.put("text", StringUtil.nullToStr(menu.getT_menu_name()));
						childAttrs.put("url", StringUtil.nullToStr(menu.getT_menu_url()));
						childMap.put("attributes", childAttrs);
						//childMap.put("order", menu.getT_menu_order());
						childrenList.add(childMap);
					} 
					//CollectionUtil.sort(childrenList);
					mapData.put("state", "closed");
					mapData.put("children", childrenList);
				}else{
					mapData.put("state", "open");
					attrs.put("url", StringUtil.nullToStr(list.get(i).getT_menu_url()));
					mapData.put("attributes", attrs);
				}
				
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
		return;
	}

	
	/**
	 * 查询货源信息列表
	 */
	@SuppressWarnings({ "unchecked" })
	@Override
	public void qryGoodsList(QryGoodsListDto qryGoodsListDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("select distinct(g) from GoodsInfo g join g.waylines w where 1=1 ");
		if(!StringUtils.isEmpty(qryGoodsListDto.getStartp())){
			sb.append(" and g.t_goods_startp like '%"+qryGoodsListDto.getStartp().trim()+"%'");
		}
		if(!StringUtils.isEmpty(qryGoodsListDto.getStartc())){
			sb.append(" and g.t_goods_startc like '%"+qryGoodsListDto.getStartc().trim()+"%'");
		}
		if(!StringUtils.isEmpty(qryGoodsListDto.getStartd())){
			sb.append(" and g.t_goods_startd like '%"+qryGoodsListDto.getStartd().trim()+"%'");
		}
		if(!StringUtils.isEmpty(qryGoodsListDto.getEndp())){
			sb.append(" and g.t_goods_endp like '%"+qryGoodsListDto.getEndp().trim()+"%'");
		}
		if(!StringUtils.isEmpty(qryGoodsListDto.getEndc())){
			sb.append(" and g.t_goods_endc like '%"+qryGoodsListDto.getEndc().trim()+"%'");
		}
		if(!StringUtils.isEmpty(qryGoodsListDto.getEndd())){
			sb.append(" and g.t_goods_endd like '%"+qryGoodsListDto.getEndd().trim()+"%'");
		}
		//查询我发布
		if(!StringUtils.isEmpty(qryGoodsListDto.getUserid())){
			sb.append(" and g.t_goods_userid.t_user_id='"+qryGoodsListDto.getUserid().trim()+"'");
		}else{
			sb.append(" and (g.t_goods_status="+Constants.STATUS_NORMAL+" or g.t_goods_status="+Constants.STATUS_LOCK+")");
		}
		sb.append(" and g.t_goods_isabled="+Constants.ABLE_YES);
		
		sb.append(" order by g.t_goods_lastupdatetime desc");
		
		
		List<GoodsInfo> totalList=(List<GoodsInfo>)this.mgDao.findByHql(sb.toString());
		List<GoodsInfo> list=(List<GoodsInfo>)this.mgDao.findByHql(sb.toString(), (qryGoodsListDto.getPage()-1)*qryGoodsListDto.getRows(), qryGoodsListDto.getRows());
		
		if(totalList!=null && totalList.size()>0){
			result.setTotal(list.size());
		}
		
		String baseurl=qryGoodsListDto.getBaseurl()==null?"":qryGoodsListDto.getBaseurl();
		
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("id", list.get(i).getT_goods_id());//id
				mapData.put("wayline", list.get(i).getWaylines());//路线列表
				
				String image1=list.get(i).getT_goods_image1();
				String image2=list.get(i).getT_goods_image2();
				String image3=list.get(i).getT_goods_image3();
				 
				if(image1!=null && !"".equals(image1)){
					image1=baseurl+image1;
				}
				if(image2!=null && !"".equals(image2)){
					image2=baseurl+image2;
				}
				if(image3!=null && !"".equals(image3)){
					image3=baseurl+image3;
				}
				
				mapData.put("image1", image1);//货源图片1地址
				mapData.put("image2", image2);//货源图片2地址
				mapData.put("image3", image3);//货源图片3地址
				
				
				String cardurl=list.get(i).getT_goods_userid().getUserExtend().getT_user_cardurl();
				String bcardurl=list.get(i).getT_goods_userid().getUserExtend().getT_user_bcardurl();
				String blicenseurl=list.get(i).getT_goods_userid().getUserExtend().getT_user_blicenseurl();
				String dlicenseurl=list.get(i).getT_goods_userid().getUserExtend().getT_user_dlicenseurl();
				String rlicenseurl=list.get(i).getT_goods_userid().getUserExtend().getT_user_rlicenseurl();
				
				if(cardurl!=null && !"".equals(cardurl)){
					cardurl=baseurl+cardurl;
				}
				if(bcardurl!=null && !"".equals(bcardurl)){
					bcardurl=baseurl+bcardurl;
				}
				if(blicenseurl!=null && !"".equals(blicenseurl)){
					blicenseurl=baseurl+blicenseurl;
				}
				if(dlicenseurl!=null && !"".equals(dlicenseurl)){
					dlicenseurl=baseurl+dlicenseurl;
				}
				if(rlicenseurl!=null && !"".equals(rlicenseurl)){
					rlicenseurl=baseurl+rlicenseurl;
				}
				
				mapData.put("cardurl", cardurl);
				mapData.put("bcardurl", bcardurl);
				mapData.put("blicenseurl", blicenseurl);
				mapData.put("dlicenseurl", dlicenseurl);
				mapData.put("rlicenseurl", rlicenseurl);
				
				mapData.put("pusertype", list.get(i).getT_goods_userid().getT_user_type());
				
				mapData.put("desc", list.get(i).getT_goods_desc());//货源描述
				mapData.put("weight", list.get(i).getT_goods_weight());//货源重量
				mapData.put("sendtime", list.get(i).getT_goods_sendtime());//发货时间
				mapData.put("carlength", list.get(i).getT_goods_carlength());//所需车长
				mapData.put("username", list.get(i).getT_goods_contactsname());//联系人姓名
				mapData.put("userphone", list.get(i).getT_goods_contactsphone());//联系人手机号
				mapData.put("usertel", list.get(i).getT_goods_contactstel());//联系人固话
				mapData.put("userid", list.get(i).getT_goods_userid().getT_user_id());//发布人id
				mapData.put("lastupdatetime", list.get(i).getT_goods_lastupdatetime());//货源最后修改时间
				mapData.put("status", list.get(i).getT_goods_status());//货源状态
				mapData.put("longitude", list.get(i).getT_goods_x());//经度
				mapData.put("latitude", list.get(i).getT_goods_y());//纬度
				mapData.put("createtime", list.get(i).getT_goods_createtime());//发布时间
				mapData.put("remark", list.get(i).getT_remark());//备注
				mapData.put("infotype", Constants.INFO_G);//信息类型
				mapData.put("pubphone", list.get(i).getT_goods_userid().getT_user_phone());//发布人手机号码
				result.getRows().add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		return;
	}

	/**
	 * 查询车源信息列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryCarList(QryCarListDto qryCarListDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("select distinct(c) from CarInfo c join c.waylines w where 1=1");
		if(!StringUtils.isEmpty(qryCarListDto.getStartp())){
			sb.append(" and c.t_car_startp like '%"+qryCarListDto.getStartp().trim()+"%'");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getStartc())){
			sb.append(" and c.t_car_startc like '%"+qryCarListDto.getStartc().trim()+"%'");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getStartd())){
			sb.append(" and c.t_car_startd like '%"+qryCarListDto.getStartd().trim()+"%'");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getEndp())){
			sb.append(" and c.t_car_endp like '%"+qryCarListDto.getEndp().trim()+"%'");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getEndc())){
			sb.append(" and c.t_car_endc like '%"+qryCarListDto.getEndc().trim()+"%'");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getEndd())){
			sb.append(" and c.t_car_endd like '%"+qryCarListDto.getEndd().trim()+"%'");
		}
		//查询已发布
		if(!StringUtils.isEmpty(qryCarListDto.getUserid())){
			sb.append(" and c.t_car_userid.t_user_id='"+qryCarListDto.getUserid().trim()+"'");
		}else{
			sb.append(" and (c.t_car_status="+Constants.STATUS_NORMAL+" or c.t_car_status="+Constants.STATUS_LOCK+")");
		}
		sb.append(" and c.t_car_isabled="+Constants.ABLE_YES);
		
		sb.append(" order by c.t_car_lastupdatetime desc");
		
		List<CarInfo> totalList=(List<CarInfo>)this.mgDao.findByHql(sb.toString());
		List<CarInfo> list=(List<CarInfo>)this.mgDao.findByHql(sb.toString(), (qryCarListDto.getPage()-1)*qryCarListDto.getRows(), qryCarListDto.getRows());
		
		if(totalList!=null && totalList.size()>0){
			result.setTotal(list.size());
		}
		
		String baseurl=qryCarListDto.getBaseurl()==null?"":qryCarListDto.getBaseurl();
		
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("id", list.get(i).getT_car_id());//id
				mapData.put("wayline", list.get(i).getWaylines());//路线列表
				
				mapData.put("desc", list.get(i).getT_car_desc());//车源描述
				mapData.put("weight", list.get(i).getT_car_weight());//载重
				mapData.put("length", list.get(i).getT_car_length());//车长
				mapData.put("carno", list.get(i).getT_car_no());//车牌号
				
				String image1=list.get(i).getT_car_image1();
				String image2=list.get(i).getT_car_image2();
				String image3=list.get(i).getT_car_image3();
				 
				if(image1!=null && !"".equals(image1)){
					image1=baseurl+image1;
				}
				if(image2!=null && !"".equals(image2)){
					image2=baseurl+image2;
				}
				if(image3!=null && !"".equals(image3)){
					image3=baseurl+image3;
				}
				
				mapData.put("image1", image1);//车源图片1地址
				mapData.put("image2", image2);//车源图片2地址
				mapData.put("image3", image3);//车源图片3地址
				
				String cardurl=list.get(i).getT_car_userid().getUserExtend().getT_user_cardurl();
				String bcardurl=list.get(i).getT_car_userid().getUserExtend().getT_user_bcardurl();
				String blicenseurl=list.get(i).getT_car_userid().getUserExtend().getT_user_blicenseurl();
				String dlicenseurl=list.get(i).getT_car_userid().getUserExtend().getT_user_dlicenseurl();
				String rlicenseurl=list.get(i).getT_car_userid().getUserExtend().getT_user_rlicenseurl();
				
				if(cardurl!=null && !"".equals(cardurl)){
					cardurl=baseurl+cardurl;
				}
				if(bcardurl!=null && !"".equals(bcardurl)){
					bcardurl=baseurl+bcardurl;
				}
				if(blicenseurl!=null && !"".equals(blicenseurl)){
					blicenseurl=baseurl+blicenseurl;
				}
				if(dlicenseurl!=null && !"".equals(dlicenseurl)){
					dlicenseurl=baseurl+dlicenseurl;
				}
				if(rlicenseurl!=null && !"".equals(rlicenseurl)){
					rlicenseurl=baseurl+rlicenseurl;
				}
				
				mapData.put("cardurl", cardurl);
				mapData.put("bcardurl", bcardurl);
				mapData.put("blicenseurl", blicenseurl);
				mapData.put("dlicenseurl", dlicenseurl);
				mapData.put("rlicenseurl", rlicenseurl);
				
				mapData.put("pusertype", list.get(i).getT_car_userid().getT_user_type());
				
				mapData.put("username", list.get(i).getT_car_contactsname());//联系人姓名
				mapData.put("userphone", list.get(i).getT_car_contactsphone());//联系人手机号
				mapData.put("usertel", list.get(i).getT_car_contactstel());//联系人电话
				mapData.put("userid", list.get(i).getT_car_userid().getT_user_id());//发布人id
				mapData.put("lastupdatetime", list.get(i).getT_car_lastupdatetime());//车源最后修改时间
				mapData.put("sendtime", list.get(i).getT_car_sendtime());//发车时间
				mapData.put("status", list.get(i).getT_car_status());//车源状态
				mapData.put("longitude", list.get(i).getT_car_x());//经度
				mapData.put("latitude", list.get(i).getT_car_y());//纬度
				mapData.put("remark", list.get(i).getT_remark());//备注说明
				mapData.put("createtime", list.get(i).getT_car_createtime());//发布时间
				mapData.put("infotype", Constants.INFO_C);//信息类型
				result.getRows().add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		return;
	}

	/**
	 * 查询反馈信息
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryFeedBackList(QryFeedBackListDto qryFeedBackDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from FeedBack f where 1=1");
		if(qryFeedBackDto.getPhone()!=null && !"".equals(qryFeedBackDto.getPhone())){
			sb.append(" and f.user.t_user_phone='"+qryFeedBackDto.getPhone()+"'");
		}
		List<FeedBack> totalList=(List<FeedBack>)this.mgDao.findByHql(sb.toString());
		List<FeedBack> list=(List<FeedBack>)this.mgDao.findByHql(sb.toString(),(qryFeedBackDto.getPage()-1)*qryFeedBackDto.getRows(), qryFeedBackDto.getPage());
		
		if(totalList!=null && totalList.size()>0){
			result.setTotal(list.size());
		}
	
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("id", list.get(i).getT_feedback_id());//id
				mapData.put("content", list.get(i).getT_feedback_content());//出发地（省）
				mapData.put("createtime", list.get(i).getT_feedback_createtime());//发布时间
				mapData.put("phone", list.get(i).getUser().getT_user_phone());//发布时间
				result.getRows().add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		return;
	}

	/**
	 * 新增规则
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void addRule(RuleDto ruleDto, MgResult result) {
		// TODO Auto-generated method stub
		
		StringBuilder sb=new StringBuilder();
		sb.append("from Rule r where r.t_rule_key=?");
		List<Rule> list=(List<Rule>)this.mgDao.findByHql(sb.toString(), ruleDto.getKey());
		if(list!=null && list.size()>0){
			result.setSuccess(false);
			result.setMsg("规则key已存在");
			return;
		}
		
		Rule rule=new Rule();
		rule.setT_rule_id(UUIDUtil.getUUID());
		rule.setT_rule_name(ruleDto.getName());
		rule.setT_rule_key(ruleDto.getKey());
		rule.setT_rule_value(StringUtil.nullToStr(ruleDto.getValue()));
		rule.setT_rule_desc(StringUtil.nullToStr(ruleDto.getDesc()));
		rule.setT_rule_isabled(ruleDto.getIsabled());
		String time=DateUtil.getCurrentTime4Str();
		rule.setT_rule_createtime(time);
		rule.setT_rule_lastupdatetime(time);
		RGroup group=new RGroup();
		group.setT_rgroup_id(ruleDto.getGroupid());
		rule.setGroup(group);
		this.mgDao.insert(rule);
		
		result.setSuccess(true);
		result.setMsg("新增成功");
		return;
	}

	/**
	 * 修改规则
	 */
	@Override
	public void updateRule(RuleDto ruleDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("update Rule r set r.t_rule_name=?,r.t_rule_value=?,r.t_rule_desc=?");
		int isabled=ruleDto.getIsabled();
		if(isabled==Constants.ABLE_NO || isabled==Constants.ABLE_YES){
			sb.append(",r.t_rule_isabled=?");
		}
		sb.append(",r.t_rule_lastupdatetime=? where r.t_rule_id=?");
		this.mgDao.updateByHql(sb.toString(), StringUtil.nullToStr(ruleDto.getName()),StringUtil.nullToStr(ruleDto.getValue()),StringUtil.nullToStr(ruleDto.getDesc()),isabled,DateUtil.getCurrentTime4Str(),ruleDto.getId());
		
		result.setSuccess(true);
		result.setMsg("修改成功");
		return;
	}

	/**
	 * 删除规则
	 */
	@Override
	public void delRule(DelDto delDto, MgResult result) {
		// TODO Auto-generated method stub
		List<String> list=delDto.getId();
		StringBuilder sb=new StringBuilder();
		if(list!=null && list.size()>0){
			sb.append("delete from Rule r where r.t_rule_id in (");
			for(int i=0,len=list.size();i<len;i++){
				if(i==len-1){
					sb.append("'"+list.get(i)+"'");
				}else{
					sb.append("'"+list.get(i)+"',");
				}
			}
			sb.append(")");
		}
		this.mgDao.updateByHql(sb.toString());
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
		return;
	}

	/**
	 * 查询规则
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryRuleList(QryRuleListDto qryRuleListDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from Rule r where 1=1");
		if(qryRuleListDto.getKey()!=null && !"".equals(qryRuleListDto.getKey())){
			sb.append(" and r.t_rule_key like '%"+qryRuleListDto.getKey()+"%'");
		}
		if(qryRuleListDto.getName()!=null && !"".equals(qryRuleListDto.getName())){
			sb.append(" and r.t_rule_name like '%"+qryRuleListDto.getName()+"%'");
		}
		if(qryRuleListDto.getGroupid()!=null && !"".equals(qryRuleListDto.getGroupid())){
			sb.append(" and r.group.t_rgroup_id='"+qryRuleListDto.getGroupid()+"'");
		}
		if(qryRuleListDto.getIsabled()!=null && (qryRuleListDto.getIsabled()==Constants.ABLE_YES || qryRuleListDto.getIsabled()==Constants.ABLE_NO)){
			sb.append(" and r.t_rule_isabled="+qryRuleListDto.getIsabled());
		}
		sb.append(" order by r.t_rule_lastupdatetime desc");
		List<Rule> totalList=(List<Rule>)this.mgDao.findByHql(sb.toString());
		List<Rule> list=(List<Rule>)this.mgDao.findByHql(sb.toString(),(qryRuleListDto.getPage()-1)*qryRuleListDto.getRows(), qryRuleListDto.getRows());
		
		if(totalList!=null && totalList.size()>0){
			result.setTotal(list.size());
		}
		
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("id", list.get(i).getT_rule_id());//id
				mapData.put("name", list.get(i).getT_rule_name());//id
				mapData.put("key", list.get(i).getT_rule_key());//出发地（省）
				mapData.put("value", list.get(i).getT_rule_value());//出发地（市）
				mapData.put("desc", list.get(i).getT_rule_desc());//出发地（市）
				mapData.put("isabled", list.get(i).getT_rule_isabled());//出发地（市）
				mapData.put("createtime", list.get(i).getT_rule_createtime());//出发地（区）
				mapData.put("lastupdatetime", list.get(i).getT_rule_lastupdatetime());//到达地（省）
				mapData.put("groupid", list.get(i).getGroup().getT_rgroup_id());//到达地（省）
				mapData.put("groupname", list.get(i).getGroup().getT_rgroup_name());//到达地（省）
				result.getRows().add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		return;
	}

	/**
	 * 查询用户列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryUserList(QryUserListDto qryUserListDto,MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from User u where 1=1");
		if(qryUserListDto.getUsertype()!=null && (qryUserListDto.getUsertype()==Constants.USER_GE || qryUserListDto.getUsertype()==Constants.USER_GP || qryUserListDto.getUsertype()==Constants.USER_CE || qryUserListDto.getUsertype()==Constants.USER_CP)){
			sb.append(" and u.t_user_type="+qryUserListDto.getUsertype());
		}
		if(qryUserListDto.getIsabled()!=null && (qryUserListDto.getIsabled()==Constants.ABLE_YES || qryUserListDto.getIsabled()==Constants.ABLE_NO)){
			sb.append(" and u.t_user_isabled="+qryUserListDto.getIsabled());
		}
		if(!StringUtils.isEmpty(qryUserListDto.getPhoneno())){
			sb.append(" and u.t_user_phone like '%"+qryUserListDto.getPhoneno()+"%'");
		}
		sb.append(" order by u.t_user_lastupdatetime desc");
		
		List<User> totalList=(List<User>)this.mgDao.findByHql(sb.toString());
		List<User> list=(List<User>)this.mgDao.findByHql(sb.toString(), (qryUserListDto.getPage()-1)*qryUserListDto.getRows(), qryUserListDto.getRows());
		
		if(totalList!=null && totalList.size()>0){
			result.setTotal(list.size());
		}
		
		String baseurl=qryUserListDto.getBaseurl()==null?"":qryUserListDto.getBaseurl();
		
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("phone", list.get(i).getT_user_phone());//手机号码
				mapData.put("type", list.get(i).getT_user_type());//用户类型
				mapData.put("integral",list.get(i).getT_user_integral());//用户积分
				mapData.put("creditrating", list.get(i).getT_user_creditrating());//信誉值
				mapData.put("isabled", list.get(i).getT_user_isabled());//是否有效
				mapData.put("id", list.get(i).getT_user_id());//id
				mapData.put("pwd", list.get(i).getT_user_pwd());//密码
				mapData.put("tel", StringUtil.nullToStr(list.get(i).getT_user_tel()));//电话号码
				mapData.put("name", StringUtil.nullToStr(list.get(i).getT_user_name()));//用户名称
				mapData.put("x", StringUtil.nullToDouble(list.get(i).getT_user_x()));//经度
				mapData.put("y", StringUtil.nullToDouble(list.get(i).getT_user_y()));//纬度
				mapData.put("createtime", list.get(i).getT_user_createtime());//创建时间
				mapData.put("lastupdatetime", list.get(i).getT_user_lastupdatetime());//最后修改时间
				mapData.put("invitecode", StringUtil.nullToStr(list.get(i).getT_user_invitecode()));//邀请码
				mapData.put("invitecodecount", list.get(i).getT_user_invitecodecount());//邀请码剩余次数
				mapData.put("markcount", list.get(i).getT_user_markcount());//被评分次数
				
				mapData.put("ent",StringUtil.nullToStr(list.get(i).getT_user_ent()));
				
				String cardurl=StringUtil.nullToStr(list.get(i).getUserExtend().getT_user_cardurl());
				String bcardurl=StringUtil.nullToStr(list.get(i).getUserExtend().getT_user_bcardurl());
				String blicenseurl=StringUtil.nullToStr(list.get(i).getUserExtend().getT_user_blicenseurl());
				String dlicenseurl=StringUtil.nullToStr(list.get(i).getUserExtend().getT_user_dlicenseurl());
				String rlicenseurl=StringUtil.nullToStr(list.get(i).getUserExtend().getT_user_rlicenseurl());
				
				if(cardurl!=null && !"".equals(cardurl)){
					cardurl=baseurl+cardurl;
				}
				if(bcardurl!=null && !"".equals(bcardurl)){
					bcardurl=baseurl+bcardurl;
				}
				if(blicenseurl!=null && !"".equals(blicenseurl)){
					blicenseurl=baseurl+blicenseurl;
				}
				if(dlicenseurl!=null && !"".equals(dlicenseurl)){
					dlicenseurl=baseurl+dlicenseurl;
				}
				if(rlicenseurl!=null && !"".equals(rlicenseurl)){
					rlicenseurl=baseurl+rlicenseurl;
				}
				
				if(list.get(i).getT_user_type()==1 || list.get(i).getT_user_type()==3){
					mapData.put("cardurl", cardurl);
				}else if(list.get(i).getT_user_type()==4){
					mapData.put("idcardurl", cardurl);
				}else{}
				
				mapData.put("bcardurl", bcardurl);
				mapData.put("blicenseurl", blicenseurl);
				mapData.put("dlicenseurl", dlicenseurl);
				mapData.put("rlicenseurl", rlicenseurl);
				
				result.getRows().add(mapData);
			}
		}
		result.setSuccess(true);
		result.setMsg("查询成功");
		return;
	}
	
	
	/**
	 * 新增用户
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void addUser(UserDto userDto, Result result) {
		// TODO Auto-generated method stub
		String hql="from User u where u.t_user_phone=?";
		//查询当前手机号码是否已被注册
		List<User> list=(List<User>)this.mgDao.findByHql(hql, userDto.getPhone());
		if(list!=null && list.size()>0){
			//注册失败
			result.setSuccess(false);
			result.setMsg("此手机号码已存在");
			return;
		}else{
			//插入注册信息
			User user=new User();
			String uuid=UUIDUtil.getUUID();
			user.setT_user_id(uuid);//id
			user.setT_user_phone(userDto.getPhone());//手机号码
			user.setT_user_pwd(userDto.getPwd());//密码
			user.setT_user_type(userDto.getType());//用户类型
			user.setT_user_tel(StringUtil.nullToStr(userDto.getTel()));//固话号码
			user.setT_user_name(StringUtil.nullToStr(userDto.getName()));//名称
			user.setT_user_ent(StringUtil.nullToStr(userDto.getEnt()));//所属企业
			String currentTime=DateUtil.getCurrentTime4Str();//当前时间
			user.setT_user_createtime(currentTime);//注册时间
			user.setT_user_lastupdatetime(currentTime);//最后修改时间
			user.setT_user_invitecode(StringUtil.getInvitecode());//邀请码
			user.setT_user_invitecodecount(Constants.DEFAULT_INVITECODE_COUNT);//默认邀请码可用次数
			
			UserExtend userExtend=new UserExtend();
			userExtend.setT_user_id(uuid);
			
			if(userDto.getType()==1 || userDto.getType()==3){
				userExtend.setT_user_cardurl(StringUtil.nullToStr(userDto.getCardurl()));
			}else if(userDto.getType()==4){
				userExtend.setT_user_cardurl(StringUtil.nullToStr(userDto.getIdcardurl()));
			}else{}
			
			userExtend.setT_user_bcardurl(StringUtil.nullToStr(userDto.getBcardurl()));
			userExtend.setT_user_blicenseurl(StringUtil.nullToStr(userDto.getBlicenseurl()));
			userExtend.setT_user_dlicenseurl(StringUtil.nullToStr(userDto.getDlicenseurl()));
			userExtend.setT_user_rlicenseurl(StringUtil.nullToStr(userDto.getRlicenseurl()));
			
			user.setUserExtend(userExtend);
			
			this.mgDao.insert(user);
			
			//注册成功
			result.setSuccess(true);
			result.setMsg("新增成功");
			result.getData().put("userid",uuid);
			return;	
		}
	}


	/**
	 * 修改用户
	 */
	@Override
	public void updateUser(UserDto userDto, Result result) {
		// TODO Auto-generated method stub
		String phone=StringUtil.nullToStr(userDto.getPhone());//手机号码
		String pwd=StringUtil.nullToStr(userDto.getPwd());//密码
		String tel=StringUtil.nullToStr(userDto.getTel());//固话号码
		Double integral=StringUtil.nullToDouble(userDto.getIntegral());
		Double creditrating=StringUtil.nullToDouble(userDto.getCreditrating());
		String invitecode=StringUtil.nullToStr(userDto.getInvitecode());
		Integer invitecodecount=StringUtil.nullToInteger(userDto.getInvitecodecount());
		Integer markcount=StringUtil.nullToInteger(userDto.getMarkcount());
		String name=StringUtil.nullToStr(userDto.getName());//用户名称
		Double x=StringUtil.nullToDouble(userDto.getX());//经度
		Double y=StringUtil.nullToDouble(userDto.getY());//纬度
		String xycode="";
		// 获取经纬度geohash编码
		if (StringUtil.nullToDouble(userDto.getX()) == 0 || StringUtil.nullToDouble(userDto.getY()) == 0) {
			xycode="";
		} else {
			xycode=GeoHash.withCharacterPrecision(userDto.getY(), userDto.getX(),Constants.DEFAULT_XY_PRECISION).toBase32();
		}
		
		String lastupdatetime=DateUtil.getCurrentTime4Str();//最后修改时间
		
		String cardurl=userDto.getCardurl();//名片正面图片url
		String bcardurl=userDto.getBcardurl();//名片反面图片url
		String blicenseurl=userDto.getBlicenseurl();//营业执照图片url
		String idcardurl=userDto.getIdcardurl();//身份证图片url
		String dlicenseurl=userDto.getDlicenseurl();//驾驶证图片url
		String rlicenseurl=userDto.getRlicenseurl();//行驶证图片url
		
		//修改user
		StringBuilder sb1=new StringBuilder();
		sb1.append("update User u set ");
		sb1.append(" u.t_user_phone=?,");
		sb1.append(" u.t_user_pwd=?,");
		sb1.append(" u.t_user_tel=?,");
		sb1.append(" u.t_user_name=?,");
		sb1.append(" u.t_user_integral=?,");
		sb1.append(" u.t_user_creditrating=?,");
		sb1.append(" u.t_user_x=?,");
		sb1.append(" u.t_user_y=?,");
		sb1.append(" u.t_user_xycode=?,");
		sb1.append(" u.t_user_isabled=?,");
		sb1.append(" u.t_user_lastupdatetime=?");
		sb1.append(" u.t_user_invitecode=?");
		sb1.append(" u.t_user_invitecodecount=?");
		sb1.append(" u.t_user_markcount=?");
		sb1.append(" where u.t_user_id=?");
		this.mgDao.updateByHql(sb1.toString(),phone,pwd,tel,name,integral,creditrating,x,y,xycode,lastupdatetime,invitecode,invitecodecount,markcount,userDto.getId());
		
		
		//修改userextend
		//如果修改了图片
		if(!StringUtils.isEmpty(cardurl) || !StringUtils.isEmpty(bcardurl) || !StringUtils.isEmpty(blicenseurl) || !StringUtils.isEmpty(idcardurl) || !StringUtils.isEmpty(dlicenseurl) || !StringUtils.isEmpty(rlicenseurl)){
			UserExtend ue=(UserExtend)this.mgDao.get(UserExtend.class,userDto.getId());
			
			if(!StringUtils.isEmpty(cardurl)){
				ue.setT_user_cardurl(StringUtil.nullToStr(cardurl));
			}
			if(!StringUtils.isEmpty(bcardurl)){
				ue.setT_user_bcardurl(StringUtil.nullToStr(bcardurl));
			}
			if(!StringUtils.isEmpty(blicenseurl)){
				ue.setT_user_blicenseurl(StringUtil.nullToStr(blicenseurl));
			}
			if(!StringUtils.isEmpty(idcardurl)){
				ue.setT_user_cardurl(StringUtil.nullToStr(idcardurl));
			}
			if(!StringUtils.isEmpty(dlicenseurl)){
				ue.setT_user_dlicenseurl(StringUtil.nullToStr(dlicenseurl));
			}
			if(!StringUtils.isEmpty(rlicenseurl)){
				ue.setT_user_rlicenseurl(StringUtil.nullToStr(rlicenseurl));
			}
			this.mgDao.update(ue);
		}		
		
		
		//修改成功
		result.setSuccess(true);
		result.setMsg("修改成功");
		return;
	}


	/**
	 * 删除用户
	 */
	@Override
	public void delUser(DelDto delDto,String desdir,MgResult result) {
		// TODO Auto-generated method stub
		List<String> list=delDto.getId();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				User user=(User)this.mgDao.get(User.class, list.get(i));
				String cardurl=user.getUserExtend().getT_user_cardurl();
				String bcardurl=user.getUserExtend().getT_user_bcardurl();
				String blicense=user.getUserExtend().getT_user_blicenseurl();
				String dlicense=user.getUserExtend().getT_user_dlicenseurl();
				String rlicense=user.getUserExtend().getT_user_rlicenseurl();
				
				/*StringBuilder sb=new StringBuilder();
				this.mgDao.get(FeedBack.class, id);
				sb.append("update FeedBack f set f.user=null where f.user.t_user_id='"+list.get(i)+"'");
				this.mgDao.updateByHql(sb.toString());*/
				
				this.mgDao.delete(user);
				
				if(cardurl!=null && !"".equals(cardurl)){
					File oldfile=new File(desdir+cardurl.substring(cardurl.lastIndexOf("/")));
					//如果存在则删除
					if(oldfile.exists()){
						oldfile.delete();
					}
				}
				if(bcardurl!=null && !"".equals(bcardurl)){
					File oldfile=new File(desdir+bcardurl.substring(bcardurl.lastIndexOf("/")));
					//如果存在则删除
					if(oldfile.exists()){
						oldfile.delete();
					}
				}
				if(blicense!=null && !"".equals(blicense)){
					File oldfile=new File(desdir+blicense.substring(blicense.lastIndexOf("/")));
					//如果存在则删除
					if(oldfile.exists()){
						oldfile.delete();
					}
				}
				if(dlicense!=null && !"".equals(dlicense)){
					File oldfile=new File(desdir+dlicense.substring(dlicense.lastIndexOf("/")));
					//如果存在则删除
					if(oldfile.exists()){
						oldfile.delete();
					}
				}
				if(rlicense!=null && !"".equals(rlicense)){
					File oldfile=new File(desdir+rlicense.substring(rlicense.lastIndexOf("/")));
					//如果存在则删除
					if(oldfile.exists()){
						oldfile.delete();
					}
				}
			}
		}
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
		return;
	}


	/**
	 * 新增货源
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void addGoods(GoodsDto goodsDto, MgResult result) {
		// TODO Auto-generated method stub
		GoodsInfo goodsInfo=new GoodsInfo();
		goodsInfo.setT_goods_id(UUIDUtil.getUUID());//id
		/*goodsInfo.setT_goods_startp(goodsDto.getStartp());//出发地（省）
		goodsInfo.setT_goods_startc(StringUtil.nullToStr(goodsDto.getStartc()));//出发地（市）
		goodsInfo.setT_goods_startd(StringUtil.nullToStr(goodsDto.getStartd()));//出发地（区）
		goodsInfo.setT_goods_endp(goodsDto.getEndp());//到达地（省）
		goodsInfo.setT_goods_endc(StringUtil.nullToStr(goodsDto.getEndc()));//到达地（市）
		goodsInfo.setT_goods_endd(StringUtil.nullToStr(goodsDto.getEndd()));//到达地（区）
*/		goodsInfo.setT_goods_desc(StringUtil.nullToStr(goodsDto.getDesc()));//描述
		goodsInfo.setT_goods_weight(goodsDto.getWeight());//重量
		goodsInfo.setT_goods_carlength(goodsDto.getCarlength());//所需车长
		goodsInfo.setT_goods_sendtime(StringUtil.nullToStr(goodsDto.getSendtime()));//发货时间
		goodsInfo.setT_remark(StringUtil.nullToStr(goodsDto.getRemark()));//备注说明
		goodsInfo.setT_goods_image1(StringUtil.nullToStr(goodsDto.getImage1()));//货源图片
		goodsInfo.setT_goods_image2(StringUtil.nullToStr(goodsDto.getImage2()));//货源图片
		goodsInfo.setT_goods_image3(StringUtil.nullToStr(goodsDto.getImage3()));//货源图片
		goodsInfo.setT_goods_contactsname(goodsDto.getUsername().trim());//联系人名称
		goodsInfo.setT_goods_contactsphone(goodsDto.getUserphone().trim());//联系人手机号码
		//goodsInfo.setT_goods_contactstel(StringUtil.nullToStr(pubGoodsDto.getGoodsusertel()));//联系人固话
		goodsInfo.setT_goods_x(StringUtil.nullToDouble(goodsDto.getLongitude()));//经度
		goodsInfo.setT_goods_y(StringUtil.nullToDouble(goodsDto.getLatitude()));//纬度
		//获取经纬度geohash编码
		if(StringUtil.nullToDouble(goodsDto.getLongitude())==0 || StringUtil.nullToDouble(goodsDto.getLatitude())==0){
			goodsInfo.setT_goods_xycode("");
		}else{
			goodsInfo.setT_goods_xycode(GeoHash.withCharacterPrecision(goodsDto.getLatitude(),goodsDto.getLongitude(),Constants.DEFAULT_XY_PRECISION).toBase32());
		}
		
		User user=null;
		StringBuilder sb1=new StringBuilder();
		sb1.append("from User u where u.t_user_phone='"+goodsDto.getUser()+"'");
		List<User> list=(List<User>)this.mgDao.findByHql(sb1.toString());
		if(list!=null && list.size()>0){
			user=list.get(0);
			goodsInfo.setT_goods_userid(user);//发布人
		}else{
			result.setSuccess(false);
			result.setMsg("发布人不存在");
			return;
		}
		
		
		String currentTime=DateUtil.getCurrentTime4Str();
		goodsInfo.setT_goods_createtime(currentTime);//发布时间
		goodsInfo.setT_goods_lastupdatetime(currentTime);//最后修改时间
		
		this.mgDao.insert(goodsInfo);
		
		//给货主增加积分
		user.setT_user_integral(Constants.DEFAULT_PUB_G+user.getT_user_integral());
		this.mgDao.update(user);
		
		/*StringBuilder sb=new StringBuilder();
		sb.append("update User u  set u.t_user_integral=u.t_user_integral+? where u.t_user_id=?");
		this.mgDao.updateByHql(sb.toString(),Constants.DEFAULT_PUB_G,goodsDto.getUserid().trim());*/
		
		//发布成功
		result.setSuccess(true);
		result.setMsg("发布成功");
		return;
	}


	/**
	 * 修改货源
	 */
	@Override
	public void updateGoods(GoodsDto goodsDto, MgResult result) {
		// TODO Auto-generated method stub
		String t_goods_startp=goodsDto.getStartp().trim();//出发地（省）
		String t_goods_startc=StringUtil.nullToStr(goodsDto.getStartc());//出发地（市）
		String t_goods_startd=StringUtil.nullToStr(goodsDto.getStartd());//出发地（区）
		String t_goods_endp=goodsDto.getEndp().trim();//到达地（省）
		String t_goods_endc=StringUtil.nullToStr(goodsDto.getEndc());//到达地（市）
		String t_goods_endd=StringUtil.nullToStr(goodsDto.getEndd());//到达地（区）
		Double t_goods_weight=goodsDto.getWeight();//重量
		String t_goods_desc=StringUtil.nullToStr(goodsDto.getDesc());//描述
		String t_goods_sendtime=StringUtil.nullToStr(goodsDto.getSendtime());//发货时间
		Double t_goods_carlength=goodsDto.getCarlength();//所需车长
		String t_remark=StringUtil.nullToStr(goodsDto.getRemark());//备注说明
		String t_goods_image1=StringUtil.nullToStr(goodsDto.getImage1());//货源图片1
		String t_goods_image2=StringUtil.nullToStr(goodsDto.getImage2());//货源图片2
		String t_goods_image3=StringUtil.nullToStr(goodsDto.getImage3());//货源图片3
		String t_goods_contactsname=goodsDto.getUsername().trim();//联系人名称
		String t_goods_contactsphone=goodsDto.getUserphone().trim();//联系人手机号码
		String t_goods_contactstel=StringUtil.nullToStr(goodsDto.getUsertel());//联系人电话号码
		Double t_goods_x=StringUtil.nullToDouble(goodsDto.getLongitude());//所在经度
		Double t_goods_y=StringUtil.nullToDouble(goodsDto.getLatitude());//所在纬度
		String t_goods_xycode="";
		//获取经纬度geohash编码
		if(StringUtil.nullToDouble(goodsDto.getLongitude())==0 || StringUtil.nullToDouble(goodsDto.getLatitude())==0){
			t_goods_xycode="";
		}else{
			t_goods_xycode=GeoHash.withCharacterPrecision(goodsDto.getLatitude(),goodsDto.getLongitude(),Constants.DEFAULT_XY_PRECISION).toBase32();
		}
		String t_goods_lastupdatetime=DateUtil.getCurrentTime4Str();//最后修改时间
		
		GoodsInfo goodsInfo=(GoodsInfo)this.mgDao.get(GoodsInfo.class, goodsDto.getId());
		int isabled=goodsInfo.getT_goods_isabled();
		int status=goodsInfo.getT_goods_status();
		if(isabled==Constants.ABLE_NO){
			result.setSuccess(true);
			result.setMsg("此信息无效");
			return;
		}else if(status==Constants.STATUS_LOCK){
			result.setSuccess(true);
			result.setMsg("此信息正在交易中,不允许修改");
			return;
		}else if(status==Constants.STATUS_DOWN){
			result.setSuccess(true);
			result.setMsg("此信息已下架,不允许修改");
			return;
		}else{
			StringBuilder sb=new StringBuilder();
			sb.append("update GoodsInfo g set ");
			sb.append(" g.t_goods_startp=?,");
			sb.append(" g.t_goods_startc=?,");
			sb.append(" g.t_goods_startd=?,");
			sb.append(" g.t_goods_endp=?,");
			sb.append(" g.t_goods_endc=?,");
			sb.append(" g.t_goods_endd=?,");
			sb.append(" g.t_goods_weight=?,");
			sb.append(" g.t_goods_desc=?,");
			sb.append(" g.t_goods_sendtime=?,");
			sb.append(" g.t_goods_carlength=?,");
			sb.append(" g.t_remark=?,");
			sb.append(" g.t_goods_image1=?,");
			sb.append(" g.t_goods_image2=?,");
			sb.append(" g.t_goods_image3=?,");
			sb.append(" g.t_goods_contactsname=?,");
			sb.append(" g.t_goods_contactsphone=?,");
			sb.append(" g.t_goods_contactstel=?,");
			sb.append(" g.t_goods_x=?,");
			sb.append(" g.t_goods_y=?,");
			sb.append(" g.t_goods_xycode=?,");
			sb.append(" g.t_goods_lastupdatetime=?");
			sb.append(" where t_goods_id=?");
			this.mgDao.updateByHql(sb.toString(), t_goods_startp,t_goods_startc,t_goods_startd,t_goods_endp,t_goods_endc,t_goods_endd,t_goods_weight,t_goods_desc,t_goods_sendtime
					,t_goods_carlength,t_remark,t_goods_image1,t_goods_image2,t_goods_image3,t_goods_contactsname,t_goods_contactsphone,t_goods_contactstel,t_goods_x,t_goods_y,t_goods_xycode,t_goods_lastupdatetime,goodsDto.getId());
			
			
			//修改成功
			result.setSuccess(true);
			result.setMsg("修改成功");
			return;
		}
	}


	/**
	 * 删除货源信息
	 */
	@Override
	public void delGoods(DelDto delDto, MgResult result) {
		// TODO Auto-generated method stub
		List<String> list=delDto.getId();
		StringBuilder sb=new StringBuilder();
		if(list!=null && list.size()>0){
			sb.append("delete from GoodsInfo g where g.t_goods_id in (");
			for(int i=0,len=list.size();i<len;i++){
				if(i==len-1){
					sb.append("'"+list.get(i)+"'");
				}else{
					sb.append("'"+list.get(i)+"',");
				}
			}
			sb.append(")");
		}
		this.mgDao.updateByHql(sb.toString());
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
		return;
	}


	/**
	 * 新增车源
	 */
	@Override
	public void addCar(CarDto carDto, MgResult result) {
		// TODO Auto-generated method stub
		CarInfo carInfo=new CarInfo();
		carInfo.setT_car_id(UUIDUtil.getUUID());//id
		/*carInfo.setT_car_startp(carDto.getStartp().trim());//出发地（省）
		carInfo.setT_car_startc(StringUtil.nullToStr(carDto.getStartc()));//出发地（市）
		carInfo.setT_car_startd(StringUtil.nullToStr(carDto.getStartd()));//出发地（区）
		carInfo.setT_car_endp(carDto.getEndp().trim());//到达地（省）
		carInfo.setT_car_endc(StringUtil.nullToStr(carDto.getEndc()));//到达地（市）
		carInfo.setT_car_endd(StringUtil.nullToStr(carDto.getEndd()));//到达地（区）
*/		carInfo.setT_car_no(StringUtil.nullToStr(carDto.getCarno().trim()));//车牌号
		carInfo.setT_car_weight(carDto.getWeight());//载重
		carInfo.setT_car_length(carDto.getCarlength());//车长
		carInfo.setT_car_desc(StringUtil.nullToStr(carDto.getDesc()));//描述
		carInfo.setT_car_sendtime(StringUtil.nullToStr(carDto.getSendtime()));//发车时间
		carInfo.setT_car_image1(StringUtil.nullToStr(carDto.getImage1()));//车源图片1
		carInfo.setT_car_image2(StringUtil.nullToStr(carDto.getImage2()));//车源图片2
		carInfo.setT_car_image3(StringUtil.nullToStr(carDto.getImage3()));//车源图片3
		carInfo.setT_remark(StringUtil.nullToStr(carDto.getRemark()));//备注说明
		carInfo.setT_car_contactsname(carDto.getUsername().trim());//联系人名称
		carInfo.setT_car_contactsphone(carDto.getUserphone().trim());//联系人手机号码
		//carInfo.setT_car_contactstel(StringUtil.nullToStr(carDto.getCarusertel()));//联系人固话号码
		carInfo.setT_car_x(StringUtil.nullToDouble(carDto.getLongitude()));//所在经度
		carInfo.setT_car_y(StringUtil.nullToDouble(carDto.getLatitude()));//所在纬度
		//获取经纬度geohash编码
		if(StringUtil.nullToDouble(carDto.getLongitude())==0 || StringUtil.nullToDouble(carDto.getLatitude())==0){
			carInfo.setT_car_xycode("");
		}else{
			carInfo.setT_car_xycode(GeoHash.withCharacterPrecision(carDto.getLatitude(),carDto.getLongitude(),Constants.DEFAULT_XY_PRECISION).toBase32());
		}
		
		User user=new User();
		user.setT_user_id(carDto.getUserid().trim());
		carInfo.setT_car_userid(user);//发布人id
		
		String currentTime=DateUtil.getCurrentTime4Str();
		carInfo.setT_car_createtime(currentTime);//发布时间
		carInfo.setT_car_lastupdatetime(currentTime);//最后修改时间
		
		this.mgDao.insert(carInfo);
		
		//给车主增加积分
		StringBuilder sb=new StringBuilder();
		sb.append("update User u  set u.t_user_integral=u.t_user_integral+? where u.t_user_id=?");
		this.mgDao.updateByHql(sb.toString(), Constants.DEFAULT_PUB_C,carDto.getUserid().trim());
		
		//发布成功
		result.setSuccess(true);
		result.setMsg("发布成功");
		return;
	}


	/**
	 * 修改车源
	 */
	@Override
	public void updateCar(CarDto carDto, MgResult result) {
		// TODO Auto-generated method stub
		String t_car_startp=carDto.getStartp().trim();//出发地（省）
		String t_car_startc=StringUtil.nullToStr(carDto.getStartc());//出发地（市）
		String t_car_startd=StringUtil.nullToStr(carDto.getStartd());//出发地（区）
		String t_car_endp=carDto.getEndp().trim();//到达地（省）
		String t_car_endc=StringUtil.nullToStr(carDto.getEndc());//到达地（市）
		String t_car_endd=StringUtil.nullToStr(carDto.getEndd());//到达地（区）
		String t_car_no=StringUtil.nullToStr(carDto.getCarno().trim());//车牌号
		Double t_car_weight=carDto.getWeight();//载重
		Double t_car_length=carDto.getCarlength();//车长
		String t_car_desc=StringUtil.nullToStr(carDto.getDesc());//描述
		String t_car_sendtime=StringUtil.nullToStr(carDto.getSendtime());//发车时间
		String t_car_image1=StringUtil.nullToStr(carDto.getImage1());//车源图片1
		String t_car_image2=StringUtil.nullToStr(carDto.getImage2());//车源图片2
		String t_car_image3=StringUtil.nullToStr(carDto.getImage3());//车源图片3
		String t_remark=StringUtil.nullToStr(carDto.getRemark());//备注说明
		String t_car_contactsname=carDto.getUsername().trim();//联系人名称
		String t_car_contactsphone=carDto.getUserphone().trim();//联系人手机号码
		String t_car_contactstel=StringUtil.nullToStr(carDto.getUsertel());//联系人固话号码
		Double t_car_x=StringUtil.nullToDouble(carDto.getLongitude());//所在经度
		Double t_car_y=StringUtil.nullToDouble(carDto.getLatitude());//所在纬度
		String t_car_xycode="";
		//获取经纬度geohash编码
		if(StringUtil.nullToDouble(carDto.getLongitude())==0 || StringUtil.nullToDouble(carDto.getLatitude())==0){
			t_car_xycode="";
		}else{
			t_car_xycode=GeoHash.withCharacterPrecision(carDto.getLatitude(),carDto.getLongitude(),Constants.DEFAULT_XY_PRECISION).toBase32();
		}
		String t_car_lastupdatetime=DateUtil.getCurrentTime4Str();//最后修改时间
		
		CarInfo carInfo=(CarInfo)this.mgDao.get(CarInfo.class, carDto.getId());
		int isabled=carInfo.getT_car_isabled();
		int status=carInfo.getT_car_status();
		if(isabled==Constants.ABLE_NO){
			result.setSuccess(true);
			result.setMsg("此信息无效");
			return;
		}else if(status==Constants.STATUS_LOCK){
			result.setSuccess(true);
			result.setMsg("此信息正在交易中,不允许修改");
			return;
		}else if(status==Constants.STATUS_DOWN){
			result.setSuccess(true);
			result.setMsg("此信息已下架,不允许修改");
			return;
		}else{
			StringBuilder sb=new StringBuilder();
			sb.append("update CarInfo c set ");
			sb.append(" c.t_car_startp=?,");
			sb.append(" c.t_car_startc=?,");
			sb.append(" c.t_car_startd=?,");
			sb.append(" c.t_car_endp=?,");
			sb.append(" c.t_car_endc=?,");
			sb.append(" c.t_car_endd=?,");
			sb.append(" c.t_car_no=?,");
			sb.append(" c.t_car_weight=?,");
			sb.append(" c.t_car_length=?,");
			sb.append(" c.t_car_desc=?,");
			sb.append(" c.t_car_sendtime=?,");
			sb.append(" c.t_car_image1=?,");
			sb.append(" c.t_car_image2=?,");
			sb.append(" c.t_car_image3=?,");
			sb.append(" c.t_remark=?,");
			sb.append(" c.t_car_contactsname=?,");
			sb.append(" c.t_car_contactsphone=?,");
			sb.append(" c.t_car_contactstel=?,");
			sb.append(" c.t_car_x=?,");
			sb.append(" c.t_car_y=?,");
			sb.append(" c.t_car_xycode=?,");
			sb.append(" c.t_car_lastupdatetime=?");
			sb.append(" where t_car_id=?");
			this.mgDao.updateByHql(sb.toString(), t_car_startp,t_car_startc,t_car_startd,t_car_endp,t_car_endc,t_car_endd,t_car_no,t_car_weight,
					t_car_length,t_car_desc,t_car_sendtime,t_car_image1,t_car_image2,t_car_image3,t_remark,t_car_contactsname,t_car_contactsphone,t_car_contactstel,t_car_x,t_car_y,t_car_xycode,t_car_lastupdatetime,carDto.getId());
			
			//发布成功
			result.setSuccess(true);
			result.setMsg("修改成功");
			return;
		}
	}


	/**
	 * 删除车源
	 */
	@Override
	public void delCar(DelDto delDto, MgResult result) {
		// TODO Auto-generated method stub
		List<String> list=delDto.getId();
		StringBuilder sb=new StringBuilder();
		if(list!=null && list.size()>0){
			sb.append("delete from CarInfo c where c.t_car_id in (");
			for(int i=0,len=list.size();i<len;i++){
				if(i==len-1){
					sb.append("'"+list.get(i)+"'");
				}else{
					sb.append("'"+list.get(i)+"',");
				}
			}
			sb.append(")");
		}
		this.mgDao.updateByHql(sb.toString());
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
		return;
	}


	/**
	 * 删除反馈信息
	 */
	@Override
	public void delFeedback(DelDto delDto, MgResult result) {
		// TODO Auto-generated method stub
		List<String> list=delDto.getId();
		StringBuilder sb=new StringBuilder();
		if(list!=null && list.size()>0){
			sb.append("delete from FeedBack f where f.t_feedback_id in (");
			for(int i=0,len=list.size();i<len;i++){
				if(i==len-1){
					sb.append("'"+list.get(i)+"'");
				}else{
					sb.append("'"+list.get(i)+"',");
				}
			}
			sb.append(")");
		}
		this.mgDao.updateByHql(sb.toString());
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
		return;
	}


	/**
	 * 新增规则组
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void addRGroup(RGroupDto rGroupDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from RGroup r where r.t_rgroup_name=?");
		List<RGroup> list=(List<RGroup>)this.mgDao.findByHql(sb.toString(), rGroupDto.getName());
		if(list!=null && list.size()>0){
			result.setSuccess(false);
			result.setMsg("规则组名称已存在");
			return;
		}
		
		RGroup group=new RGroup();
		group.setT_rgroup_id(UUIDUtil.getUUID());
		group.setT_rgroup_code(StringUtil.nullToStr(rGroupDto.getCode()));
		group.setT_rgroup_name(rGroupDto.getName());
		group.setT_rgroup_desc(StringUtil.nullToStr(rGroupDto.getDesc()));
		group.setT_rgroup_isabled(rGroupDto.getIsabled());
		String currentDate=DateUtil.getCurrentTime4Str();
		group.setT_rgroup_createtime(currentDate);
		group.setT_rgroup_lastupdatetime(currentDate);
		this.mgDao.insert(group);
		
		result.setSuccess(true);
		result.setMsg("新增成功");
		return;
	}


	/**
	 * 查询规则组列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryRGroupList(QryRGroupListDto qryRGroupDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from RGroup r where 1=1");
		if(qryRGroupDto.getName()!=null && !"".equals(qryRGroupDto.getName())){
			sb.append(" and r.t_rgroup_name like '%"+qryRGroupDto.getName()+"%'");
		}
		if(qryRGroupDto.getIsabled()!=null && (qryRGroupDto.getIsabled()==Constants.ABLE_YES || qryRGroupDto.getIsabled()==Constants.ABLE_NO)){
			sb.append(" and r.t_rgroup_isabled="+qryRGroupDto.getIsabled());
		}
		sb.append("order by r.t_rgroup_lastupdatetime desc");
		
		List<RGroup> totalList=(List<RGroup>)this.mgDao.findByHql(sb.toString());
		List<RGroup> list=(List<RGroup>)this.mgDao.findByHql(sb.toString(), (qryRGroupDto.getPage()-1)*qryRGroupDto.getRows(), qryRGroupDto.getRows());
		
		if(totalList!=null && totalList.size()>0){
			result.setTotal(list.size());
		}
		
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("id", list.get(i).getT_rgroup_id());//id
				mapData.put("code", list.get(i).getT_rgroup_code());//code
				mapData.put("name", list.get(i).getT_rgroup_name());//name
				mapData.put("desc", list.get(i).getT_rgroup_desc());//desc
				mapData.put("isabled",list.get(i).getT_rgroup_isabled());//isabled
				mapData.put("createtime", list.get(i).getT_rgroup_createtime());//创建时间
				mapData.put("lastupdatetime", list.get(i).getT_rgroup_lastupdatetime());//最后修改时间
				result.getRows().add(mapData);
			}
		}
		result.setSuccess(true);
		result.setMsg("查询成功");
		
	}


	/**
	 * 修改规则组
	 */
	@Override
	public void updateRGroup(RGroupDto rGroupDto, MgResult result) {
		// TODO Auto-generated method stub
		String id=StringUtil.nullToStr(rGroupDto.getId());//id
		String code=StringUtil.nullToStr(rGroupDto.getCode());//code
		String desc=StringUtil.nullToStr(rGroupDto.getDesc());//desc
		Integer isabled=StringUtil.nullToInteger(rGroupDto.getIsabled());
		String lastupdatetime=DateUtil.getCurrentTime4Str();
		
		//修改user
		StringBuilder sb=new StringBuilder();
		sb.append("update RGroup r set ");
		sb.append(" r.t_rgroup_code=?,");
		sb.append(" r.t_rgroup_desc=?,");
		sb.append(" r.t_rgroup_isabled=?,");
		sb.append(" r.t_rgroup_lastupdatetime=?");
		sb.append(" where r.t_rgroup_id=?");
		this.mgDao.updateByHql(sb.toString(),code,desc,isabled,lastupdatetime,id);
		
		//修改成功
		result.setSuccess(true);
		result.setMsg("修改成功");
		return;
	}


	/**
	 * 删除规则组
	 */
	@Override
	public void delRGroup(DelDto delDto, MgResult result) {
		// TODO Auto-generated method stub
		List<String> list=delDto.getId();
		StringBuilder sb=new StringBuilder();
		if(list!=null && list.size()>0){
			sb.append("delete from RGroup r where r.t_rgroup_id in (");
			for(int i=0,len=list.size();i<len;i++){
				if(i==len-1){
					sb.append("'"+list.get(i)+"'");
				}else{
					sb.append("'"+list.get(i)+"',");
				}
			}
			sb.append(")");
		}
		this.mgDao.updateByHql(sb.toString());
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
		return;
	}


	/**
	 * 查询app
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryAppList(QryAppListDto qryAppListDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from AppInfo");
		
		List<AppInfo> totalList=(List<AppInfo>)this.mgDao.findByHql(sb.toString());
		List<AppInfo> list=(List<AppInfo>)this.mgDao.findByHql(sb.toString(), (qryAppListDto.getPage()-1)*qryAppListDto.getRows(), qryAppListDto.getRows());
		
		if(totalList!=null && totalList.size()>0){
			result.setTotal(list.size());
		}
		
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("id", list.get(i).getT_app_id());//id
				mapData.put("name", list.get(i).getT_app_name());//name
				mapData.put("key", list.get(i).getT_app_key());//key
				mapData.put("version", list.get(i).getT_app_version());//version
				mapData.put("url",list.get(i).getT_app_url());//url
				mapData.put("size",list.get(i).getT_app_size());//size
				mapData.put("desc",list.get(i).getT_app_size());//desc
				mapData.put("createtime", list.get(i).getT_app_createtime());//创建时间
				mapData.put("lastupdatetime", list.get(i).getT_app_lastupdatetime());//最后修改时间
				result.getRows().add(mapData);
			}
		}
		result.setSuccess(true);
		result.setMsg("查询成功");
	}


	/**
	 * 新增App
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void addApp(AppDto appDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from AppInfo a where a.t_app_key=?");
		List<AppInfo> list=(List<AppInfo>)this.mgDao.findByHql(sb.toString(), appDto.getKey());
		if(list!=null && list.size()>0){
			result.setSuccess(false);
			result.setMsg("App key已存在");
			return;
		}
		
		AppInfo app=new AppInfo();
		app.setT_app_id(UUIDUtil.getUUID());
		app.setT_app_name(StringUtil.nullToStr(appDto.getName()));
		app.setT_app_key(appDto.getKey());
		app.setT_app_version(appDto.getVersion());
		app.setT_app_url(appDto.getUrl());
		app.setT_app_size(appDto.getSize());
		app.setT_app_desc(StringUtil.nullToStr(appDto.getDesc()));
		String currentDate=DateUtil.getCurrentTime4Str();
		app.setT_app_createtime(currentDate);
		app.setT_app_lastupdatetime(currentDate);
		this.mgDao.insert(app);
		
		result.setSuccess(true);
		result.setMsg("新增成功");
		return;
	}


	/**
	 * 修改app
	 */
	@Override
	public void updateApp(AppDto appDto, MgResult result) {
		// TODO Auto-generated method stub
		String id=StringUtil.nullToStr(appDto.getId());//id
		String key=StringUtil.nullToStr(appDto.getKey());//key
		String name=StringUtil.nullToStr(appDto.getName());//name
		String version=StringUtil.nullToStr(appDto.getVersion());
		String url=appDto.getUrl();
		Long size=appDto.getSize();
		String desc=StringUtil.nullToStr(appDto.getDesc());
		String lastupdatetime=DateUtil.getCurrentTime4Str();
		
		//修改user
		StringBuilder sb=new StringBuilder();
		sb.append("update AppInfo a set ");
		sb.append(" a.t_app_key=?,");
		sb.append(" a.t_app_name=?,");
		sb.append(" a.t_app_version=?,");
		if(url!=null && !"".equals(url)){
			sb.append(" a.t_app_url='"+appDto.getUrl()+"',");
		}
		if(size!=null && size!=0){
			sb.append(" a.t_app_url="+appDto.getSize()+",");
		}
		sb.append(" a.t_app_desc=?,");
		sb.append(" a.t_app_lastupdatetime=?");
		sb.append(" where a.t_app_id=?");
		this.mgDao.updateByHql(sb.toString(),key,name,version,desc,lastupdatetime,id);
		
		//修改成功
		result.setSuccess(true);
		result.setMsg("修改成功");
		return;
	}


	/**
	 * 删除app
	 */
	@Override
	public void delApp(DelDto delDto,String desdir,MgResult result) {
		// TODO Auto-generated method stub
		List<String> list=delDto.getId();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				AppInfo app=(AppInfo)this.mgDao.get(AppInfo.class, list.get(i));
				String url=app.getT_app_url();
				
				//删除app文件
				if(url!=null && !"".equals(url)){
					File oldfile=new File(desdir+url.substring(url.lastIndexOf("/")));
					//如果存在则删除
					if(oldfile.exists()){
						oldfile.delete();
					}
				}
				//删除数据库信息
				this.mgDao.delete(app);
			}
		}
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
		return;
	}


	/**
	 * 批量导入用户
	 */
	@Override
	public void importUser(List<ExcelUserBean> list,String baseurl,Result result) {
		// TODO Auto-generated method stub
		int num=0;
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				result.clear();
				ExcelUserBean euser=list.get(i);
				String phone=euser.getPhone();
				String name=euser.getName();
				String ent=euser.getEnt();
				String end=euser.getEnd();
				
				//新增用户
				UserDto userDto=new UserDto();
				userDto.setPhone(phone);
				userDto.setPwd(StringUtil.getPwd());//随机密码
				userDto.setType(Constants.USER_CE);
				userDto.setTel("");
				userDto.setName(name);
				userDto.setEnt(ent);
				String currentTime=DateUtil.getCurrentTime4Str();//当前时间
				userDto.setCreatetime(currentTime);
				userDto.setLastupdatetime(currentTime);
				userDto.setInvitecode(StringUtil.getInvitecode());
				userDto.setInvitecodecount(Constants.DEFAULT_INVITECODE_COUNT);
				userDto.setCardurl(baseurl+phone+"_1.jpeg");
				userDto.setBcardurl(baseurl+phone+"_2.jpeg");
				
				this.addUser(userDto, result);
				
				//发布车源信息
				if(result.getSuccess()){
					String userid=result.getData().get("userid").toString();
					
					CarInfo carInfo=new CarInfo();
					String infoid=UUIDUtil.getUUID();
					carInfo.setT_car_id(infoid);//id
					carInfo.setT_car_contactsname(name);//name
					carInfo.setT_car_contactsphone(phone);//phone
					
					User user=new User();
					user.setT_user_id(userid);
					carInfo.setT_car_userid(user);//发布人id
					
					String currentTime1=DateUtil.getCurrentTime4Str();
					carInfo.setT_car_createtime(currentTime1);//发布时间
					carInfo.setT_car_lastupdatetime(currentTime1);//最后修改时间
					carInfo.setT_car_no("");
					carInfo.setT_car_weight(0.0);
					carInfo.setT_car_length(0.0);
					carInfo.setT_car_desc("");
					carInfo.setT_car_sendtime("");
					carInfo.setT_car_image1("");
					carInfo.setT_car_image2("");
					carInfo.setT_car_image3("");
					carInfo.setT_remark("");
					carInfo.setT_car_contactstel("");
					
					List<Wayline> wlList=new ArrayList<Wayline>();
					//线路处理
					if(end!=null && !"".equals(end)){
						String[] ends=end.split("、");
						for(int j=0,count=ends.length;j<count;j++){
							Wayline  wl=new Wayline();
							wl.setId(UUIDUtil.getUUID());
							//wl.setInfoid(infoid);
							wl.setStartp("重庆");
							wl.setStartc("");
							wl.setStartd("");
							String[] pcd=ends[j].split("-");
							switch(pcd.length){
								case 1:{
									wl.setEndp(pcd[0]);
									wl.setEndc("");
									wl.setEndd("");
									break;
								}
								case 2:{
									wl.setEndp(pcd[0]);
									wl.setEndc(pcd[1]);
									wl.setEndd("");
									break;
								}
								case 3:{
									wl.setEndp(pcd[0]);
									wl.setEndc(pcd[1]);
									wl.setEndd(pcd[2]);
									break;
								}
							}
							wlList.add(wl);
						}
					}
					carInfo.setWaylines(wlList);//线路
					
					this.mgDao.insert(carInfo);
					
					//给车主增加积分
					StringBuilder sb=new StringBuilder();
					sb.append("update User u  set u.t_user_integral=u.t_user_integral+? where u.t_user_id=?");
					this.mgDao.updateByHql(sb.toString(), Constants.DEFAULT_PUB_C,userid);
					num++;
				}
			}
		}
		result.setSuccess(true);
		result.setMsg("成功导入"+num+"个用户");
		return;
	}


	/**
	 * 查询app doc 列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryAppdocList(QryAppdocListDto qryAppdocListDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from Doc");
		
		List<Doc> totalList=(List<Doc>)this.mgDao.findByHql(sb.toString());
		List<Doc> list=(List<Doc>)this.mgDao.findByHql(sb.toString(), (qryAppdocListDto.getPage()-1)*qryAppdocListDto.getRows(), qryAppdocListDto.getRows());
		
		if(totalList!=null && totalList.size()>0){
			result.setTotal(list.size());
		}
		
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("id", list.get(i).getT_doc_id());//id
				mapData.put("type", list.get(i).getT_doc_type());//id
				mapData.put("name", list.get(i).getT_doc_name());//id
				mapData.put("title", list.get(i).getT_doc_title());//id
				mapData.put("createtime", list.get(i).getT_doc_createtime());//id
				mapData.put("lastupdatetime", list.get(i).getT_doc_lastupdatetime());//id
				mapData.put("content", list.get(i).getT_doc_content());//id
				result.getRows().add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		return;
	}


	/**
	 * 新增App doc
	 */
	@Override
	public void addAppdoc(AppdocDto appdocDto, MgResult result) {
		// TODO Auto-generated method stub
		Doc doc=new Doc();
		doc.setT_doc_id(UUIDUtil.getUUID());
		doc.setT_doc_type(appdocDto.getType());
		doc.setT_doc_name(StringUtil.nullToStr(appdocDto.getName()));
		doc.setT_doc_title(StringUtil.nullToStr(appdocDto.getTitle()));
		doc.setT_doc_content(appdocDto.getContent());
		String currentTime=DateUtil.getCurrentTime4Str();
		doc.setT_doc_createtime(currentTime);
		doc.setT_doc_lastupdatetime(currentTime);
		this.mgDao.insert(doc);
		
		result.setSuccess(true);
		result.setMsg("新增成功");
		return;
	}


	/**
	 * 修改App doc
	 */
	@Override
	public void updateAppdoc(AppdocDto appdocDto, MgResult result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("update Doc d set d.t_doc_name=?,");
		sb.append("d.t_doc_title=?,");
		sb.append("d.t_doc_content=?,");
		sb.append("d.t_doc_lastupdatetime=?");
		sb.append(" where d.t_doc_id=?");
		this.mgDao.updateByHql(sb.toString(),appdocDto.getName(),appdocDto.getTitle(),appdocDto.getContent(),DateUtil.getCurrentTime4Str(),appdocDto.getId());
	
		result.setSuccess(true);
		result.setMsg("修改成功");
		return;
	}


	/**
	 * 删除 APP doc
	 */
	@Override
	public void delAppdoc(DelDto delDto, MgResult result) {
		// TODO Auto-generated method stub
		List<String> list=delDto.getId();
		StringBuilder sb=new StringBuilder();
		if(list!=null && list.size()>0){
			sb.append("delete from Doc d where d.t_doc_id in (");
			for(int i=0,len=list.size();i<len;i++){
				if(i==len-1){
					sb.append("'"+list.get(i)+"'");
				}else{
					sb.append("'"+list.get(i)+"',");
				}
			}
			sb.append(")");
		}
		this.mgDao.updateByHql(sb.toString());
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
		return;
	}


	/**
	 * 根据rule id查询规则列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Rule> qryRuleList(DelDto delDto) {
		// TODO Auto-generated method stub
		List<String> list=delDto.getId();
		StringBuilder sb=new StringBuilder();
		if(list!=null && list.size()>0){
			sb.append("from Rule r where r.t_rule_id in (");
			for(int i=0,len=list.size();i<len;i++){
				if(i==len-1){
					sb.append("'"+list.get(i)+"'");
				}else{
					sb.append("'"+list.get(i)+"',");
				}
			}
			sb.append(")");
		}
		List<Rule> ruleList=(List<Rule>)this.mgDao.findByHql(sb.toString());
		return ruleList;
	}


	/**
	 * 查询用户详情
	 */
	@Override
	public void qryUserDtl(String userid, String baseurl, Result result) {
		// TODO Auto-generated method stub
		User user=(User)this.mgDao.get(User.class, userid);
		
		//查询成功
		result.setSuccess(true);
		result.setMsg("查询成功");
		if(user!=null){
			result.getData().put("userid", user.getT_user_id());//id
			result.getData().put("username", StringUtil.nullToStr(user.getT_user_name()));//用户名称
			result.getData().put("userent", StringUtil.nullToStr(user.getT_user_ent()));//用户所属企业
			result.getData().put("userphone", user.getT_user_phone());//手机号码
			result.getData().put("usertel", StringUtil.nullToStr(user.getT_user_tel()));//电话号码
			double creditrating=user.getT_user_creditrating();
			int markcount=user.getT_user_markcount();
			if(markcount==0){
				result.getData().put("usercreditrating", 0);//信誉值
			}else{
				result.getData().put("usercreditrating", (int)Math.round(creditrating/markcount));//信誉值
			}
			result.getData().put("userintegral", user.getT_user_integral());//积分值
			result.getData().put("longitude", user.getT_user_x());//经度
			result.getData().put("latitude", user.getT_user_y());//纬度
			result.getData().put("useridcardno", StringUtil.nullToStr(user.getUserExtend().getT_user_idcardno()));//身份证号码
			result.getData().put("usersex", user.getUserExtend().getT_user_sex());//性别
			result.getData().put("userage", user.getUserExtend().getT_user_age());//年龄
			result.getData().put("useraddr", StringUtil.nullToStr(user.getUserExtend().getT_user_addr()));//地址
			result.getData().put("userdesc", StringUtil.nullToStr(user.getUserExtend().getT_user_desc()));//描述
			result.getData().put("useravatar", StringUtil.nullToStr(user.getUserExtend().getT_user_avatar()));//用户头像
			result.getData().put("usercreatetime", user.getT_user_createtime());//创建时间
			result.getData().put("userlastupdatetime", user.getT_user_lastupdatetime());//最后修改时间
			result.getData().put("userdrivingyear", user.getUserExtend().getT_user_drivingyear());//驾龄
			result.getData().put("userfn", StringUtil.nullToStr(user.getUserExtend().getT_user_fn()));//档案号
			result.getData().put("userpolicyno", StringUtil.nullToStr(user.getUserExtend().getT_user_policyno()));//保险单号
			result.getData().put("userhealth", StringUtil.nullToStr(user.getUserExtend().getT_user_health()));//健康状况
			
			String cardurl=StringUtil.nullToStr(user.getUserExtend().getT_user_cardurl());//名片正面图片url
			String bcardurl=StringUtil.nullToStr(user.getUserExtend().getT_user_bcardurl());//名片反面图片url
			String blicenseurl=StringUtil.nullToStr(user.getUserExtend().getT_user_blicenseurl());//营业执照图片url
			String dlicenseurl=StringUtil.nullToStr(user.getUserExtend().getT_user_dlicenseurl());//驾驶证图片url
			String rlicenseurl=StringUtil.nullToStr(user.getUserExtend().getT_user_rlicenseurl());//行驶证图片url
			
			if(cardurl!=null && !"".equals(cardurl)){
				cardurl=baseurl+cardurl;
			}
			if(bcardurl!=null && !"".equals(bcardurl)){
				bcardurl=baseurl+bcardurl;
			}
			if(blicenseurl!=null && !"".equals(blicenseurl)){
				blicenseurl=baseurl+blicenseurl;
			}
			if(dlicenseurl!=null && !"".equals(dlicenseurl)){
				dlicenseurl=baseurl+dlicenseurl;
			}
			if(rlicenseurl!=null && !"".equals(rlicenseurl)){
				rlicenseurl=baseurl+rlicenseurl;
			}
			
			result.getData().put("cardurl", cardurl);//用户名片正面url
			result.getData().put("bcardurl", bcardurl);//用户名片反面url
			result.getData().put("blicenseurl", blicenseurl);//营业执照url
			result.getData().put("dlicenseurl", dlicenseurl);//驾驶证url
			result.getData().put("rlicenseurl", rlicenseurl);//行驶证url
			
			result.getData().put("usertype", StringUtil.nullToInteger(user.getT_user_type()));//用户类型
		}
		return;
	}

}
