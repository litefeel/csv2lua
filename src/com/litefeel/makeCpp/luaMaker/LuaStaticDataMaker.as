package com.litefeel.makeCpp.luaMaker {
	import com.litefeel.makeCpp.vo.CppVo;
	import com.litefeel.utils.StringUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class LuaStaticDataMaker 
	{
static private const HEAD:String = 
'local CURRENT_PACKAGE = ...\n' +
'CURRENT_PACKAGE = string.sub(CURRENT_PACKAGE, 1, -12)\n' +
'local manager = {}\n';

static private const END:String =
'return manager\n';

// 0:className
static private const DEF_VAR:String = 
'manager.{0}_Data = require(CURRENT_PACKAGE..".{0}_Data")\n';

// 0:className
// 1:getItemParam
// 2:getItemParamKey
static private const GET_ITEM_FUN:String = 
'function manager.get{0}({1})\n' +
'    return manager.{0}_Data[tostring({2})]\n' +
'end\n';

// 0:className
static private const GET_ITEM_BY_INDEX_FUN:String =
'function manager.get{0}(idx)\n' +
'    return manager.{0}_Data[idx]\n' +
'end\n';

// 0:className
static private const CLEAR_PACKAGE:String = 
'_G.package[CURRENT_PACKAGE..".{0}_Data"]=nil';

static private const CLEAR_FUN_HEAD:String =
'function manager.clear()';

static private const FUN_END:String = 'end\n';
		
		public static function doMake(list:Vector.<CppVo>):String
		{
			var arr:Array = [HEAD];
			var len:int = list.length;
			var clearArr:Array = [CLEAR_FUN_HEAD];
			for (var i:int = 0; i < len; i++)
			{
				arr.push(StringUtil.substitute(DEF_VAR, list[i].name));
				if (list[i].isMap)
				{
					var args:String = list[i].getItemFunArgs.join(',')
					var key:String = list[i].getItemFunArgs.join("..'_'..");
					arr.push(StringUtil.substitute(GET_ITEM_FUN, list[i].name, args, key));
				} else 
				{
					arr.push(StringUtil.substitute(GET_ITEM_BY_INDEX_FUN, list[i].name));
				}
				clearArr.push(StringUtil.substitute(CLEAR_PACKAGE, list[i].name));
			}
			clearArr.push(FUN_END);
			arr.push(clearArr.join('\n'));
			
			arr.push(END);
			return arr.join('');
		}
		
	}

}