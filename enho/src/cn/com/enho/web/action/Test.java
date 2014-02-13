package cn.com.enho.web.action;




public class Test {

	public static void main(String args[]){
		/*String json="[{'startp':'重庆','startc':'value2','startd':'value3','endp':'value4','endc':'value5','endd':'value6'},{'startp':'value1','startc':'value2','startd':'value3','endp':'value4','endc':'value5','endd':'value6'}]";
		List<Wayline> list=JSONUtil.strToJson(json, Wayline.class);
		
		
		for(int i=0,len=list.size();i<len;i++){
			Wayline wl=list.get(i);
			System.out.println(wl.getStartp());
			System.out.println(wl.getStartc());
			System.out.println(wl.getStartd());
			System.out.println(wl.getEndp());
			System.out.println(wl.getEndc());
			System.out.println(wl.getEndd());
		}*/
		/*List<Map<String,String>> list=new ArrayList<Map<String,String>>();
		Map<String,String> map=new HashMap<String, String>();
		map.put("aa", "dfgdfg");
		list.add(map);
		System.out.println(JsonUtil.jsonList(list));*/
		
		String str="13629790326,13655554444";
		System.out.println(str.matches("^((1(([35][0-9])|(47)|[8][0123456789]))\\d{8})(\\,(1(([35][0-9])|(47)|[8][0123456789]))\\d{8})*$"));
	}
}
