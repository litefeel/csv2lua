package com.litefeel.makeCpp.vo 
{
	/**
	 * ...
	 * @author lite3
	 */
	public class VarVo 
	{
		public var type:String;
		public var name:String;
		public var defaultValue:String;
		public var isDel:Boolean;
		public var isPercent:Boolean;
		public var isRepeat:Boolean;
		
		public function VarVo(type:String = null, name:String = null, defaultValue:String = null, isDel:Boolean = false, isPercent:Boolean = false) 
		{
			this.type = type;
			this.name = name;
			this.defaultValue = defaultValue;
			this.isDel = isDel
			this.isPercent = isPercent;
		}
		
	}

}