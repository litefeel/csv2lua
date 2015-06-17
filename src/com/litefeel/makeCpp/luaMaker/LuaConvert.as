package com.litefeel.makeCpp.luaMaker {
	import com.litefeel.utils.StringUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class LuaConvert 
	{
		public static function json2lua(json:String):String
		{
			var obj:Object = JSON.parse(json);
			var arr:Array = [];
			
			obj2lua(obj, arr);
			return arr.join('');
		}
		
		public static function obj2lua(obj:Object, list:Array):void
		{
			var len:int = 0;
			if (obj is Array)
			{
				var arr:Array = obj as Array;
				list.push('{');
				len = arr.length;
				if (len > 0)
				{
					for (var i:int = 0; i < len; i++)
					{
						obj2lua(arr[i], list);
						list.push(',');
					}
					list.pop();
				}
				list.push('}');
			}else if (obj is String)
			{
				list.push('"', obj, '"');
			}else if ((obj is Number) || (obj is Boolean))
			{
				list.push(obj);
			}else
			{
				list.push('{');
				len = list.length;
				for (var k:String in obj)
				{
					list.push('["', k, '"]', '=');
					obj2lua(obj[k], list);
					list.push(',');
				}
				if (list.length > len)
				{
					list.pop();
				}
				list.push('}');
			}
		}
	}

}