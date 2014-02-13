package cn.com.enho.terminal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

import org.springframework.beans.factory.annotation.Autowired;

import ch.hsr.geohash.GeoHash;
import ch.hsr.geohash.WGS84Point;
import ch.hsr.geohash.util.VincentyGeodesy;
import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.DateUtil;
import cn.com.enho.comm.util.SMSUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.comm.util.UUIDUtil;
import cn.com.enho.terminal.dao.UserDao;
import cn.com.enho.terminal.dto.ForgetPwdDto;
import cn.com.enho.terminal.dto.LoginDto;
import cn.com.enho.terminal.dto.QryUserList4NearDto;
import cn.com.enho.terminal.dto.QryUserListDto;
import cn.com.enho.terminal.dto.RegistDto;
import cn.com.enho.terminal.dto.UpdatePwdDto;
import cn.com.enho.terminal.dto.UpdateUserDto;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.entity.UserExtend;
import cn.com.enho.terminal.service.UserService;

/**
 * 		用户信息Service实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-7 下午4:56:05
 */
public class UserServiceImpl extends BaseServiceImpl implements UserService{

	@Autowired
	private UserDao userDao;
	
	//缓存
	@Autowired
	private Cache verificationcodecache;
	@Autowired
	private Cache sessioncache;

	/**
	 * 获取短信验证码
	 */
	@Override
	public boolean getVerificationcode(String username,String password,String smsurl_utf8,String smsurl_gbk, String phoneno,Result result) {
		// TODO Auto-generated method stub
		//产生短信验证码
		String verificationcode=StringUtil.getVerificationcode();
		//String verificationcode="11111";
		String content="尊敬的即时货运用户：您的短信验证码是  "+verificationcode+",有效时间3分钟,请妥善保管【重庆宏程万里科技有限公司】";
		//发送短信验证码
		boolean flag=SMSUtil.sendSMS(username,password,smsurl_utf8,smsurl_gbk,phoneno.trim(),content);
		//String verificationcode="11111";
		//boolean flag=true;
		if(flag){
			//将验证码放入缓存
			Map<Object,Object> map=new HashMap<Object,Object>();
			map.put("verificationcode", verificationcode);
			Element element = new Element(phoneno,map);
			verificationcodecache.put(element);
			result.setSuccess(true);
			result.setMsg("获取短信验证码成功");
			return true;
		}else{
			result.setSuccess(false);
			result.setMsg("获取短信验证码失败");
			return false;
		}
	}
	

