package  
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	/**
	 * ...
	 * @author slam
	 */
	public class LoadCsvCommand extends EventDispatcher 
	{
		private var loadDataFileNum:int;
		private var dirUrl:String;
		private var loadDataList:Array;
		private var curData:Array;
		public var loadingUrl:String;
		/**
		 * 
		 * @param	urls	{url:String,obj:Object}
		 */
		public function LoadCsvCommand(dirUrl:String,urls:Array) 
		{
			this.dirUrl = dirUrl;
			loadDataList = urls;
			
		}
		
		public function getCurURL():String
		{
			var o:Object = loadDataList[loadDataFileNum];
			return o ? o.url : "";
		}
		
		public function loadDataFile():void 
		{
			if (loadDataFileNum==loadDataList.length) 
			{
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			var fileName:String = loadDataList[loadDataFileNum].url;
			curData = loadDataList[loadDataFileNum].obj;
			
			var csvloader:CsvLoader = new CsvLoader("allData");
			csvloader.setEnCoding("gb2312");
			csvloader.addEventListener(Event.COMPLETE, loadDataFile_complete);
			csvloader.addEventListener(IOErrorEvent.IO_ERROR, loadDataFile_error);
			csvloader.loadURL(dirUrl+fileName);
		}
		
		private function loadDataFile_error(e:IOErrorEvent):void 
		{
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadDataFile_error);
			e.target.removeEventListener(Event.COMPLETE, loadDataFile_complete);
			
			loadingUrl = (e.target as CsvLoader).loadingUrl;
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			
			loadDataFileNum++;
			loadDataFile();
			
			
		}
		
		private function formatStr(arr:Array):Array
		{
			for (var i:int = arr.length - 1; i >= 0; i--)
			{
				var str:* = arr[i];
				if (str is String)
				{
					var s:String = str;
					if ('"' == s.charAt(0) && '"' == s.charAt(s.length - 1))
					{
						arr[i] = s.substr(1, s.length - 2);
					}
				}
			}
			return arr;
		}
		
		private function loadDataFile_complete(e:Event):void 
		{
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, loadDataFile_error);
			e.target.removeEventListener(Event.COMPLETE, loadDataFile_complete);
			
			var loader:CsvLoader = e.target as CsvLoader;
			var tmparr:Array = loader.getRecords();
			for (var i:int = 0; i < tmparr.length; i++) 
			{
				curData.push(formatStr(tmparr[i]));
			}
			
			//txt.text = "loadDataFile_complete";
			
			loadDataFileNum++;
			loadDataFile();
		}
		
	}

}