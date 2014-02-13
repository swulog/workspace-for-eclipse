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
	<style>
		a{color:#333333; background:none; text-decoration:none; font:12px 宋体;}
		img{ border:none; margin:0px;}
		#outer{border:1px solid #CCCCCC; height:172px; width:585px; background:#990000; position:relative; padding-top:10px; overflow:hidden;}
		#left{width:40px; display:block; float:left; height:162px; position:absolute; left:10px; z-index:2; opacity:0.05; filter:alpha(opacity=5); overflow:hidden;}
		#right{width:40px; display:block; float:left; height:162px; position:absolute; left:535px; z-index:2; overflow:hidden; opacity:0.05; filter:alpha(opacity=5);}
		#demo{overflow: hidden; width:565px;height:162px; float:left; margin:0 10px; position:absolute; z-index:0;}
		.listname{height:156px; display:block; line-height:27px; text-align:center; padding:0 3px; border-left:1px solid #990000; border-right:1px solid #990000;}
		.listimage{width:150px;height:130px;}
	</style>
	<script type="text/javascript" src="<%=basePath%>js/jsor-jcarousel/lib/jquery-1.9.1.min.js"></script>
	<script type="text/javascript">
		
		window.onload = function() {
			function getElement(id) {
				return document.getElementById(id);
			}

			var speed = 30;//滚动速度
			var demo = getElement("demo");
			var demo2 = getElement("demo2");
			var demo1 = getElement("demo1");
			demo2.innerHTML = demo1.innerHTML;//复制demo1中的图片到demo2中

			function Marqueeleft() {//向左滚动
				if (demo2.offsetWidth - demo.scrollLeft <= 0){
					alert(demo2.offsetWidth);
					demo.scrollLeft -= demo1.offsetWidth;
				}
				else
					demo.scrollLeft++;
			}

			function Marqueeright() {//向右滚动
				if (demo2.offsetWidth - demo.scrollLeft >= 565)
					demo.scrollLeft += demo1.offsetWidth;
				else
					demo.scrollLeft--;
			}

			var MyMar = setInterval(Marqueeleft, speed);//自动开始滚动
			Direction = 'Left';//设定初始方向为向左滚
			demo.onmouseover = function() {
				clearInterval(MyMar);
			};
			demo.onmouseout = function() {
				if (Direction == 'Left') {
					MyMar = setInterval(Marqueeleft, speed);
				} else if (Direction == 'Right') {
					MyMar = setInterval(Marqueeright, speed);
				}
			};

			getElement('left').onclick = function() {
				clearInterval(MyMar);
				MyMar = setInterval(Marqueeleft, speed);
				Direction = 'Left';
			};
			getElement('left').onmouseover = function() {
				this.style.opacity = 0.3;
				this.style.filter = 'alpha(opacity=30)';
			};
			getElement('left').onmouseout = function() {
				this.style.opacity = 0.05;
				this.style.filter = 'alpha(opacity=5)';
			};

			getElement('right').onclick = function() {
				clearInterval(MyMar);
				MyMar = setInterval(Marqueeright, speed);
				Direction = 'Right';
			};
			getElement('right').onmouseover = function() {
				this.style.opacity = 0.3;
				this.style.filter = 'alpha(opacity=30)';
			};
			getElement('right').onmouseout = function() {
				this.style.opacity = 0.05;
				this.style.filter = 'alpha(opacity=5)';
			};
		};
	</script>
  </head>




</head>

<body>

<div id="marguee">
<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" hidefocus="" id="left" style="opacity: 0.05;"><img src="./跑马灯效果-jqueryajax教程网_files/Left.png"></a>

<div id="demo">
    <table width="565px" border="0" cellpadding="0" bgcolor="#FFFFFF">
        <tbody><tr>
            <td id="demo1" valign="top">
            	<table border="0" align="center" cellpadding="0" cellspacing="0">
                    <tbody><tr valign="top">
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">

                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮1
                                </a>
                            </div>
                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮2
                                </a>
                            </div>

                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮3
                                </a>
                            </div>
                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">

                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮4
                                </a>
                            </div>
                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">

                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮5
                                </a>
                            </div>
                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮6
                                </a>
                            </div>

                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮7
                                </a>
                            </div>
                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">

                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮8
                                </a>
                            </div>
                        </td>
                    </tr>
                </tbody></table>
            </td>

            <td id="demo2" valign="top">
            	<table border="0" align="center" cellpadding="0" cellspacing="0">
                    <tbody><tr valign="top">
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">

                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮
                                </a>
                            </div>
                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮
                                </a>
                            </div>

                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮
                                </a>
                            </div>
                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">

                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮
                                </a>
                            </div>
                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">

                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮
                                </a>
                            </div>
                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮
                                </a>
                            </div>

                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">
                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮
                                </a>
                            </div>
                        </td>
                        <td align="center" style="border:1px solid #FFFFFF;">

                        	<div>
                            	<a href="./跑马灯效果-jqueryajax教程网_files/跑马灯效果-jqueryajax教程网.htm" class="listname">
                                	<img src="./跑马灯效果-jqueryajax教程网_files/demo_small.jpg" class="listimage">时尚新潮
                                </a>
                            </div>
                        </td>
                    </tr>
                </tbody></table>
            </td>
        </tr>
    </tbody></table>
</div>

</div>

</body></html>