	/**
	 * 注册(获取短信验证码)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void getVerificationcode4Regist(String username,String password,String smsurl_utf8,String smsurl_gbk,String phoneno,Result result) {
		// TODO Auto-generated method stub
		
		String hql="from User u where u.t_user_phone=?";
		//查询当前手机号码是否已被注册
		List<User> list=(List<User>)this.userDao.findByHql(hql, phoneno);
		if(list!=null && list.size()>0){
			//注册失败
			result.setSuccess(false);
			result.setMsg("此手机号码已注册");
			return;
		}else{
			boolean flag=getVerificationcode(username,password,smsurl_utf8,smsurl_gbk,phoneno,result);
			if(flag){
				result.setSuccess(true);
				result.setMsg("获取短信验证码成功");
				return;
			}else{
				result.setSuccess(false);
				result.setMsg("获取短信验证码失败");
				return;
			}
			
		}
	}
	
	
	/**
	 * 注册
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void regist(RegistDto registDto,Result result) {
		// TODO Auto-generated method stub
		
		String hql="from User u where u.t_user_phone=?";
		//查询当前手机号码是否已被注册
		List<User> list=(List<User>)this.userDao.findByHql(hql, registDto.getPhoneno().trim());
		if(list!=null && list.size()>0){
			//注册失败
			result.setSuccess(false);
			result.setMsg("此手机号码已注册");
			return;
		}else{
			//从缓存获取短信验证码
			String verificationcode="";
			Element ele=verificationcodecache.get(registDto.getPhoneno().trim());
			if(ele!=null){
				Object obj=ele.getObjectValue();
				if(obj!=null){
					Map<Object,Object> map =(Map<Object,Object>)obj;
					if(map!=null){
						Object obj1=map.get("verificationcode");
						if(obj1!=null){
							verificationcode=(String)obj1;
						}
					}
				}
			}
			//短信验证码已过期
			if(verificationcode==null || "".equals(verificationcode)){
				result.setSuccess(false);
				result.setMsg("短信验证码已过期");
				return;
			}
			//短信验证码校验
			if(registDto.getVerificationcode().trim().equals(verificationcode)){
				//插入注册信息
				User user=new User();
				String uuid=UUIDUtil.getUUID();
				user.setT_user_id(uuid);//id
				user.setT_user_phone(registDto.getPhoneno().trim());//手机号码
				user.setT_user_pwd(registDto.getUserpwd().trim());//密码
				user.setT_user_type(registDto.getUsertype());//用户类型
				String currentTime=DateUtil.getCurrentTime4Str();//当前时间
				user.setT_user_createtime(currentTime);//注册时间
				user.setT_user_lastupdatetime(currentTime);//最后修改时间
				user.setT_user_invitecode(StringUtil.getInvitecode());//邀请码
				user.setT_user_invitecodecount(Constants.DEFAULT_INVITECODE_COUNT);//默认邀请码可用次数
				
				UserExtend userExtend=new UserExtend();
				userExtend.setT_user_id(uuid);
				user.setUserExtend(userExtend);//userextend id
				
				this.userDao.insert(user);
				
				//邀请码处理
				String invitecode=registDto.getInvitecode();
				if(invitecode!=null && !"".equals(invitecode)){
					StringBuilder sb=new StringBuilder();
					sb.append("from User u where u.t_user_invitecode=? and u.t_user_invitecodecount>0 and u.t_user_isabled=?");
					List<User> li=(List<User>)this.userDao.findByHql(sb.toString(), invitecode,Constants.ABLE_YES);
					if(li!=null && li.size()>0){
						for(int i=0,len=li.size();i<len;i++){
							User u=li.get(i);
							if(registDto.getUsertype()==Constants.USER_GE || registDto.getUsertype()==Constants.USER_GP){//如果成功邀请货主注册
								u.setT_user_integral(u.getT_user_integral()+Constants.DEFAULT_INVITE_G);//加积分
							}
							if(registDto.getUsertype()==Constants.USER_CE || registDto.getUsertype()==Constants.USER_CP){//如果成功邀请车主(个人/物流公司)注册
								u.setT_user_integral(u.getT_user_integral()+Constants.DEFAULT_INVITE_C);//加积分
							}
							u.setT_user_invitecodecount(u.getT_user_invitecodecount()-1);//减可用次数
							this.userDao.update(u);
						}
					}
				}
				
				//注册成功
				result.setSuccess(true);
				result.setMsg("注册成功");
				result.getData().put("phoneno", registDto.getPhoneno().trim());
				result.getData().put("userpwd", registDto.getUserpwd().trim());
				return;
			}else{
				result.setSuccess(false);
				result.setMsg("短信验证码校验失败");
				return;
			}
		}
	}
			

	/**
	 * 登陆
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void login(LoginDto loginDto, Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from User u where u.t_user_phone=? and u.t_user_pwd=? and u.t_user_isabled=?");
		List<User> list=(List<User>)this.userDao.findByHql(sb.toString(),loginDto.getPhoneno().trim(),loginDto.getUserpwd().trim(),Constants.ABLE_YES);
		if(list!=null && list.size()==1){
			//修改经纬度
			StringBuilder sb1=new StringBuilder();
			String user_xycode="";
			// 获取经纬度geohash编码
			if (StringUtil.nullToDouble(loginDto.getLongitude()) == 0 || StringUtil.nullToDouble(loginDto.getLatitude()) == 0) {
				user_xycode="";
			} else {
				user_xycode=GeoHash.withCharacterPrecision(loginDto.getLatitude(), loginDto.getLongitude(),
						Constants.DEFAULT_XY_PRECISION).toBase32();
			}
			sb1.append("update User u set u.t_user_x=?,u.t_user_y=?,u.t_user_xycode=? where u.t_user_id=?");
			this.userDao.updateByHql(sb1.toString(), loginDto.getLongitude(),loginDto.getLatitude(),user_xycode,list.get(0).getT_user_id());
			
			//将表示session的唯一序列号放入缓存(userid为key)
			String uuid=UUIDUtil.getUUID();
			Element element = new Element(list.get(0).getT_user_id(),uuid);
			sessioncache.put(element);
			
			result.setSuccess(true);
			result.setMsg("登录成功");
			
			String baseurl=loginDto.getBaseurl()==null?"":loginDto.getBaseurl().toString();
			
			result.getData().put("userid", list.get(0).getT_user_id());
			result.getData().put("usertype", list.get(0).getT_user_type());
			result.getData().put("username", StringUtil.nullToStr(list.get(0).getT_user_name()));
			result.getData().put("userphone", list.get(0).getT_user_phone());
			result.getData().put("usertel", StringUtil.nullToStr(list.get(0).getT_user_tel()));
			result.getData().put("invitecode", list.get(0).getT_user_invitecode());//邀请码
			result.getData().put("uuid", uuid);
			
			String cardurl=list.get(0).getUserExtend().getT_user_cardurl();
			String bcardurl=list.get(0).getUserExtend().getT_user_bcardurl();
			String blicenseurl=list.get(0).getUserExtend().getT_user_blicenseurl();
			String dlicenseurl=list.get(0).getUserExtend().getT_user_dlicenseurl();
			String rlicenseurl=list.get(0).getUserExtend().getT_user_rlicenseurl();
			
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
			
			result.getData().put("cardurl", cardurl);
			result.getData().put("bcardurl", bcardurl);
			result.getData().put("blicenseurl", blicenseurl);
			result.getData().put("dlicenseurl", dlicenseurl);
			result.getData().put("rlicenseurl", rlicenseurl);
			
			return;
		}else{
			result.setSuccess(false);
			result.setMsg("登录失败");
			return;
		}
	}

	/**
	 * 找回密码(获取短信验证码)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void getVerificationcode4Pwd(String username,String password,String smsurl_utf8,String smsurl_gbk,String phoneno,Result result) {
		// TODO Auto-generated method stub
		
		String hql="from User u where u.t_user_phone=? and u.t_user_isabled=?";
		//查询当前手机号码是否注册
		List<User> list=(List<User>)this.userDao.findByHql(hql, phoneno,Constants.ABLE_YES);
		if(list!=null && list.size()==1){
			//已注册手机
			boolean flag=getVerificationcode(username,password,smsurl_utf8,smsurl_gbk,phoneno,result);
			if(flag){
				result.setSuccess(true);
				result.setMsg("获取短信验证码成功");
				return;
			}else{
				result.setSuccess(false);
				result.setMsg("获取短信验证码失败");
				return;
			}
		}else{
			result.setSuccess(false);
			result.setMsg("此手机还未注册");
			return;
		}
	}
	
	/**
	 * 找回密码
	 * @param phoneno
	 * @param code
	 * @param result
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void forgetPwd(ForgetPwdDto forgetPwdDto,Result result){
		//从缓存获取短信验证码
		String verificationcodeIncache="";
		Element ele=verificationcodecache.get(forgetPwdDto.getPhoneno().trim());
		if(ele!=null){
			Object obj=ele.getObjectValue();
			if(obj!=null){
				Map<Object,Object> map =(Map<Object,Object>)obj;
				if(map!=null){
					Object obj1=map.get("verificationcode");
					if(obj1!=null){
						verificationcodeIncache=(String)obj1;
					}
				}
			}
		}
		//短信验证码过期
		if(verificationcodeIncache==null || "".equals(verificationcodeIncache)){
			result.setSuccess(false);
			result.setMsg("短信验证码已过期");
			return;
		}
		
		//短信验证码校验
		if(verificationcodeIncache.equals(forgetPwdDto.getVerificationcode().trim())){
			StringBuilder sb=new StringBuilder();
			sb.append("from User u where u.t_user_phone=? and u.t_user_isabled=?");
			List<User> list=(List<User>)this.userDao.findByHql(sb.toString(), forgetPwdDto.getPhoneno().trim(),Constants.ABLE_YES);
			if(list!=null && list.size()==1){
				//boolean flag=SMSUtil.sendSMS(username,password,smsurl,phoneno.trim(),"尊敬的用户，您的密码是："+list.get(0).getT_user_pwd()+",请妥善保存");
				User user=list.get(0);
				user.setT_user_pwd(forgetPwdDto.getNewpwd().trim());
				this.userDao.update(user);
				
				result.setSuccess(true);
				result.setMsg("密码找回成功");
				return;
			}else{
				result.setSuccess(false);
				result.setMsg("密码找回失败");
				return;
			}
		}else{
			result.setSuccess(false);
			result.setMsg("短信验证码校验失败");
			return;
		}
	}
	
	/**
	 * 查询用户列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryUserList(QryUserListDto qryUserListDto, Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from User u where 1=1 ");
		
		//用户类型
		Integer usertype=qryUserListDto.getUsertype();
		if(usertype!=null && (usertype==Constants.USER_GE || usertype==Constants.USER_GP || usertype==Constants.USER_CE || usertype==Constants.USER_CP)){
			sb.append(" and u.t_user_type="+usertype);
		}
		//是否启用
		Integer isabled=qryUserListDto.getIsabled();
		if(isabled!=null && (isabled==Constants.ABLE_YES || isabled==Constants.ABLE_NO)){
			sb.append(" and u.t_user_isabled="+isabled);
		}
		
		//用户来源
		Integer usersrc=qryUserListDto.getUsersrc();
		if(usersrc!=null && (usersrc==Constants.USER_ANDROID || usersrc==Constants.USER_IOS || usersrc==Constants.USER_WEB || usersrc==Constants.USER_ADMIN)){
			sb.append(" and u.t_user_src="+usersrc);
		}
		
		sb.append(" order by u.t_user_lastupdatetime desc");
		
		List<User> list=(List<User>)this.userDao.findByHql(sb.toString(), (qryUserListDto.getCurrentpage()-1)*qryUserListDto.getPagesize(), qryUserListDto.getPagesize());
	
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("userid", list.get(i).getT_user_id());//id
				mapData.put("userphone", list.get(i).getT_user_phone());//手机号码
				mapData.put("username", list.get(i).getT_user_name());//用户名称
				mapData.put("userent", list.get(i).getT_user_ent());//用户所属企业
				mapData.put("usertel", list.get(i).getT_user_tel());//电话号码
				mapData.put("usercreditrating", list.get(i).getT_user_creditrating());//信誉值
				mapData.put("usercreatetime", list.get(i).getT_user_createtime());//创建时间
				mapData.put("userlastupdatetime", list.get(i).getT_user_lastupdatetime());//最后修改时间
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
	}
	
	/**
	 * 查询后台手动添加的用户列表（车主）
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<User> qryCUserList4Admin(boolean flag) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from User u where 1=1 ");
		
		//用户类型
		sb.append(" and (u.t_user_type="+Constants.USER_CE+" || u.t_user_type="+Constants.USER_CP+")");
		//是否启用
		sb.append(" and u.t_user_isabled="+Constants.ABLE_YES);
		
		//用户来源
		if(flag){
			sb.append(" and u.t_user_src="+Constants.USER_ADMIN);
		}else{
			sb.append(" and u.t_user_src != "+Constants.USER_ADMIN);
		}
		
		sb.append(" order by u.t_user_lastupdatetime desc");
		
		List<User> list=(List<User>)this.userDao.findByHql(sb.toString());
	
		return list;
	}
	
	
	/**
	 * 查询附近的用户列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryUserList4Near(
			QryUserList4NearDto qryUserList4NearDto, Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		List<User> list=null;
		
		//获取当前经纬度的geohash编码
		GeoHash geoHash=GeoHash.withCharacterPrecision(qryUserList4NearDto.getLatitude(),qryUserList4NearDto.getLongitude(),Constants.DEFAULT_XY_PRECISION);
		
		//获取当前坐标块周围8个块的geohash编码
		GeoHash[] geoHashs=geoHash.getAdjacent();
		
		sb.append("from User u where 1=1 and u.t_user_type=? and u.t_user_isabled=? and (");
		for(int i=0,len=geoHashs.length;i<len;i++){
			String geoHashStr=geoHashs[i].toBase32();
			if(i==len-1){
				sb.append("u.t_user_xycode like '"+geoHashStr.substring(0,Constants.DEFAULT_MATCH_LEN)+"%'");
			}else{
				sb.append("u.t_user_xycode like '"+geoHashStr.substring(0,Constants.DEFAULT_MATCH_LEN)+"%' or ");
			}
		}
		sb.append(" or u.t_user_xycode like '"+geoHash.toBase32().substring(0,Constants.DEFAULT_MATCH_LEN)+"%')");
		sb.append(" order by u.t_user_lastupdatetime desc");
		
		if(qryUserList4NearDto.getFlag()==null || qryUserList4NearDto.getFlag()==2){//分页
			list=(List<User>)this.userDao.findByHql(sb.toString(), (qryUserList4NearDto.getCurrentpage()-1)*qryUserList4NearDto.getPagesize(), qryUserList4NearDto.getPagesize(),qryUserList4NearDto.getUsertype(),Constants.ABLE_YES);
		}else{//不分页
			list=(List<User>)this.userDao.findByHql(sb.toString(),qryUserList4NearDto.getUsertype(),Constants.ABLE_YES);
		}
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("userid", list.get(i).getT_user_id());//id
				mapData.put("username", StringUtil.nullToStr(list.get(i).getT_user_name()));//名称
				mapData.put("userent", StringUtil.nullToStr(list.get(i).getT_user_ent()));//用户所属企业
				mapData.put("userphone", list.get(i).getT_user_phone());//手机号码
				mapData.put("usertel", StringUtil.nullToStr(list.get(i).getT_user_tel()));//电话号码
				mapData.put("usercreditrating", list.get(i).getT_user_creditrating());//信誉值
				mapData.put("usercreatetime", list.get(i).getT_user_createtime());//创建时间
				mapData.put("userlastupdatetime", list.get(i).getT_user_lastupdatetime());//最后修改时间
				
				Double latitude=list.get(i).getT_user_y();//纬度
				Double longitude=list.get(i).getT_user_x();//经度
				//计算距离
				Double distance=VincentyGeodesy.distanceInMeters(new WGS84Point(qryUserList4NearDto.getLatitude(),qryUserList4NearDto.getLongitude()),new WGS84Point(latitude,longitude));
				
				mapData.put("longitude", longitude);//经度
				mapData.put("latitude", latitude);//纬度
				mapData.put("userdistance", distance);//距离
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
	}

	/**
	 * 查询用户详情
	 */
	@Override
	public void qryUserDtl(String userid,String baseurl,Result result) {
		// TODO Auto-generated method stub
		User user=(User)this.userDao.get(User.class, userid);
		
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

	/**
	 * 修改用户信息
	 */
	@Override
	public void updateUser(UpdateUserDto updateUserDto,Result result) {
		// TODO Auto-generated method stub
		String userphone=StringUtil.nullToStr(updateUserDto.getUserphone());//手机号码
		//String usertel=StringUtil.nullToStr(updateUserDto.getUsertel());//固话号码
		String username=StringUtil.nullToStr(updateUserDto.getUsername());//用户名称
		String userent=StringUtil.nullToStr(updateUserDto.getUserent());//用户所属企业
		
		//Double userx=StringUtil.nullToDouble(updateUserDto.getUserx());//经度
		//Double usery=StringUtil.nullToDouble(updateUserDto.getUsery());//纬度
		//String userxycode="";
		// 获取经纬度geohash编码
		/*if (StringUtil.nullToDouble(updateUserDto.getUserx()) == 0 || StringUtil.nullToDouble(updateUserDto.getUsery()) == 0) {
			userxycode="";
		} else {
			userxycode=GeoHash.withCharacterPrecision(updateUserDto.getUsery(), updateUserDto.getUserx(),Constants.DEFAULT_XY_PRECISION).toBase32();
		}*/
		
		//String useridcardno=StringUtil.nullToStr(updateUserDto.getUseridcardno());//身份证号
		//Integer usersex=Constants.SEX_M;
		/*if(updateUserDto.getUsersex()==Constants.SEX_M || updateUserDto.getUsersex()==Constants.SEX_W){//性别
			usersex=updateUserDto.getUsersex();
		}*/
		//Integer userage=StringUtil.nullToInteger(updateUserDto.getUserage());//年龄
		//String useraddr=StringUtil.nullToStr(updateUserDto.getUseraddr());//地址
		//String userdesc=StringUtil.nullToStr(updateUserDto.getUserdesc());//描述
		//String useravatar=StringUtil.nullToStr(updateUserDto.getUseravatar());//头像
		//Integer userdrivingyear=StringUtil.nullToInteger(updateUserDto.getUserdrivingyear());//驾龄
		//String userfn=StringUtil.nullToStr(updateUserDto.getUserfn());//档案号
		//String userpolicyno=StringUtil.nullToStr(updateUserDto.getUserpolicyno());//保险号
		//String userhealth=StringUtil.nullToStr(updateUserDto.getUserhealth());//健康状况
		String userlastupdatetime=DateUtil.getCurrentTime4Str();//最后修改时间
		
		String cardurl=StringUtil.nullToStr(updateUserDto.getCardurl());//名片正面图片url
		String bcardurl=StringUtil.nullToStr(updateUserDto.getBcardurl());//名片反面图片url
		String blicenseurl=StringUtil.nullToStr(updateUserDto.getBlicenseurl());//营业执照图片url
		String dlicenseurl=StringUtil.nullToStr(updateUserDto.getDlicenseurl());//驾驶证图片url
		String rlicenseurl=StringUtil.nullToStr(updateUserDto.getRlicenseurl());//行驶证图片url
		
		//修改user
		StringBuilder sb1=new StringBuilder();
		sb1.append("update User u set ");
		//sb1.append(" u.t_user_phone=?,");
		//sb1.append(" u.t_user_tel=?,");
		sb1.append(" u.t_user_name=?,");
		sb1.append(" u.t_user_ent=?,");
		//sb1.append(" u.t_user_x=?,");
		//sb1.append(" u.t_user_y=?,");
		//sb1.append(" u.t_user_xycode=?,");
		sb1.append(" u.t_user_lastupdatetime=?");
		sb1.append(" where u.t_user_id=?");
		this.userDao.updateByHql(sb1.toString(),username,userent,userlastupdatetime,updateUserDto.getUserid());
		
		//修改userextend
		//如果修改了图片
		if(!"2".equals(cardurl) || !"2".equals(bcardurl) || !"2".equals(blicenseurl) || !"2".equals(dlicenseurl) || !"2".equals(rlicenseurl)){
			UserExtend ue=(UserExtend)this.userDao.get(UserExtend.class,updateUserDto.getUserid());
			if(!"2".equals(cardurl)){
				ue.setT_user_cardurl(cardurl);
			}
			if(!"2".equals(bcardurl)){
				ue.setT_user_bcardurl(bcardurl);
			}
			if(!"2".equals(blicenseurl)){
				ue.setT_user_blicenseurl(blicenseurl);
			}
			if(!"2".equals(dlicenseurl)){
				ue.setT_user_dlicenseurl(dlicenseurl);
			}
			if(!"2".equals(rlicenseurl)){
				ue.setT_user_rlicenseurl(rlicenseurl);
			}
			this.userDao.update(ue);
		}
		
		//sb2.append(" u.t_user_sex=?,");
		//sb2.append(" u.t_user_lastupdatetime=?,");
		//sb2.append(" u.t_user_age=?,");
		//sb2.append(" u.t_user_idcardno=?,");
		//sb2.append(" u.t_user_addr=?,");
		//sb2.append(" u.t_user_desc=?,");
		//sb2.append(" u.t_user_avatar=?,");
		//sb2.append(" u.t_user_drivingyear=?,");
		//sb2.append(" u.t_user_fn=?,");
		//sb2.append(" u.t_user_policyno=?,");
		
		
		//修改成功
		result.setSuccess(true);
		result.setMsg("修改成功");
		
		User user=(User)this.userDao.get(User.class,updateUserDto.getUserid());
		
		result.getData().put("userid",updateUserDto.getUserid());
		//result.getData().put("usertype",updateUserDto.getUserid());
		result.getData().put("username",username);
		result.getData().put("userphone",userphone);
		//result.getData().put("usertel",usertel);
		result.getData().put("cardurl",user.getUserExtend().getT_user_cardurl());
		result.getData().put("bcardurl",user.getUserExtend().getT_user_bcardurl());
		result.getData().put("blicenseurl",user.getUserExtend().getT_user_blicenseurl());
		result.getData().put("dlicenseurl",user.getUserExtend().getT_user_dlicenseurl());
		result.getData().put("rlicenseurl",user.getUserExtend().getT_user_rlicenseurl());
		return;
	}


	/**
	 * 修改密码
	 */
	@Override
	public void updatePwd(UpdatePwdDto updatePwdDto, Result result) {
		// TODO Auto-generated method stub
		User user=(User)this.userDao.get(User.class, updatePwdDto.getUserid());
		if(!user.getT_user_pwd().equals(updatePwdDto.getUseroldpwd())){
			result.setSuccess(false);
			result.setMsg("旧密码不正确");
			return;
		}else{
			user.setT_user_pwd(updatePwdDto.getUsernewpwd());
			this.userDao.update(user);
			result.setSuccess(true);
			result.setMsg("修改成功");
			return;
		}
		
	}
	
}
