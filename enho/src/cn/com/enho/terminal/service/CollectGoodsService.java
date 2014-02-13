package cn.com.enho.terminal.service;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.QryCollectGoodsListDto;

/**
 * 		货源信息收藏Service接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:57:47
 */
public interface CollectGoodsService extends BaseService{

	public void addCollectGoods(String userid,String goodsid,Result result);
	public void qryCollectGoodsList(QryCollectGoodsListDto qryCollectGoodsListDto,Result result);
	public void deleteCollectGoods(String user_goods_collectid,Result result);
}
