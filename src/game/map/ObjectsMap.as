package game.map
{
	import as3isolib.display.IsoSprite;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	
	import core.AppData;
	import core.display.InteractivePNG;
	import core.display.IsoFurnitureGrid;
	import core.helper.XMLHelper;
	import core.layer.LayersENUM;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.GameView;
	import game.enum.ScenesENUM;
	import game.vo.MapObjectVO;
	
	import mouse.MouseManager;
	
	import org.casalib.util.StageReference;
	
	import ru.beenza.framework.layers.LayerManager;
	import ru.beenza.framework.utils.EventJoin;

	/**
	 * ObjectsMap
	 * @author satansdeer
	 */
	public class ObjectsMap extends MapBase{
		
		private var _map:Array;
		private var objects:Array = [];
		
		private var grid:IsoFurnitureGrid;
		
		private var _objectForBuying:MapObject;
		
		[Embed(source="assets/stone.png")]			private static const FloorPNG:Class;
		
		private static const floorBmd:BitmapData		= (new FloorPNG() as Bitmap).bitmapData;
		
		private var _loadEventJoin:EventJoin;
		
		public function ObjectsMap(gameView:GameView)
		{
			super(gameView);
			_scene = _gameView.getScene(ScenesENUM.OBJECTS);
			grid = new IsoFurnitureGrid();
			grid.setGridSize(16,16)
			grid.y = -Main.UNIT_SIZE/2;
			grid.x = Main.UNIT_SIZE/2;
			gameView.getScene(ScenesENUM.GRID).addChild(grid);
			grid.container.mouseChildren = false;
			grid.container.mouseEnabled = false;
			LayerManager.getLayer(LayersENUM.SCENE).addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			LayerManager.getLayer(LayersENUM.SCENE).addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			StageReference.getStage().addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			StageReference.getStage().addEventListener(Event.ENTER_FRAME, onEnterFrame);
			AppData.instance.addEventListener(Event.COMPLETE, onDataLoaded);
			_loadEventJoin = new EventJoin(2, load);
		}
		
		public function setObjectForBuying(value:MapObjectVO):void{
			var isoMouse:Point = stageToIso(new Point(_scene.container.mouseX,_scene.container.mouseY));
			_objectForBuying = new MapObject(value, this);
			_objectForBuying.x = isoMouse.x;
			_objectForBuying.y = isoMouse.y;
			_scene.addChild(_objectForBuying.isoSprite);
			//_objectForBuying.isoSprite.container.mouseChildren = false;
			//_objectForBuying.isoSprite.container.mouseEnabled = false;
			updateGridWithAvailableCells(_objectForBuying);
			GameView.instance.getScene(ScenesENUM.GRID).render();
			_objectForBuying.isoSprite.render();
		}
		
		public function addObject(object:MapObject):void{
			
		}
		
		public function get objectForBuying():MapObject{
			return _objectForBuying;
		}
		
		public function addObjectAt(x:int, y:int, vo:MapObjectVO):void{
			objects.push(new MapObject(vo, this));
			_scene.addChild(objects[objects.length-1].isoSprite);
			objects[objects.length-1].x = x;
			objects[objects.length-1].y = y;
			(objects[objects.length-1].isoSprite as IsoSprite).setSize(objects[objects.length-1].vo.width *Main.UNIT_SIZE,objects[objects.length-1].vo.length *Main.UNIT_SIZE,1);
			objects[objects.length-1].isoSprite.render();
		}
		
		public function removeObject(object:MapObject):void{
			object.remove();
			_scene.removeChild(object.isoSprite);
			objects.splice(objects.indexOf(object),1);
			save();
		}
		
		public function updateGridWithAvailableCells(object:MapObject):void {
			if (!object) return;
			
			var neutrals:Vector.<uint>, greens:Vector.<uint>, reds:Vector.<uint>;
			var x:int, y:int, obj:MapObject;
			grid.clear();
			greens = new Vector.<uint>();
			reds = new Vector.<uint>();
			
			const objectRect:Rectangle = new Rectangle(int(object.x / Main.UNIT_SIZE), int(object.y / Main.UNIT_SIZE), object.vo.width, object.vo.length);
			const objRect:Rectangle = new Rectangle();
			var rect:Rectangle;
			
			if(!objects || objects.length == 0){
				for (y = 0; y < objectRect.height; ++y) {
					for (x = 0; x < objectRect.width; ++x) {
						greens.push(objectRect.x + x, objectRect.y + y);
					}
				}
			}
			
			if(!placeAvailable(object)){
				for (y = 0; y < objectRect.height; ++y) {
					for (x = 0; x < objectRect.width; ++x) {
						reds.push(objectRect.x + x, objectRect.y + y);
					}
				}
			}else{
				for (y = 0; y < objectRect.height; ++y) {
					for (x = 0; x < objectRect.width; ++x) {
						greens.push(objectRect.x + x, objectRect.y + y);
					}
				}
			}
			grid.colorized(neutrals, greens, reds);
		}
		
		protected function onDataLoaded(event:Event):void{
			_loadEventJoin.join(event);
		}
		
		protected function onEnterFrame(event:Event):void{
			_scene.render();
		}
		
		protected function onMouseUp(event:MouseEvent):void{
			if(_objectForBuying){
				_objectForBuying.isoSprite.container.mouseChildren = true;
				_objectForBuying.isoSprite.container.mouseEnabled = true;
				_scene.removeChild(_objectForBuying.isoSprite);
				if(placeAvailable(_objectForBuying)){
					addObjectAt(_objectForBuying.x, _objectForBuying.y, _objectForBuying.vo);
				}
				_objectForBuying = null;
				grid.clear();
				setObjectsMouseEnabled(true);
				save()
			}
		}
		
		private function save():void{
			var mapString:String = "<objects>";
			for(var i:int=0; i < objects.length; i++){
				mapString += "<object id=\""+objects[i].vo.id+"\"" + " x=\""+ objects[i].x + "\"" + "y=\""+ objects[i].y + "\"" + "/>";
			}
			mapString += "</objects>";
			var mapXML:XML = new XML(mapString);
			XMLHelper.saveXML(mapXML, AppData.options.objectsMap);
		}
		
		private function load():void{
			var mapXML:XML = XMLHelper.readXML(AppData.options.objectsMap);
			for(var i:int = 0; i<mapXML.object.length(); i++){
				addObjectAt(mapXML.object[i].@x, mapXML.object[i].@y, getVOById(mapXML.object[i].@id)); 
			}
		}
		
		private function getVOById(id:String):MapObjectVO{
			var vo:MapObjectVO = new MapObjectVO();
			for (var i:int = 0; i<AppData.objects.object.length(); i++){
				if(AppData.objects.object[i].@id == id){
					vo.id = AppData.objects.object[i].@id;
					vo.name = AppData.objects.object[i].@name;
					vo.url = AppData.objects.object[i].@url;
					vo.length = AppData.objects.object[i].@length;
					vo.width = AppData.objects.object[i].@width;
					vo.offsetX = AppData.objects.object[i].@offsetX;
					vo.offsetY = AppData.objects.object[i].@offsetY;
				}
			}
			return vo;
		}
		
		protected function onMouseMove(event:MouseEvent):void{
			if(_objectForBuying){
				var isoMouse:Point = stageToIso(new Point(_scene.container.mouseX,_scene.container.mouseY));
				if((_objectForBuying.y != isoMouse.y) || (_objectForBuying.x != isoMouse.x)){
					_objectForBuying.x = isoMouse.x;
					_objectForBuying.y = isoMouse.y;
					updateGridWithAvailableCells(_objectForBuying);
				}
				//setObjectsMouseEnabled(false);
				_scene.render();
			}
		}
		
		private function setObjectsMouseEnabled(value:Boolean):void{
			for each (var obj:MapObject in objects) {
				obj.isoSprite.container.mouseEnabled = value;
				obj.isoSprite.container.mouseChildren = value;
			}
		}
		
		protected function onMouseOver(event:Event):void{
			if(!_objectForBuying && MouseManager.instance.data){
				setObjectForBuying(MouseManager.instance.data as MapObjectVO);
				MouseManager.instance.img = null;
			}
		}
		
		private function makeTileMap():void {
			var tile:IsoSprite;
			var intPng:InteractivePNG;
			for(var x:int = 0; x < _map.length; x++){
				for(var y:int = 0; y < _map[x].length; y++){
					tile = new IsoSprite();
					tile.setSize(Main.UNIT_SIZE, Main.UNIT_SIZE, 0);
					tile.moveTo(x * Main.UNIT_SIZE, y * Main.UNIT_SIZE, 0);
					tile.data = {x:x, y:y}
					intPng = new InteractivePNG(floorBmd);
					tile.container.addChild(intPng);
					intPng.x = 16;
					intPng.y -= Main.UNIT_SIZE/4;
					_scene.addChild(tile);
					tile.render();
					objects.push(tile)
					_scene.render();
				}
			}
		}
		
		private function placeAvailable(object:MapObject):Boolean{
			var obj:MapObject;
			var rect:Rectangle;
			const objectRect:Rectangle = new Rectangle(int(object.x / Main.UNIT_SIZE), int(object.y / Main.UNIT_SIZE), object.vo.width, object.vo.length);
			const objRect:Rectangle = new Rectangle();
			for each (obj in objects) {
				objRect.x = int(obj.x / Main.UNIT_SIZE);
				objRect.y = int(obj.y / Main.UNIT_SIZE);
				objRect.width = obj.vo.width;
				objRect.height = obj.vo.length;
				rect = objectRect.intersection(objRect);
				if (rect.width > 0 || rect.height > 0) {
					return false;
				}
			}
			return true;
		}
		
		private function stageToIso(p:Point):Point {
			p = LayerManager.getLayer(LayersENUM.SCENE).globalToLocal(p);
			const pt:Pt = new Pt(p.x, p.y);
			IsoMath.screenToIso(pt);
			p.x = Math.floor(pt.x / Main.UNIT_SIZE) * Main.UNIT_SIZE;
			p.y = Math.floor(pt.y / Main.UNIT_SIZE) * Main.UNIT_SIZE;
			return p;
		}
	}
}