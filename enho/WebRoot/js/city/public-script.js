function pcdinit(province,city,district,defaultP,defaultC,defaultD) { 
	var province = $("#"+province); 
	var city = $("#"+city); 
	var district = $("#"+district); 
	var jsonProvince = "js/city/json-array-of-province.js"; 
	var jsonCity = "js/city/json-array-of-city.js"; 
	var jsonDistrict = "js/city/json-array-of-district.js"; 
	var initProvince = "<option value=''>请选择省份</option>"; 
	var initCity = "<option value=''>请选择城市</option>"; 
	var initDistrict = "<option value=''>请选择区县</option>"; 
	_LoadOptions(jsonProvince, province, null, 0, initProvince,defaultP); 
	province.change(function () { 
		_LoadOptions(jsonCity, city, province, 2, initCity,defaultC); 
	}); 
		//if (hasDistrict) { 
	city.change(function () { 
		_LoadOptions(jsonDistrict, district, city, 4, initDistrict,defaultD); 
	}); 
		/*province.change(function () { 
			city.change(); 
		}); */
}; 

function _LoadOptions(datapath,targetobj, parentobj, comparelen, initoption,defaultPCD) { 
	$.get(datapath,function (r) { 
						r=$.parseJSON(r);
						var t = ""; // t: html容器 
						if(comparelen==0){
							for (var i = 0; i < r.length; i++) {
								t += "<option name='"+r[i].name+"' value='" + r[i].code + "'>" + r[i].name + "</option>"; 
							}
						}else{
							var p = parentobj.val();
							for (var i = 0; i < r.length; i++) {
								if (p.substring(0, comparelen) === r[i].code.substring(0, comparelen)) { 
									t += "<option name='"+r[i].name+"' value='" + r[i].code + "'>" + r[i].name + "</option>";  
								}  
							}
						}
						if (initoption !== "") { 
							targetobj.html(initoption + t); 
						} else { 
							targetobj.html(t); 
						} 
						if(defaultPCD!=null && defaultPCD!="" && defaultPCD && defaultPCD!=undefined && defaultPCD!="undefined"){
							targetobj.find("option[name='"+defaultPCD+"']").attr("selected",true);
							targetobj.change();
						}
					}
	);
}
