package game.map
{
	/**
	 * MapLoader
	 * @author satansdeer
	 */

import by.blooddy.crypto.serialization.JSON;

import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

import org.osmf.events.TimeEvent;

import rpc.GameRpc;

public class MapLoader extends EventDispatcher{
		
		public static var map:Vector.<Vector.<Tile>>;
		private static var _callback:Function;
		
		public function MapLoader(target:IEventDispatcher=null) {
			super(target);
		}
		
		public static function mapFromFile(callback:Function):void{
			_callback = callback;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onMapFromFileLoaded);
			//loader.load(new URLRequest("data/map.xml"));
			loader.load(new URLRequest("data/map.json"));
		}

		public static function mapFromServer(callback:Function):void {
			_callback = callback;
			GameRpc.instance.getMap(onMapFromServerLoaded);
		}

		/* Internal functionsn */

	private static function onMapFromServerLoaded(map:String):void {
		var response:Object = JSON.decode(map)["response"];
		if (response["ok"]) {
			createMapFromJSON(response["ok"]);
		}
	}

		private static function onMapFromFileLoaded(event:Event):void {
			createMapFromJSON(JSON.decode(event.target.data))
		}

		private static function createMapFromJSON(mapObject:Object):void {
			var k:int = 0;
			if(mapObject && mapObject["width"] && mapObject["height"]){
				var tiles:Array = mapObject["tiles"];
				map = new Vector.<Vector.<Tile>>(mapObject["width"], true);

				for (var i:int = 0; i < mapObject["width"]; i++){
					map[i] = new Vector.<Tile>(mapObject["height"], true);
					for(var j:int = 0; j < mapObject["height"]; j++){
						map[i][j] = new Tile(i,j, Configuration.HOST + "/" + Tile.TILE1_URL);
						k++;
					}
				}
			} else {
				trace("map wrong [MapLoader.onMapJSONLoaded]");
				map = new Vector.<Vector.<Tile>>();
			}
			if (_callback) { _callback(); }
		}

	}
}