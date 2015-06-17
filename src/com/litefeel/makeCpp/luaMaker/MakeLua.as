package com.litefeel.makeCpp.luaMaker {
	import com.litefeel.makeCpp.luaMaker.LuaDefaultType;
	import com.litefeel.makeCpp.utils.TypeUtil;
	import com.litefeel.makeCpp.vo.CppVo;
	import com.litefeel.makeCpp.vo.VarVo;
	import com.litefeel.Running;
	import com.litefeel.utils.FileUtil;
	import com.litefeel.utils.StringUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class MakeLua 
	{
		
		public static const LUA_FILE_HEAD:String = 'return {\n';
		public static const SCOPE_END:String = '}';
		public static const LUA_TABLE_ONE:String = '{0}={1},';
		public static const LUA_HASH_TABLE_HEAD:String = '["{0}"]={';
		public static const LUA_LIST_TABLE_HEAD:String = '{';
		static public var showMsg:Function;
		
		private var list:Vector.<CppVo>;
		private var luaPath:String;
		private var csvPath:String;
		
		public function MakeLua(list:Vector.<CppVo>, luaPath:String, csvPath:String) 
		{
			this.list = list;
			this.luaPath = luaPath;
			this.csvPath = csvPath;
		}
		
		public function doMake():void 
		{
			var loadList:Array = [];
			for each(var vo:CppVo in list)
			{
				if(vo.fileName)
				{
					Running.curCsvName = vo.fileName;
					var path:String = csvPath + vo.fileName;
					var data:String = FileUtil.readString(path, "gb2312");
					if (data == null)
					{
						showMsg("缺少文件：" + path);
						continue;
					}
					var arr:Array = CSV.decode(data);
					FileUtil.writeString(makeLuaFile(vo, arr), luaPath + vo.name+"_Data.lua");
					FileUtil.writeString(LuaStaticDataMaker.doMake(list), luaPath + "StaticData.lua");
				}
			}
		}
		
		private function makeLuaFile(vo:CppVo, arr:Array):String 
		{
			var outArr:Array = [LUA_FILE_HEAD];
			var len:int = arr.length;
			for (var i:int = 8; i < len; i++)
			{
				Running.curCsvRowIdx = i;
				makeLuaOneLine(outArr, arr[i], vo);
			}
			Running.curCsvRowIdx = -1;
			
			outArr.push(SCOPE_END);
			return outArr.join('');
		}
		
		private function makeLuaOneLine(outArr:Array, csvline:Array, vo:CppVo):void 
		{
			if (!csvline[0]) return;
			
			var luaValue:String = null;
			if (vo.isMap)
			{
				var key:String = getMapKey(vo, csvline);
				outArr.push(StringUtil.substitute(LUA_HASH_TABLE_HEAD, key));
			}else
			{
				outArr.push(LUA_LIST_TABLE_HEAD);
			}
			
			var len:int = vo.varList.length;
			for (var i:int = 0; i < len; i++)
			{
				if (vo.varList[i].isDel) continue;
				Running.curCsvColIdx = i;
				if (vo.varList[i].isRepeat)
				{
					luaValue = toluaRepeatValue(vo.varList[i].type, csvline, vo.varList[i], i);
					outArr.push(StringUtil.substitute(LUA_TABLE_ONE, vo.varList[i].name, luaValue));
					break;
				} else
				{
					luaValue = toluaValue(vo.varList[i].type, csvline[i], vo.varList[i]);
					outArr.push(StringUtil.substitute(LUA_TABLE_ONE, vo.varList[i].name, luaValue));
				}
			}
			outArr.push(SCOPE_END);
			outArr.push(',\n');
		}
		
		private function getMapKey(vo:CppVo, csvline:Array):String 
		{
			if (1 == vo.getItemFunArgs.length)
			{
				return csvline[vo.getItemFunArgsAt[0]];
			}
			var arr:Array = [];
			for (var i:int = 0; i < vo.getItemFunArgsAt.length; i++)
			{
				arr.push(csvline[vo.getItemFunArgsAt[i]]);
			}
			return arr.join('_');
		}
		
		private function toluaRepeatValue(type:String, valueList:Array, addition:VarVo, idx:int):String 
		{
			var len:int = valueList.length;
			if (0 == len) return '{}';
			
			var arr:Array = [];
			for (var i:int = idx; i < len; i++)
			{
				if (valueList[i])
				{
					arr.push(toluaValue(type, valueList[i], addition));
				}
			}
			return '{' + arr.join(',') + '}';
		}
		private function toluaValue(type:String, value:String, addition:VarVo):String 
		{
			if (!value && addition.defaultValue)
			{
				value = addition.defaultValue;
			}
			if (!value && LuaDefaultType.hasDefalutType(type))
			{
				return LuaDefaultType.getDefaultValue(type);
			}
			if("string" == type)
			{
				return '"' + value + '"';
			}else if ("lstring" == type)
			{
				return '[[' + value + ']]';
			}
			
			if ("bool" == type)
			{
				var bool:Boolean = value == "1" || value == "true";
				return bool ? "true" : "false";
			}
			if (TypeUtil.isVector(type))
			{
				type = TypeUtil.getElemType(type);
				return toluaArray(type, value, addition);
			}
			if ("json" == type)
			{
				return LuaConvert.json2lua(value);
			}
			if (addition.isPercent)
			{
				var num:Number = parseFloat(value);
				if (value != num.toString()) throw new Error("value not is percent");
				value = (num * 0.01).toString();
			}
			
			return value;
		}
		
		private function toluaArray(elemType:String, str:String, addition:VarVo):String 
		{
			if ('' == str) return '{}';
			
			var arr:Array = str.split('|');
			for (var i:int = arr.length - 1; i >= 0; i--)
			{
				arr[i] = toluaValue(elemType, arr[i], addition);
			}
			return '{' + arr.join(',') + '}';
		}
		
	}

}