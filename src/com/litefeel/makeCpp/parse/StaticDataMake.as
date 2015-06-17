package com.litefeel.makeCpp.parse 
{
	import com.litefeel.makeCpp.vo.CppVo;
	import com.litefeel.makeCpp.vo.VarVo;
	import com.litefeel.utils.StringUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class StaticDataMake 
	{
public static const HEAD:String = 
'#ifndef _STATICDATA_STATICVO__\n' +
'#define _STATICDATA_STATICVO__\n\n' +
'#include "StaticVo.h"\n' +
'#include "manager/StaticDataManager.h"\n' +
'#include "utils/StringUtil.h"\n' +
'#include <vector>\n' +
'#include <string>\n' +
'#include <map>\n\n' +
'using namespace std;\n\n' +
'class StaticData\n' +
'{\n' +
'public:\n' +
'    static StaticData* getInstance();\n' +
'    static void destroyInstatnce();\n' +
'    void parse();\n\n';

public static const END:String = 
'};\n\n' +
'#endif // !_STATICDATA_STATICVO__';

public static const PRIVATE_METHODS:String = 
'\nprivate:\n' + 
'    StaticData(){};\n' +
'    ~StaticData(){};\n\n';
public static const PRIVATE_VARS:String = 
'private:\n' +
'    StaticDataManager* _manager;\n\n';
public static const PARSE_METHOD:String =
'    void parse{0}(vector<string> allline);\n'

public static const MAP_VAR:String =
'    map<{0}, {1}*> m_{1}Map;\n';
public static const VAR_NAME:String = 'm_{0}Map';

public static const CPP_HEAD:String =
'#include "StaticData.h"\n\n' +
'using namespace std;\n\n' +
'static StaticData* s_staticData = nullptr;\n\n' +
'StaticData* StaticData::getInstance()\n' +
'{\n' +
'    if (nullptr == s_staticData)\n' +
'    {\n' +
'        s_staticData = new StaticData();\n' +
'    }\n' +
'    return s_staticData;\n' +
'}\n\n' +
'void StaticData::destroyInstatnce()\n' +
'{\n' +
'    if (s_staticData != nullptr)\n' +
'    {\n' +
'        delete s_staticData;\n' +
'        s_staticData = nullptr;\n' +
'    }\n' +
'}\n\n';

public static const CPP_CONSTRUCTOR:String =
'StaticData::StaticData()\n' +
'{0}' +
'{\n' +
'    _manager = StaticDataManager::getInstance();\n' +
'}\n';

public static const INIT_LIST_VAR1:String = '    :{0}()\n';
public static const INIT_LIST_VAR2:String = '    ,{0}()\n';

public static const CPP_DESTRUCTOR_HEAD:String =
'StaticData::~StaticData()\n' +
'{\n';

public static const MAP_VAR_DEL:String =
'    for (auto item : m_{0}Map)\n' +
'    {\n' +
'        delete item.second;\n' +
'    }\n' +
'    m_{0}Map.clear();\n';

public static const SCOPE_END:String = '}\n';
public static const CPP_PARSE_METHOD_HEAD:String =
'void StaticData::parse()\n' +
'{\n' +
'    vector<string> allline;\n';

/* 0:filename
 * 1:className
 */
public static const CPP_PARSE_METHOD_ONE:String = 
'    if(_manager->getAllLine("{0}", allline))\n' +
'    {\n' +
'        parse{1}(allline);\n' +
'        _manager->sendParseMessage("{0}", allline.size());\n' +
'        allline.clear();\n' +
'    } \n' +
'}\n\n';
		
		
		public static function doMakeH(list:Vector.<CppVo>):String
		{
			var arr:Array = [HEAD];
			var len:int = list.length;
			for (var i:int = 0; i < len; i++)
			{
				arr.push(StringUtil.substitute(PARSE_METHOD, list[i].name));
			}
			arr.push(PRIVATE_METHODS);
			arr.push(PRIVATE_VARS);
			for (i = 0; i < len; i++)
			{
				arr.push(StringUtil.substitute(MAP_VAR, list[i].getItemFunParamType, list[i].name));
			}
			arr.push(END);
			return arr.join('');
		}
		
		public static function doMakeCpp(list:Vector.<CppVo>):String
		{
			var arr:Array = [CPP_HEAD];
			var initlist:String = makeInitList(list);
			arr.push(StringUtil.substitute(CPP_CONSTRUCTOR, initlist));
			makeDestructor(arr, list);
			makeParseMethod(arr, list);
			var len:int = list.length;
			for (var i:int = 0; i < len; i++)
			{
				
			}
			return arr.join('');
		}
		
		static private function makeParseMethod(arr:Array, list:Vector.<CppVo>):void 
		{
			arr.push(CPP_PARSE_METHOD_HEAD);
			var len:int = list.length;
			for (var i:int = 0; i < len; i++)
			{
				arr.push(StringUtil.substitute(CPP_PARSE_METHOD_ONE, list[i].name, list[i].fileName));
			}
			arr.push(SCOPE_END);
		}
		
		static private function makeDestructor(arr:Array, list:Vector.<CppVo>):void
		{
			arr.push(CPP_DESTRUCTOR_HEAD);
			var len:int = list.length;
			for (var i:int = 0; i < len; i++)
			{
				arr.push(StringUtil.substitute(MAP_VAR_DEL, list[i].name));
			}
			arr.push(SCOPE_END);
		}
		
		static private function makeInitList(list:Vector.<CppVo>):String 
		{
			var arr:Array = [];
			var len:int = list.length;
			if (len > 0)
			{
				var name:String = StringUtil.substitute(VAR_NAME, list[0].name);
				arr.push(StringUtil.substitute(INIT_LIST_VAR1, name));
			}
			for (var i:int = 1; i < len; i++)
			{
				name = StringUtil.substitute(VAR_NAME, list[i].name);
				arr.push(StringUtil.substitute(INIT_LIST_VAR2, name));
			}
			return arr.join('');
		}
		
	}

}