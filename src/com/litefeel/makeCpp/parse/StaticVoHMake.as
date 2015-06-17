package com.litefeel.makeCpp.parse 
{
	import com.litefeel.makeCpp.vo.CppVo;
	import com.litefeel.utils.StringUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class StaticVoHMake 
	{
		public static const STATIC_VO_HEAD:String = '#ifndef __STATICVO_H__\n' +
													'#define __STATICVO_H__\n\n';
		public static const STATIC_VO_END:String = '\n#endif // __STATICVO_H__';
		public static const STATIC_VO_INCLUDE:String = '#include "model/staticvo/{0}.h"\n';
		
		public function StaticVoHMake() 
		{
			
		}
		
		public static function doMake(list:Vector.<CppVo>):String
		{
			var arr:Array = [STATIC_VO_HEAD];
			for each(var vo:CppVo in list)
			{
				arr.push(StringUtil.substitute(STATIC_VO_INCLUDE, vo.name));
			}
			arr.push(STATIC_VO_END);
			return arr.join('');
		}
		
	}

}