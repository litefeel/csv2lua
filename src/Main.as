package 
{
	import com.litefeel.makeCpp.constant.Config;
	import com.litefeel.makeCpp.luaMaker.MakeLua;
	import com.litefeel.makeCpp.parse.CppParser;
	import com.litefeel.makeCpp.parse.Make;
	import com.litefeel.makeCpp.parse.Parser;
	import com.litefeel.makeCpp.vo.CppVo;
	import com.litefeel.Running;
	import com.litefeel.utils.StringUtil;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author lite3
	 */
	public class Main extends Sprite 
	{
		private var ui:UI;
		private var selectBtnId:int;
		private var hasErr:Boolean = false;
		
		public function Main():void 
		{
			if (!stage) addEventListener(Event.ADDED_TO_STAGE, init);
			else init(null);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvokeHandler);
			
			initUI()
		}
		
		private function onInvokeHandler(e:InvokeEvent):void 
		{
			if (e.arguments.length == 0) return;
			
			if (e.arguments[0] == "make")
			{
				doMakeLua(null);
				if (!hasErr)
				{
					NativeApplication.nativeApplication.exit();
				}
			}
		}
		
		private function onUncaughtError(e:UncaughtErrorEvent):void 
		{
			hasErr = true;
			appendMsg("Error:");
			appendMsg(e.text);
			if (e.text) appendMsg(e.text);
			if (e.error)
			{
				var err:Error = e.error as Error;
				appendMsg(err.errorID + "   " + err.name + "   " + err.message);
				if (Running.curCsvName)
				{
					var msg:String = "file:{0}\nrow:{1}\ncol:{2}\n";
					msg = StringUtil.substitute(msg, Running.curCsvName, Running.curCsvRowIdx + 1, Running.int2ABC(Running.curCsvColIdx+1));
					appendMsg(msg);
				}
			}
		}
		
		private function initUI():void 
		{
			ui = new UI();
			addChild(ui)
			
			ui.btn1.addEventListener(MouseEvent.CLICK, onBtnClick);
			ui.btn2.addEventListener(MouseEvent.CLICK, onBtnClick);
			ui.btn3.addEventListener(MouseEvent.CLICK, onBtnClick);
			ui.startBtn.addEventListener(MouseEvent.CLICK, doMakeLua);
			
			var so:SharedObject = SharedObject.getLocal("makeCpp");
			var path:String = so.data.path1 as String;
			if (path) ui.pathTxt1.text = path;
			path = so.data.path2 as String;
			if (path) ui.pathTxt2.text = path;
			path = so.data.path3 as String;
			if (path) ui.pathTxt3.text = path;
			so.flush();
		}
		
		private function onBtnClick(e:MouseEvent):void 
		{
			selectBtnId = 0;
			switch(e.currentTarget)
			{
				case ui.btn1 : selectBtnId = 1; break;
				case ui.btn2 : selectBtnId = 2; break;
				case ui.btn3 : selectBtnId = 3; break;
			}
			if (selectBtnId > 0)
			{
				var file:File = new File();
				file.addEventListener(Event.SELECT, onSelectFile);
				if (selectBtnId == 3)
				{
					file.browseForOpen("选择文件");
				}else
				{
					file.browseForDirectory("选择目录");
				}
			}
		}
		
		private function onSelectFile(e:Event):void 
		{
			var file:File = e.currentTarget as File;
			var path:String = file.nativePath
			ui["pathTxt" + selectBtnId].text = path;
			var so:SharedObject = SharedObject.getLocal("makeCpp");
			so.data["path" + selectBtnId] = path;
		}
		
		private function doMakeLua(e:MouseEvent):void 
		{
			Config.csvPath = ui.pathTxt1.text;
			Config.luaPath = ui.pathTxt2.text;
			Config.descFile = ui.pathTxt3.text;
			if (Config.csvPath) Config.csvPath += "/";
			if (Config.luaPath) Config.luaPath += "/";
			var parser:Parser = new Parser();
			parser.doParse(Config.descFile);
			MakeLua.showMsg = appendMsg;
			var maker:MakeLua = new MakeLua(parser.list, Config.luaPath, Config.csvPath);
			maker.doMake();
			appendMsg("完成。");
		}
		
		private function appendMsg(msg:String):void 
		{
			ui.msgTxt.appendText("\n" + msg);
		}
	}
	
}