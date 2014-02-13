<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/adipoli/adipoli.css">
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/marquee-img/marquee-img.css">
	<script type="text/javascript" src="<%=basePath%>js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="<%=basePath%>js/adipoli/jquery.adipoli.js"></script>
	<script type="text/javascript" src="<%=basePath%>js/marquee-img/marquee-img.js"></script>
	<script type="text/javascript">
		/* var MyMar,Direction;
		window.onload = function() {
			function getElement(id) {
				return document.getElementById(id);
			}

			var speed = 30;//滚动速度
			var marquee_div = getElement("marquee_div");
			var marquee_rtd = getElement("marquee_rtd");
			var marquee_ltd = getElement("marquee_ltd");
			marquee_rtd.innerHTML = marquee_ltd.innerHTML;//复制demo1中的图片到demo2中

			function Marqueeleft() {//向左滚动
				if (marquee_rtd.offsetWidth - marquee_div.scrollLeft <= 0){
					marquee_div.scrollLeft -= marquee_ltd.offsetWidth;
				}
				else
					marquee_div.scrollLeft++;
			}

			function Marqueeright() {//向右滚动
				if (marquee_rtd.offsetWidth - marquee_div.scrollLeft >= 565)
					marquee_div.scrollLeft += marquee_ltd.offsetWidth;
				else
					marquee_div.scrollLeft--;
			}

			MyMar = setInterval(Marqueeleft, speed);//自动开始滚动
			Direction = 'Left';//设定初始方向为向左滚
			marquee_div.onmouseover = function() {
				clearInterval(MyMar);
			};
			marquee_div.onmouseout = function() {
				if (Direction == 'Left') {
					MyMar = setInterval(Marqueeleft, speed);
				} else if (Direction == 'Right') {
					MyMar = setInterval(Marqueeright, speed);
				}
			};

			getElement('marquee_lb').onclick = function() {
				clearInterval(MyMar);
				MyMar = setInterval(Marqueeleft, speed);
				Direction = 'Left';
			};
			getElement('marquee_lb').onmouseover = function() {
				this.style.opacity = 0.3;
				this.style.filter = 'alpha(opacity=30)';
			};
			getElement('marquee_lb').onmouseout = function() {
				this.style.opacity = 0.05;
				this.style.filter = 'alpha(opacity=5)';
			};

			getElement('marquee_rb').onclick = function() {
				clearInterval(MyMar);
				MyMar = setInterval(Marqueeright, speed);
				Direction = 'Right';
			};
			getElement('marquee_rb').onmouseover = function() {
				this.style.opacity = 0.3;
				this.style.filter = 'alpha(opacity=30)';
			};
			getElement('marquee_rb').onmouseout = function() {
				this.style.opacity = 0.05;
				this.style.filter = 'alpha(opacity=5)';
			};
		}; */
		
		$(function(){
			Marquee({
				direction:'left',
				speed:30
			});
			
			$("#test").adipoli({
			    'startEffect' : 'normal',
                'hoverEffect' : 'popout'
			});
		});
		
	</script>
</head>

<body>
<div id="marquee_img">
<a href="javascript:void(0);" id="marquee_lb" style="opacity: 0.05;"><img src="<%=basePath%>js/marquee-img/Left.png"></a>
<div id="marquee_div">
    <table width="565px" border="0" cellpadding="0" bgcolor="#FFFFFF">
        <tbody><tr>
            <td id="marquee_ltd" valign="top">
            	<table border="0" align="center" cellpadding="0" cellspacing="0">
                    <tbody><tr valign="top">
                    	<td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="###" class="listname"><img src="images/card/aa.jpg" class="listimage">时尚新潮1</a>
                            </div>
                        </td>
                    	<td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="###" class="listname"><img src="images/card/aa.jpg" class="listimage">时尚新潮2</a>
                            </div>
                        </td>
                    	<td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="###" class="listname"><img src="images/card/aa.jpg" class="listimage">时尚新潮3</a>
                            </div>
                        </td>
                    	<td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="###" class="listname"><img src="images/card/aa.jpg" class="listimage">时尚新潮4</a>
                            </div>
                        </td>
                    	<td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="###" class="listname"><img src="images/card/aa.jpg" class="listimage">时尚新潮5</a>
                            </div>
                        </td>
                    	<td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="###" class="listname"><img src="images/card/aa.jpg" class="listimage">时尚新潮6</a>
                            </div>
                        </td>
                    </tr>
                </tbody></table>
            </td>
            <td id="marquee_rtd" valign="top"></td>
        </tr>
    </tbody></table>
</div>
<a href="javascript:void(0);" id="marquee_rb" style="opacity: 0.05;"><img src="<%=basePath%>js/marquee-img/Right.png"></a>
</div>

<br/>
<br/>
<br/>
<br/>
<div style="margin:0 auto;width:150px;height:130px;">
	<img id="test" alt="" src="images/card/aa.jpg" style="width:150px;height:130px;">
</div>

<!-- <script type="text/javascript" src="http://j.maxmind.com/app/geoip.js"></script>
<script>
var lat = geoip_latitude();
var lon = geoip_longitude();
var region = geoip_region_name();
var country = geoip_country_name();
var city = geoip_city();
alert(lat);
alert(lon);
alert(region);
alert(country);
alert(city);
</script> -->
</body></html>