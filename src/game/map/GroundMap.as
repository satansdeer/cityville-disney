package game.map
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.scene.IsoScene;
	
	import core.AppData;
	import core.enum.ScenesENUM;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import game.GameView;
	import game.events.GameViewEvent;
	
	import ru.beenza.framework.utils.EventJoin;

	/**
	 * GroundMap
	 * @author satansdeer
	 */
	
	public class GroundMap extends MapBase {
		
		private var _map:Array;
		private var tiles:Array = [];
		
		private var _eventJ:EventJoin;
		
		[Embed(source="assets/tile.png")]			private static const FloorPNG:Class;
		
		private static const floorBmd:BitmapData		= (new FloorPNG() as Bitmap).bitmapData;
		
		[Embed(source="assets/water.png")]			private static const WaterPNG:Class;
		
		private static const waterBmd:BitmapData		= (new WaterPNG() as Bitmap).bitmapData;
		private static var _instance:GroundMap;
		
		public function GroundMap(gameView:GameView) {
			super(gameView);
			_instance = this;
			_scene = _gameView.getScene(ScenesENUM.GROUND);
			_eventJ = new EventJoin(2,load);
			AppData.instance.addEventListener(Event.COMPLETE, onComplete);
		}
		
		protected function onGameViewMove(event:Event):void{
			
		}
		
		public static function get instance():GroundMap{
			return _instance;
		}
		
		public function setSize(w:int, h:int):void{
			var tile:IsoSprite;
			var bmp:Bitmap;
			for (var x:int=0; x < w; x++){
				if(x >= _map.length){
					_map[x] = new Array();
				}
				for(var y:int= 0; y < h; y++){
					if(x >= _map.length || y >= _map[x].length){
						_map[x][y] = "g";
					}
				}
			}
		}
		
		protected function onComplete(event:Event):void{
			_eventJ.join(event);
		}
		
		private function load():void{
			trace(AppData.options.groundMap)
			_map = MapLoader.mapFromFile(AppData.options.groundMap);
			makeTileMap();
		}
		
		private function makeTileMap():void {
			var tile:IsoSprite;
			var bmp:Bitmap;
			for(var x:int = 0; x < _map.length; x++){
				for(var y:int = 0; y < _map[x].length; y++){
					tile = new IsoSprite();
					tile.setSize(Main.UNIT_SIZE, Main.UNIT_SIZE, 0);
					tile.moveTo(x * Main.UNIT_SIZE, y * Main.UNIT_SIZE, 0);
					tile.data = {x:x, y:y}
					if(_map[x][y] == "g"){
						bmp = new Bitmap(floorBmd);
					}else{
						bmp = new Bitmap(waterBmd);
					}
					tile.container.addChild(bmp);
					_scene.addChild(tile);
					tile.render();
					tiles.push(tile)
					_scene.render();
				}
			}
		}
	}
}