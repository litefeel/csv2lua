package com.litefeel.makeCpp.utils 
{
	/**
	 * ...
	 * @author lite3
	 */
	public class TypeUtil 
	{
		
		public static function isVector(typeName:String):Boolean 
		{
			return  typeName && typeName.length >= 3 &&
					'<' == typeName.charAt(0) &&
					'>' == typeName.charAt(typeName.length - 1);
		}
		
		public static function getElemType(typeName:String):String
		{
			return typeName.substr(1, typeName.length - 2);
		}
		
	}

}