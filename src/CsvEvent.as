package {
	import flash.events.Event;
	public class CsvEvent extends Event{
		public static const EOF_ERROR:String="eof_error";
		private var _type:String="";
		public function CsvEvent(type:String){
			_type=type;
			super(type);
		}
		override public function clone():Event{
			var e:CsvEvent=new CsvEvent(_type);
			return e;
		}
		override public function toString():String{
			return this.formatToString("CsvEvent","type","bubbles","cancelabled","eventPhase");
		}
	}
}