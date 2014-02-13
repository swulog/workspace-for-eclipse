<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>即时货运部</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="<%=basePath%>/css/main.css"/>
	<script type="text/javascript" src="<%=basePath%>js/jquery-1.7.2.min.js"></script>
  </head>
  
  <body>
	<div class="top_menu_s">
	  <div class="tmss">
	  <div class="about">
	    	<ul>
	        	<li><a href="#">关于我们</a></li>
	            <li><a href="#">帮助中心</a></li>
	            <li><a href="#">意见反馈</a></li>
	        </ul>
	    </div>
	    <div class="reg">
	    	<ul>
	        	<li><img src="images/reg.png" class="reg_ico"><a href="#">登录</a></li>
	            <li><a href="#">快速注册</a></li>
	        </ul>
	    </div>
	  </div>
	</div>
	
	<div class="top_menu_b">
	<div class="menu_logo"><img src="images/logo.png" class="logo">
	<div class="logo_m">
		<ul>
	    	<li><a href="#">首&nbsp;&nbsp;页</a></li>
	        <li><a href="#">货&nbsp;&nbsp;源</a></li>
	        <li><a href="#">车&nbsp;&nbsp;源</a></li>
	        <li><a href="#">我的货运</a></li>
	    </ul>
	</div>
	</div>
	</div>
	
	<div class="top_blank"></div>
	
	<div class="banner_room">
	
	<div class="banner">
	    <div class="banner_left">
	    	<ul>
	        	<li><img src="images/tit.png"></li>
	    	</ul>
	        <ul>
	       	  <li><img src="images/fora.png"></li>
	          <li><img src="images/fori.png"></li>
	        </ul>
	    <ul>
	          <li><img src="images/era.png"></li>
	          <li><img src="images/eri.png"></li>
	        </ul>
	    </div>
	    
	    <div class="banner_right"><img src="images/phone.png"></div>
	</div>
	
	</div>
	
	
	
	
	<div class="room">
		<div class="brom">
	    	<ul>
	        	<li class="brom_left">
	            	<div class="r_one">
	                	<ul>
	                    	<li class="in">货源</li>
	                        <li>车源</li>
	                    </ul>
	                </div>
	                <div class="r_two">
	                	<ul>
	                    	<li>出发地：<select name="" class="t_sel">
	                    	  <option>请选择区域</option>
	                    	</select></li>
	                      <li>到达地：<select name="" class="t_sel">
	                    	  <option>请选择区域</option>
	                   	  </select></li>
	                      <li><input name="" type="button" class="t_btn"></li>
	                  </ul>
	                </div>
	                <div class="r_three">
	                	<ul>
	                    	<li class="th_tit">搜索结果 共<span class="red">75</span>条记录</li>
	                        <li><a href="#">货源：重庆-成都 3米2高栏载重1.365吨</a><span class="tim">2013-10-20</span></li>
	                        <li><a href="#">货源：重庆-成都 3米2高栏载重1.365吨</a><span class="tim">2013-10-20</span></li>
	                        <li><a href="#">货源：重庆-成都 3米2高栏载重1.365吨</a><span class="tim">2013-10-20</span></li>
	                        <li><a href="#">货源：重庆-成都 3米2高栏载重1.365吨</a><span class="tim">2013-10-20</span></li>
	                        <li><a href="#">货源：重庆-成都 3米2高栏载重1.365吨</a><span class="tim">2013-10-20</span></li>
	                        <li><a href="#">货源：重庆-成都 3米2高栏载重1.365吨</a><span class="tim">2013-10-20</span></li>
	                        <li><a href="#">货源：重庆-成都 3米2高栏载重1.365吨</a><span class="tim">2013-10-20</span></li>
	                        <li><a href="#">货源：重庆-成都 3米2高栏载重1.365吨</a><span class="tim">2013-10-20</span></li>
	                  </ul>
	                </div>
	                <div class="r_four"><img src="images/rl_4.jpg"></div>
	          </li>
	            <li class="brom_right">
	            	<div class="r_one"><img src="images/rr_1.jpg"></div>
	                <div class="rr_two">
	                	<ul>
	                    	<li class="rr_tit">最新公告</li>
	                        <li><a href="#">2013年9月20日即时货运部手机客户端上线，货源车源尽在掌控，无论您在哪里，货运部就在您的掌中，随时随地让您在最短的时间......</a></li>
	                    </ul>
	                </div>
	                <div class="rr_three">
	                <p>什么？还在为货物运输，车辆闲置的问题</p>
	                <p>操心？</p>
	                <p>啊？！能随时定位身边的货源、车源！</p>
	                <p>我和我的小伙伴们都惊呆了......</p>
	                <p>还有比“即时货运部”更给力的吗？</p>
	                <p>赶紧猛击体验吧！</p>
	                <p>输入邀请码：111111，更有积分赠送！</p>
	                <p class="btn"><input name="" type="button" class="t_btn2"></p>
	                </div>
	                <div class="r_four"><img src="images/rr_4.jpg"></div>
	            </li>
	            <li> <a href="#"><img src="images/ad.jpg"></a></li>
	        </ul>
	    </div>
	</div>
	
	
	
	
	
	<div class="bottom"></div>
	
	<div class="copy">Copyright ©2013 inginging.com. All rights reserved.</div>
	<!-- Baidu Button BEGIN -->
<script type="text/javascript" id="bdshare_js" data="type=slide&amp;img=2&amp;pos=right&amp;uid=6837142" ></script>
<script type="text/javascript" id="bdshell_js"></script>
<script type="text/javascript">
var bds_config={"bdTop":191};
document.getElementById("bdshell_js").src = "http://bdimg.share.baidu.com/static/js/shell_v2.js?cdnversion=" + Math.ceil(new Date()/3600000);
</script>
<!-- Baidu Button END -->
</body>
</html>
