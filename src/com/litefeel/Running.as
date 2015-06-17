package com.litefeel 
{
	import flash.filesystem.File;
	/**
	 * ...
	 * @author lite3
	 */
	public class Running 
	{
		
		static public var curFile:File;
		static public var curCsvName:String	= null;
		static public var curCsvRowIdx:int	= -1;	// -1表示没有
		static public var curCsvColIdx:int	= -1;	// -1表示没有
		
		
		static private const C_A:int = "A".charCodeAt(0);
		
		/**
		 * 模拟csv的列名称
		 * @param	n >0 1:A 
		 * @return
		 */
		static public function int2ABC(n:int):String
		{
			if (n < 1) return "";
			
			n--;
			var arr:Array = [];
			while (n > 0)
			{
				arr.unshift(String.fromCharCode(C_A + (n % 26)));
				n = n / 26;
			}
			
			return arr.join("");
		}
	}

}