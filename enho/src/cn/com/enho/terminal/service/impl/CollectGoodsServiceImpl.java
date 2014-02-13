package cn.com.enho.terminal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.util.DateUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.comm.util.UUIDUtil;
import cn.com.enho.terminal.dao.CollectGoodsDao;
import cn.com.enho.terminal.dto.QryCollectGoodsListDto;
import cn.com.enho.terminal.entity.GoodsCollect;
import cn.com.enho.terminal.entity.GoodsInfo;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.service.CollectGoodsService;

/**
 * 		货源信息收藏Service实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:58:29
 */
public class CollectGoodsServiceImpl extends BaseServiceImpl implements CollectGoodsService{

	@Autowired
	private CollectGoodsDao collectGoodsDao;
	
	/**
	 * 收藏货源信息
	 */
	@Override
	public void addCollectGoods(String userid, String goodsid, Result result) {
		// TODO Auto-generated method stub
		GoodsCollect goodsCollect=new GoodsCollect();
		goodsCollect.setT_collect_goods_id(UUIDUtil.getUUID());//id
		goodsCollect.setT_collect_goods_createtime(DateUtil.getCurrentTime4Str());//时间
		
		User user=new User();
		user.setT_user_id(userid);
		GoodsInfo goods=new GoodsInfo();
		goods.setT_goods_id(goodsid);
		
		goodsCollect.setUser(user);//用户
		goodsCollect.setGoods(goods);//货源信息
		
		this.collectGoodsDao.insert(goodsCollect);
		
		//收藏成功
		result.setSuccess(true);
		result.setMsg("收藏成功");
		return;
	}

	/**
	 * 查询收藏的货源信息列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryCollectGoodsList(
			QryCollectGoodsListDto qryCollectGoodsListDto, Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from GoodsCollect g where g.user.t_user_id=? order by g.t_collect_goods_createtime desc");
		List<GoodsCollect> list=(List<GoodsCollect>)this.collectGoodsDao.findByHql(sb.toString(), (qryCollectGoodsListDto.getCurrentpage()-1)*qryCollectGoodsListDto.getPagesize(), qryCollectGoodsListDto.getPagesize(), qryCollectGoodsListDto.getUserid());
	
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("user_goods_collectid", list.get(i).getT_collect_goods_id());//id
				mapData.put("userid", list.get(i).getUser().getT_user_id());//用户id
				mapData.put("goodsid", list.get(i).getGoods().getT_goods_id());//货源信息id
				mapData.put("goodsdesc", StringUtil.nullToStr(list.get(i).getGoods().getT_goods_desc()));//货源信息名称
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
	}

	/**
	 * 删除已收藏的货源信息
	 */
	@Override
	public void deleteCollectGoods(String user_goods_collectid, Result result) {
		// TODO Auto-generated method stub
		GoodsCollect goodsCollect=new GoodsCollect();
		goodsCollect.setT_collect_goods_id(user_goods_collectid);
		this.collectGoodsDao.delete(goodsCollect);
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
	}

}
