package com.litefeel.makeCpp.luaMaker {
	/**
	 * ...
	 * @author lite3
	 */
	public class LuaDefaultType 
	{
		public static const DEFAULT_TYPE_MAP:Object = {
			"int":"0",
			"float":"0",
			"string":'""',
			"lstring":'""',
			"bool":"false",
			"json":"{}"
		}
		
		public static const JSON_ARRAY:String = "jsonarray";
		
		public static function getDefaultValue(type:String):String 
		{
			return DEFAULT_TYPE_MAP[type];
		}
		
		public static function hasDefalutType(type:String):Boolean
		{
			return DEFAULT_TYPE_MAP[type] != null;
		}
		
	}

}