package com.litefeel.makeCpp.parse 
{
	import com.litefeel.makeCpp.vo.CppVo;
	import com.litefeel.utils.FileUtil;
	import com.litefeel.utils.StringUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class Parser 
	{
		public static const STATIC_VO_H:String = '#ifndef __STATICVO_H__\n' +
												 '#define __STATICVO_H__\n\n';
		public static const STATIC_VO_END:String = '#endif // __STATICVO_H__';
		public static const STATIC_VO_INCLUDE:String = '#include "model/staticvo/{0}.h"\n';
		
		public var list:Vector.<CppVo>;
		
		//public var outputPath:String;
		
		public function Parser() 
		{
			
		}
		
		public function doParse(cppfile:String):void
		{
			var data:String = FileUtil.readString(cppfile);
			data = StringUtil.trim(data);
			var classList:Array = data.split(/\r\n\r\n+|\n\n+/);
			list = new Vector.<CppVo>();
			var parser:CppParser = new CppParser();
			for each(var one:String in classList)
			{
				one = StringUtil.trim(one);
				if (!one) continue;
				
				var vo:CppVo = parser.parse(one);
				list.push(vo);
				//var str:String = Make.makeH(vo);
				//FileUtil.saveToFile(str, outputPath + vo.name + ".h");
				//str = Make.makeCpp(vo);
				//FileUtil.saveToFile(str, outputPath + vo.name + ".cpp");
			}
			
			//saveStaticVoFile(list);
			
			//str = StaticDataMake.doMakeH(list);
			//FileUtil.saveToFile(str, outputPath + "StaticData.h");
		}
		
		//private function saveStaticVoFile(list:Vector.<CppVo>):void 
		//{
			//FileUtil.saveToFile(StaticVoHMake.doMake(list), outputPath + "StaticVo.h");
		//}
		
	}

}