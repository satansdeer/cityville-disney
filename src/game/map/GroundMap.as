package game.map
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.Pt;
	
	import game.staticModel.AppData;
	import core.FpsMeter;
	import core.enum.ScenesENUM;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	import game.GameView;
	import game.events.GameViewEvent;
	
	import org.casalib.util.StageReference;
	
	import ru.beenza.framework.utils.EventJoin;

	/**
	 * GroundMap
	 * @author satansdeer
	 */
	
	public class GroundMap extends MapBase {
		
		private var _map:Vector.<Vector.<Tile>>;
		private var tiles:Vector.<Tile> = new Vector.<Tile>;
		
		private var _eventJ:EventJoin;
		private static var _instance:GroundMap;
		
		private var _newTilesFowShow:Vector.<Tile> = new Vector.<Tile>;
		private var showNum:uint = 0;
		private const MAX_SHOW_NUM:uint = 45;
		private var _controller:MapsController;
		private var tilesLength:uint;
		
		public function GroundMap(gameView:GameView, controller:MapsController) {
			super(gameView);
			_controller = controller;
			_instance = this;
			_stage = StageReference.getStage();
			_scene = _gameView.getScene(ScenesENUM.GROUND);
			_eventJ = new EventJoin(2,load);
			//load();
			AppData.instance.addEventListener(Event.COMPLETE, onComplete);
		}
		
		public static function get instance():GroundMap{
			return _instance;
		}
		
		public function setSize(w:int, h:int):void{
			var tile:IsoSprite;
			var bmp:Bitmap;
			_tempMap = new Vector.<Vector.<Tile>>(w, true);
			for (var x:int=0; x < w; x++){
				_tempMap[x] = new Vector.<Tile>(h, true);
				for(var y:int= 0; y < h; y++){
					_tempMap[x][y] =  new Tile(x,y, Tile.TILE1_URL);
					_newTilesFowShow.push(_tempMap[x][y]);
				}
			}
			if (_map) {
				var width:int = Math.min(_map.length, _tempMap.length);
				var height:int;
				for (x=0; x < width; x++){
					height = Math.min(_map[x].length, _tempMap[x].length);
					for(y= 0; y < height; y++){
						_tempMap[x][y] =  _map[x][y];
					}
				}
			}
			_map = _tempMap;
		}
		
		protected function onComplete(event:Event):void{
			_eventJ.join(event);
		}
		
		private function load():void{
			MapLoader.mapFromServer(onMapLoaderComplete);
		}
		
		protected function onMapLoaderComplete():void{
			_map = MapLoader.map;
			makeTileMap();
		}
		
		private function makeTileMap():void {
			var mapWidth:int = _map.length;
			if (mapWidth == 0) { return; }
			var mapLength:int = _map[0].length;
			for(var x:int = 0; x < mapWidth; x++){
				for(var y:int = 0; y < mapLength; y++){
					tempTile = _map[x][y]
					tempTile.shown = true;
					_newTilesFowShow.push(tempTile);
				}
			}
			_controller.fogMap.setSize(mapWidth, mapLength);
		}
		
		private function getTileByXY(tX:int, tY:int):Tile{
			if(tX<0){return null}
			if(tY<0){return null}
			if(tX>=_map.length){return null}
			if(tY>=_map[tX].length){return null}
			return _map[tX][tY];
		}
		
		public function updateRegion():void {
			for (var k:int = _controller.minUnitIsoPoint.x; k < _controller.maxUnitIsoPoint.x; k++){
				for (var q:int = _controller.minUnitIsoPoint.y; q < _controller.maxUnitIsoPoint.y; q++){
					tempTile = getTileByXY(k,q);
					if(tempTile && !tempTile.shown){
						_newTilesFowShow.push(tempTile);
						tempTile.shown = true;
					} 
				}
			}
			tempTiles = new Vector.<Tile>;
			tilesLength = tiles.length;
			for(k = 0; k < tilesLength; k++){
				tempTile = tiles[k];
				if((tempTile.x<_controller.minUnitIsoPoint.x) || (tempTile.y<_controller.minUnitIsoPoint.y) || (tempTile.x>_controller.maxUnitIsoPoint.x) || (tempTile.y>_controller.maxUnitIsoPoint.y)){
					_scene.removeChild(tempTile.isoSprite);
					tempTile.remove();
					getTileByXY(tempTile.x,tempTile.y).shown = false;
				}else{
					tempTiles.push(tempTile)
				}
			}
			tiles = tempTiles;
		}
		
		public function showNewTiles():void {
			recountShowNum();
			if(_newTilesFowShow.length >0){
				var max:int;
				if(_newTilesFowShow.length >= showNum){
					max = showNum;
				}else{
					max = _newTilesFowShow.length;
				}
				for (var i:int = 0; i < showNum; i++){
					if(_newTilesFowShow.length > 0){
						tempTile = _newTilesFowShow[_newTilesFowShow.length -1];
						if(tempTile && ((tempTile.x>_controller.minUnitIsoPoint.x) || (tempTile.y>_controller.minUnitIsoPoint.y) || (tempTile.x<_controller.maxUnitIsoPoint.x) || (tempTile.y<_controller.maxUnitIsoPoint.y))){
							var tile:Tile = _newTilesFowShow.shift();
							if(tile){
								if(!tile.isoSprite){
									tile.draw();
								}
								tile.isoSprite.moveTo(tile.x * Main.UNIT_SIZE, tile.y * Main.UNIT_SIZE, 0);
								_scene.addChild(tile.isoSprite);
								tile.isoSprite.render();
								tiles.push(tile)
							}
						}
					}
				}
			}
		}

		public function mapToJSON():String {
			if (_map.length == 0) { return "{\"width\":0, \"height\":0}"; }
			/*
			var tiles:String = "[";
			for (var i:int = 0; i < _map.length; ++i) {
				for (var j:int = 0; j < _map[i].length; ++j) {
					tiles += "\"" + Configuration.HOST + "/" + Tile.TILE1_URL + "\"";
					if (i != 3 || j != 3) { tiles += ", "; }
				}
			}
			tiles += "]";
			*/
			return "{\"width\":" + _map.length + ", \"height\":" + _map[0].length + "}";
		}

		/* Internal function */

		private function recountShowNum():void {
			if(FpsMeter.instance.fps > MAX_SHOW_NUM){
				showNum = MAX_SHOW_NUM
			}else{
				showNum = FpsMeter.instance.fps; 
			}
		}
	}
}