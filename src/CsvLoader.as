package {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.errors.EOFError;
	import flash.utils.Endian;
	import flash.utils.setTimeout;
	import flash.net.FileReference;
	
	public class CsvLoader extends EventDispatcher {
		private var _records:Array=new Array  ;
		private const DQUOTES:String="#100";
		private const SEMICOLON:String="#101";
		private var _currentIndex:uint=0;
		private var _encoding:String = "utf-8";
		private var _btwKey:String = ",";
		private var fileStream:FileStream;
		private var dataStr:String;
		private var loader:File;
		public var loadingUrl:String;
		
		public var name:String;
		public function CsvLoader(_name:String = "") {
			name = _name;
		}
		
		public function loadURL(url:String):void {
			_records = new Array  ;
			
			var loader:URLLoader=new URLLoader  ;
			var link:URLRequest = new URLRequest(url);
			loadingUrl = url;
			loader.addEventListener(Event.COMPLETE,onLoadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onLoadErrorHandler);
			loader.dataFormat="binary";
			loader.load(link);
			
			//loader = new File(url);
			//loader.addEventListener(Event.COMPLETE, onLoadCompleteHandler);
			//loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
			//loader.load();
			
			//setTimeout(onLoadCompleteHandler, 500);
			
		}
		private function onLoadCompleteHandler(event:Event=null):void {
			//var byteArray:ByteArray=loader.data;
			var byteArray:ByteArray=ByteArray(event.target.data);
			var resultStr:String="";
			try {
				resultStr=byteArray.readMultiByte(byteArray.length,_encoding);
			} catch (e:EOFError) {
				dispatchEvent(new CsvEvent(CsvEvent.EOF_ERROR));
			}
			
			var tempArr:Array = CSV.decode(resultStr,_btwKey);
			//tempArr.pop();
			
			var keyName:Array = tempArr[0];
			var tmpobj:Object;
			for (var i:int = 1; i < tempArr.length; i++) 
			{
				tmpobj = [];
				for (var j:int = 0; j < tempArr[i].length; j++) 
				{
					if (keyName[j]!="") 
					{
						tmpobj[keyName[j]] = tempArr[i][j];
					}
					tmpobj[j] = tempArr[i][j];
				}
				_records.push(tmpobj);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function saveFile(fileName:String, value:Array, fieldNames:Array):void {
			var arr:Array = new Array();
			var tmparr:Array;
			var tmpName:String;
			arr.push(fieldNames);
			for (var i:int = 0; i < value.length; i++) 
			{
				
				tmparr = new Array();
				for (var j:int = 0; j < fieldNames.length; j++) 
				{
					tmparr.push(value[i][fieldNames[j]]);
				}
				arr.push(tmparr);
			}
			
			dataStr = CSV.encode(arr,_btwKey);
			dataStr = StringTools.utf8to16(dataStr);
			var file:File = File.documentsDirectory;
			loadingUrl = File.applicationDirectory.resolvePath(fileName).nativePath;
			file = new File(File.applicationDirectory.resolvePath(fileName).nativePath);
			//EditerControl.showPos = false;
			//EditDataManager.getInstance().showStr(file.nativePath,1);
			fileStream = new FileStream();
			
			fileStream.open(file, FileMode.WRITE);
			fileStream.endian = Endian.LITTLE_ENDIAN;
			//trace(fileStream.bytesAvailable)
			//fileStream.writeUTFBytes(dataStr);
			//fileStream.writeMultiByte(dataStr,_encoding);
			fileStream.writeUTFBytes(dataStr);
			fileStream.close();
			
		}
		
		private function parseBack(str:String):String {
			str=str.replace(DQUOTES,"\"");
			str=str.replace(SEMICOLON,",");
			return str;
		}
		private function parse(str:String):String {
			str=str.replace("\"\"",DQUOTES);
			str=parseSemicolon(str);
			return str;
		}
		private function parseSemicolon(str:String):String {
			var s:int=str.search("\"");
			while (s!=-1) {
				str=str.substr(s+1,str.length);
				var e:int=str.search("\"");
				var targetIndex:int=str.search(",");
				if (targetIndex!=-1&&e!=-1&&targetIndex<e) {
					str=str.substring(0,e)+str.substr(e+1,str.length);
					targetIndex=str.search(",");
					str=str.substring(0,targetIndex)+SEMICOLON+str.substr(targetIndex+1,str.length);
				}
				s=str.search("\"");
			}
			return str;
		}
		
		public function getRecords():Array {
			return _records;
		}
		
		public function getRandomRecords(nums:uint):Array {
			var tempArr:Array=new Array();
			for (var i:uint=0; i<_records.length; i++) {
				tempArr.push(i);
			}
			tempArr=randArray(tempArr);
			var targetArr:Array=new Array();
			for (i=0; i<nums; i++) {
				var id:uint=tempArr[i];
				if (i>=tempArr.length) {
					break;
				}
				targetArr.push(_records[id]);
			}
			return targetArr;
		}
		private function randArray(arr:Array):Array {
			var temp:Array=new Array  ;
			var rand:Number=0;
			while (arr.length>0) {
				rand=Math.floor(Math.random()*arr.length);
				temp.push(arr[rand]);
				arr.splice(rand,1);
			}
			return temp;
		}
		public function setBtwKey(code:String):void {
			_btwKey=code;
		}
		public function setEnCoding(code:String):void {
			_encoding=code;
		}
		private function onLoadErrorHandler(event:IOErrorEvent):void {
			//throw(loadingUrl);
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
	}
}