package com.litefeel.makeCpp.parse 
{
	import com.litefeel.makeCpp.utils.FileUtil;
	import com.litefeel.makeCpp.vo.CppVo;
	import com.litefeel.makeCpp.vo.VarVo;
	import com.litefeel.utils.StringUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class Make 
	{
		
		static private const H_HEAD:String = '#ifndef __{0}_STATICVO_H__\n' +
											 '#define __{0}_STATICVO_H__\n\n' +
											 '#include <string>\n' +
											 'using namespace std;\n\n' +
											 'class {1}\n' +
											 '{\npublic:\n';
		static private const H_END:String =  '};\n#endif // __{0}_STATICVO_H__';
		
		static private const INIT_LIST_VAR1:String = '    :{0}({1})\n';
		static private const INIT_LIST_VAR2:String = '    ,{0}({1})\n';
		static private const VAR_DECLARE:String = '    {0} {1};\n';
		static private const CONSTRUCTOR:String = '    {0}()\n{1}    {};\n';
		static private const DESTRUCTOR:String  = '    ~{0}(){};\n';
		
		public function Make() 
		{
			
		}
		
		static public function makeH(vo:CppVo):String 
		{
			var arr:Array = [];
			arr.push(StringUtil.substitute(H_HEAD, vo.name.toUpperCase(), vo.name));
			var initlist:String = makeInitList(vo.varList);
			arr.push(StringUtil.substitute(CONSTRUCTOR, vo.name, initlist));
			arr.push(StringUtil.substitute(DESTRUCTOR, vo.name));
			arr.push('public:\n');
			arr.push(makeVarDeclare(vo.varList));
			arr.push(StringUtil.substitute(H_END, vo.name.toUpperCase()));
			return arr.join('');
		}
		
		static public function makeVarDeclare(varList:Vector.<VarVo>):String 
		{
			var arr:Array = [];
			var len:int = varList.length;
			for (var i:int = 0; i < len; i++)
			{
				arr.push(StringUtil.substitute(VAR_DECLARE, varList[i].type, varList[i].name));
			}
			return arr.join('');
		}
		
		static private function makeInitList(varList:Vector.<VarVo>):String 
		{
			var arr:Array = [];
			var len:int = varList.length;
			if (len > 0)
			{
				arr.push(StringUtil.substitute(INIT_LIST_VAR1, varList[0].name, varList[0].value));
			}
			for (var i:int = 1; i < len; i++)
			{
				arr.push(StringUtil.substitute(INIT_LIST_VAR2, varList[i].name, varList[i].value));
			}
			return arr.join('');
		}
		
		public static function makeCpp(vo:CppVo):String
		{
			return '#include "' + vo.name + '.h"';
		}
		
	}

}