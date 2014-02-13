function Marquee(cfg){
			_self=this;
			var speed = cfg.speed;//滚动速度
			var direction = cfg.direction;//滚动方向
			var obj;
			
			this.marquee_div = $("#marquee_div");
			this.marquee_rtd = $("#marquee_rtd");
			this.marquee_ltd = $("#marquee_ltd");
			this.marquee_lb=$("#marquee_lb");
			this.marquee_rb=$("#marquee_rb");
			this.marquee_rtd.html(marquee_ltd.html());//复制demo1中的图片到demo2中

			this.Marqueeleft=function() {//向左滚动
				if (_self.marquee_rtd[0].offsetWidth - _self.marquee_div[0].scrollLeft <= 0){
					_self.marquee_div[0].scrollLeft -= _self.marquee_ltd[0].offsetWidth;
				}
				else
					_self.marquee_div[0].scrollLeft++;
			};

			this.Marqueeright=function() {//向右滚动
				if (_self.marquee_rtd[0].offsetWidth - _self.marquee_div[0].scrollLeft >= 565)
					_self.marquee_div[0].scrollLeft += _self.marquee_ltd[0].offsetWidth;
				else
					_self.marquee_div[0].scrollLeft--;
			};

			obj = setInterval(_self.Marqueeleft, speed);//自动开始滚动
			
			this.marquee_div.mouseover(function(){
				clearInterval(obj);
			});
			this.marquee_div.mouseout(function(){
				if (direction == 'left') {
					obj = setInterval(_self.Marqueeleft, speed);
				} else if (direction == 'right') {
					obj = setInterval(_self.Marqueeright, speed);
				}
			});
			
			this.marquee_lb.click(function() {
				clearInterval(obj);
				direction = 'left';
				obj = setInterval(_self.Marqueeleft, speed);
			});
			this.marquee_lb.mouseover(function() {
				$(this).css("opacity",0.3);
				$(this).css('filter','alpha(opacity=30)');
			});
			this.marquee_lb.mouseout(function() {
				$(this).css("opacity",0.05);
				$(this).css('filter','alpha(opacity=5)');
			});
			
			this.marquee_rb.click(function() {
				clearInterval(obj);
				direction = 'right';
				obj = setInterval(_self.Marqueeright, speed);
			});
			this.marquee_rb.mouseover(function() {
				$(this).css("opacity",0.3);
				$(this).css("filter",'alpha(opacity=30)');
			});
			this.marquee_rb.mouseout(function() {
				$(this).css("opacity",0.05);
				$(this).css("filter",'alpha(opacity=5)');
			});
			
}
		
		
