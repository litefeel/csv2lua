package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author slam
	 */
	public class CsvCodeTest extends Sprite
	{
		
		public function CsvCodeTest():void 
		{
			System.useCodePage = true;
			
			loadCsv();
			
			//testSaveFile();
		}
		
		private function testSaveFile():void 
		{
			var file:File = File.documentsDirectory;
			file = new File(File.applicationDirectory.resolvePath("book2sss.txt").nativePath);
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(Event.COMPLETE, openComplete);
			fileStream.openAsync(file, FileMode.UPDATE);
			
		}
		
		private function openComplete(e:Event):void 
		{
			var fileStream:FileStream = e.target as FileStream;
			fileStream.removeEventListener(Event.COMPLETE, openComplete);
			var str:String = "Tiến hành 5 lần chiến đấu";
			//str = StringTools.utf16to8(str);
			var by:ByteArray = new ByteArray;
			by.writeMultiByte(str, "unicode");
			by.position = 0;
			str = by.readMultiByte(by.length, "Unicode");
			fileStream.writeUTFBytes(str);
			fileStream.close();
			//fileStream.close();
		}
		
		private function loadCsv():void 
		{
			var csvloader:CsvLoader = new CsvLoader("Book2.csv");
			csvloader.setEnCoding("Unicode");
			csvloader.setBtwKey("	");
			csvloader.addEventListener(Event.COMPLETE, loadCsv_complete);
			csvloader.loadURL("Book1.csv");
			//csvloader.loadURL("buildingData.csv");
		}
		
		private function loadCsv_complete(e:Event):void 
		{
			e.target.removeEventListener(Event.COMPLETE, loadCsv_complete);
			
			var loader:CsvLoader = e.target as CsvLoader;
			var tmparr:Array = loader.getRecords();
			//loader.
			var outArr:Array = new Array;
			var keyMap:Array = new Array;
			var tmp:Object = tmparr[0];
			var str:String;
			for (var name:String in tmp) 
			{
				str = StringTools.utf8to16(name);
				//trace(str, name, tmp[name]);
				
				keyMap.push(str);
			}
			
			str = StringTools.utf16to8(str);
			
			//saveDataToCsv("Book2.csv", keyMap, tmparr);
			//saveDataToCsv("Book2.csv", ["chinese","yuenan"], tmparr);
		}
		
		/**
		 * 保存数据到CSV文件
		 * @param	fileName
		 * @param	attList
		 * @param	value
		 */
		public function saveDataToCsv(fileName:String,attList:Array,value:Array):void {
			
			var loader:CsvLoader = new CsvLoader("saveDataCsv2");
			loader.setEnCoding("unicode");
			loader.setBtwKey(",");
			loader.saveFile(fileName, value,attList);
		}
	}

}