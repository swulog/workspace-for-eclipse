package com.ivorytower.comm;

/**
 * 		常量类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-8 下午3:07:23
 */
public class Constants {
	public static final int USER_GE=1;//用户类型：商家（企业货主）
	public static final int USER_GP=4;//用户类型：货主（个人货主）
	public static final int USER_CE=3;//用户类型：货运部（企业车主）
	public static final int USER_CP=2;//用户类型：车主（个人车主）
	
	public static final int USER_ANDROID=1;
	public static final int USER_IOS=2;
	public static final int USER_WEB=3;
	public static final int USER_ADMIN=4;
	
	public static final int INFO_G=1;//信息类型：货源
	public static final int INFO_C=2;//信息类型：车源
	
	public static final int SEX_M=1;//性别男
	public static final int SEX_W=2;//性别女
	
	public static final int STATUS_NORMAL=1;//状态：正常
	public static final int STATUS_LOCK=2;//状态：锁定
	public static final int STATUS_DOWN=3;//状态：下架
	
	public static final int AUDIT_NO=1;//未审核
	public static final int AUDIT_YES=2;//已审核
	
	public static final int ABLE_NO=2;//停用
	public static final int ABLE_YES=1;//启用
	
	public static final int STATUS_ONLINE=1;//在线
	public static final int STATUS_OFFLINE=2;//离线
	
	public static final int DEFAULT_PAGENO=1;//默认页
	public static final int DEFAULT_PAGESIZE=10;//默认记录数
	public static final int PAGING=2;//分页
	public static final int UNPAGING=1;//不分页
	
	
	public static final int DEFAULT_XY_PRECISION=12;//默认geohash编码精度（位数）
	public static final int DEFAULT_MATCH_LEN=2;//默认匹配长度
	
	public static final int IMAGE_TYPE_AVATAR=1;//头像图片
	public static final int IMAGE_TYPE_GOODS=2;//货源图片
	public static final int IMAGE_TYPE_CAR=3;//车源图片
	public static final int IMAGE_TYPE_SHARE=4;//分享图片
	
	public static final int DEFAULT_PUSH_INTERVAL=3;//默认推送间隔：3分钟
	public static final int DEFAULT_CHECK_INTERVAL=13;//默认校验（是否应该下架）间隔：13分钟
	
	public static final int TRADE_FLAG_SUCCESS=1;//交易成功
	public static final int TRADE_FLAG_FAIL=2;//交易失败
	
	public static final int TRADE_TYPE_GC=1;//交易类型：货--车
	public static final int TRADE_TYPE_CG=2;//交易类型：车--货
	
	public static final int QRYMARK_ALL=1;//评分列表查询类型-全部
	public static final int QRYMARK_NOT=2;//评分列表查询类型-未
	public static final int QRYMARK_ALREADY=3;//评分列表查询类型-已
	
	public static final int MARK_NOT=1;//未评分
	public static final int MARK_ALREADY=2;//已评分
	
	public static final int DEFAULT_INVITECODE_COUNT=50;//默认邀请码可用次数
	public static final double DEFAULT_INVITE_G=50.0;//成功邀请货主注册默认得分
	public static final double DEFAULT_INVITE_C=20.0;//成功邀请车主注册默认得分
	public static final double DEFAULT_PUB_G=20;//货主发布货源信息默认得分
	public static final double DEFAULT_PUB_C=10;//车主发布车源信息默认得分
	public static final double DEFAULT_TRADE_GC=20;//货主主动联系车主完成交易货主得分
	public static final double DEFAULT_TRADE_CG=10;//车主主动联系货主完成交易货主得分
	public static final double DEFAULT_MARK_GC=20;//货主给车主评分默认货主得分
	public static final double DEFAULT_STAR_SCORE=2;//默认车主每星代表的积分
	
	public static final String[] imgtypes={"jpg","jpeg","png","gif","bmp"};//支持的图片格式
	
	public static final int APPDOC_TYPE_ABOUTUS=1;//关于我们
	public static final int APPDOC_TYPE_DISC=2;//免责声明
}
