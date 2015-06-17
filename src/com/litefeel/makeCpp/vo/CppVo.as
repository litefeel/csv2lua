package com.litefeel.makeCpp.vo 
{
	import com.litefeel.utils.ArrayUtil;
	/**
	 * ...
	 * @author lite3
	 */
	public class CppVo 
	{
		public var name:String;
		public var fileName:String;
		public var getItemFun:String;
		public var isMap:Boolean = true;
		//public var getItemFunParam:String;
		//public var getItemFunParamType:String;
		public var getItemFunArgsAt:Vector.<int>;
		public var getItemFunArgs:Vector.<String>;
		public var varList:Vector.<VarVo>;
		
		public function CppVo() 
		{
			varList = new Vector.<VarVo>();
			
			getItemFunArgs = new Vector.<String>();
			getItemFunArgsAt = new Vector.<int>();
		}
		
		public function setItemFunArgs(args:Array):void 
		{
			if (!args || args.length == 0)
			{
				isMap = false;
				return;
			}
			
			var len:int = args.length;
			getItemFunArgs.length = len;
			getItemFunArgsAt.length = len;
			for (var i:int = 0; i < len; i++)
			{
				var at:int = ArrayUtil.indexOfKey(varList, 'name', args[i]);
				if (-1 == at)
				{
					throw new Error("can not parse getItem for key");
				}
				getItemFunArgs[i] = args[i];
				getItemFunArgsAt[i] = at;
			}
		}
		
	}

}