package com.litefeel.makeCpp.parse
{
	import com.litefeel.makeCpp.constant.Pattern;
	import com.litefeel.makeCpp.vo.CppVo;
	import com.litefeel.makeCpp.vo.VarVo;
	import com.litefeel.utils.ArrayUtil;
	import com.litefeel.utils.StringUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class CppParser 
	{
		
		public function CppParser() 
		{
			
		}
		
		public function parse(str:String):CppVo
		{
			var vo:CppVo = new CppVo();
			var list:Array = str.split(/\r\n|\n/);
			var s:String = StringUtil.trim(list[0]);
			var arr:Array = s.split(Pattern.WHITE_SPACE);
			vo.name = StringUtil.trim(arr[0]);
			vo.fileName = arr[1];
			var len:int = list.length;
			for (var i:int = 2; i < len; i++)
			{
				var varVo:VarVo = parseVar(list[i]);
				if (varVo) {
					vo.varList.push(varVo);
					if (varVo.isRepeat && i < len - 1) {
						throw new Error("repeat标志必须在末尾");
					}
				}
			}
			parseGetItemFun(list[1], vo);
			return vo;
		}
		
		private function parseGetItemFun(str:String, vo:CppVo):void 
		{
			str = StringUtil.trim(str);
			var result:Object = /(.+?)\((.*?)\)/.exec(str);
			if (!result) {
				throw new Error("can not parse getItem")
			}
			vo.getItemFun = result[1];
			var args:String = result[2];
			if (!args) {
				vo.setItemFunArgs(null);
			} else {
				vo.setItemFunArgs(args.split(','));
			}
		}
		
		public function parseVar(s:String):VarVo
		{
			var str:String = s.replace(Pattern.COMMENT, "");
			str = StringUtil.trim(str);
			if (!str) return null;
			var list:Array = str.split(/\s+/);
			var len:int = list.length;
			if (len != 2 && len != 4)
			{
				throw new Error("var format error:" + s); 
			}
			if (len == 4 && list[2] != '=') {
				throw new Error("var format error:" + s);
			}
			
			var vo:VarVo = new VarVo();
			var result:Array =  /([\-%*]*)(\S+)/.exec(String(list[0]));
			var addition:String = result[1];
			vo.type = parseVarType(result[2]);
			vo.isDel = addition.indexOf('-') != -1;
			vo.isPercent = addition.indexOf('%') != -1;
			vo.isRepeat = addition.indexOf('*') != -1;
			vo.name = parseVarName(list[1]);
			vo.defaultValue = parseVarValue(list[3], vo);
			return vo;
		}
		
		private function parseVarType(s:String):String
		{
			return s;
		}
		
		private function parseVarName(s:String):String
		{
			return s;
		}
		
		private function parseVarValue(v:String, vo:VarVo):String
		{
			return v;
		}
		
	}

}