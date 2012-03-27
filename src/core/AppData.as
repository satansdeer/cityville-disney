package core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * AppData
	 * @author satansdeer
	 */
	public class AppData extends EventDispatcher{
		
		private static var _objects:XML;
		
		private static var _options:XML;
		
		private static var _instance:AppData;
		
		public function AppData()
		{
			_instance = this;
		}
		
		public static function get instance():AppData{
			if(!_instance){
				_instance = new AppData();
			}
			return _instance;
		}
		
		public static function get objects():XML{
			return _objects;
		}
		
		public static function set objects(value:XML):void{
			_objects = value;
			_instance.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public static function get options():XML{
			return _options;
		}
		
		public static function set options(value:XML):void{
			_options = value;
			_instance.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}