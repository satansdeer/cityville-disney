package game.map {
import as3isolib.display.IsoSprite;
import as3isolib.display.scene.IsoScene;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;

import core.enum.ScenesENUM;
import core.enum.WindowsENUM;
import core.layer.LayersENUM;
import core.window.WindowManager;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLLoader;

import game.GameView;
import game.collector.ObjectsCollector;
import game.events.CastleEvent;
import game.vo.MapObjectVO;

import iface.windows.NewLevelWindow;

import mouse.MouseManager;

import org.casalib.util.StageReference;

import rpc.GameRpc;

import ru.beenza.framework.layers.LayerManager;

	/**
	 * ObjectsMap
	 * @author satansdeer
	 */
	public class ObjectsMap extends MapBase{
		
		private var objects:Array = [];
		
		private var _plot:FarmPlot;
		private var _castle:Castle;

		private var _objectForBuying:MapObject;
		
		private var _controller:MapsController;
		
		private var _shownObjects:Array = [];
		
		private var _tempObjects:Array = [];
		private var _newObjectsForShow:Array = [];
		private var tempObject:MapObject;
		private const SHOW_NUM:int = 1;

		public function ObjectsMap(gameView:GameView, controller:MapsController) {
			super(gameView);
			_controller = controller;
			_scene = _gameView.getScene(ScenesENUM.OBJECTS);
			LayerManager.getLayer(LayersENUM.SCENE).addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			LayerManager.getLayer(LayersENUM.SCENE).addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			StageReference.getStage().addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			StageReference.getStage().addEventListener(Event.ENTER_FRAME, onEnterFrame);

			if (ObjectsCollector.instance.objectVOs) { load();
			} else {
				ObjectsCollector.instance.addEventListener(Event.COMPLETE, onObjectsLoaded);
			}
			MouseManager.instance.addEventListener(Event.CHANGE, onMouseModeChange);
		}

		public function get scene():IsoScene { return _scene; }
		
		public function setObjectForBuying(value:MapObjectVO):void{
			var isoMouse:Point = stageToIso(new Point(_scene.container.mouseX,_scene.container.mouseY));
			_objectForBuying = new MapObject(value, this);
			_objectForBuying.x = isoMouse.x;
			_objectForBuying.y = isoMouse.y;
			_objectForBuying.isoSprite.moveTo(isoMouse.x, isoMouse.y, 0);
			_scene.addChild(_objectForBuying.isoSprite);
			GameView.instance.getScene(ScenesENUM.GRID).render();
			_objectForBuying.isoSprite.render();
		}

		private function addPlot():void {
			_plot = FarmPlot.create(this);
			_scene.addChild(_plot.isoSprite);
			_plot.x = 19;//10;
			_plot.y = 3;//2;
			_plot.isoSprite.moveTo(_plot.x * Main.UNIT_SIZE, _plot.y * Main.UNIT_SIZE, 0);
			_plot.isoSprite.setSize(_plot.vo.width *Main.UNIT_SIZE,_plot.vo.length *Main.UNIT_SIZE,1);
			_plot.isoSprite.render();
		}

		private function addCastle():void {
			_castle = Castle.create(this);
			_scene.addChild(_castle.isoSprite);
			_castle.x = 10;
			_castle.y = 2;
			_castle.isoSprite.moveTo(_castle.x * Main.UNIT_SIZE, _castle.y * Main.UNIT_SIZE, 0);
			_castle.isoSprite.setSize(_castle.vo.width *Main.UNIT_SIZE, _castle.vo.length *Main.UNIT_SIZE,1);
			_castle.isoSprite.render();
			_castle.addEventListener(CastleEvent.CLICK, onCastleClick);
		}

		private function onCastleClick(event:CastleEvent):void {
			var window:NewLevelWindow = WindowManager.instance.getWindow(WindowsENUM.NEWLEVEL_WINDOW) as NewLevelWindow;
			window.updateItems(ObjectsCollector.instance.objectVOs);
			GameRpc.instance.upgradeCastle();
		}

		public function plantPlot():void {
			_plot.plantIfCan();
		}
		
		public function addObjectAt(x:int, y:int, vo:MapObjectVO):void{
			objects.push(new MapObject(vo, this));
			objects[objects.length -1].shown = true;
			_shownObjects.push(objects[objects.length-1]);
			_scene.addChild(_shownObjects[_shownObjects.length-1].isoSprite);
			_shownObjects[_shownObjects.length-1].x = x/Main.UNIT_SIZE;
			_shownObjects[_shownObjects.length-1].y = y/Main.UNIT_SIZE;
			_shownObjects[_shownObjects.length-1].isoSprite.moveTo(x,y,0);
			_shownObjects[_shownObjects.length-1].isoSprite.setSize(_shownObjects[_shownObjects.length-1].vo.width *Main.UNIT_SIZE,_shownObjects[_shownObjects.length-1].vo.length *Main.UNIT_SIZE,1);
			_shownObjects[_shownObjects.length-1].isoSprite.render();
		}
		
		public function removeObject(object:MapObject):void{
			object.remove();
			_scene.removeChild(object.isoSprite);
			objects.splice(objects.indexOf(object),1);
			_shownObjects.splice(_shownObjects.indexOf(object),1);
		}

		private function onMouseModeChange(event:Event):void {
			/*if (MouseManager.instance.mode == MouseManager.REMOVE_MODE) {
				_castle.img.mouseEnabled = false;
				_castle.img.alpha = .5;
				_plot.img.alpha = .5;
			} else {
				_castle.img.mouseEnabled = true;
				_castle.img.alpha = 1;
				_plot.img.alpha = 1;
			}*/
		}
		
		private function onObjectsLoaded(event:Event):void {
			load();
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
					GameRpc.instance.buyTown(_objectForBuying.vo.id.toString(), _objectForBuying.x,  _objectForBuying.y, onObjectBought);
				}
				_objectForBuying = null;
				//grid.clear();
				setObjectsMouseEnabled(true);
			}
		}

		private function onObjectBought(response:Object):void {
		}
		
		private function load():void{
			addPlot();
			addCastle();
			GameRpc.instance.getMapObjects(onMapObjectsLoaded);
		}

		private function onMapObjectsLoaded(response:Object):void {
			var objectList:Array = response as Array;
			var mapObjectVO:MapObjectVO;
			for(var i:int = 0; i<objectList.length; i++){

				mapObjectVO = getVOById(objectList[i]["id"]);
				//mO.x = int(objectList[i]["x"]);
				//mO.y = int(objectList[i]["y"]);
				//mO.shown = true;
				addObjectAt(int(objectList[i]["x"]), int(objectList[i]["y"]), mapObjectVO);
			}
		}

		private function getVOById(id:String):MapObjectVO{
			for each (var objectVO:MapObjectVO in ObjectsCollector.instance.objectVOs) {
				if (objectVO.id.toString() == id) {
					return objectVO;
				}
			}
			return null;
		}
		
		protected function onMouseMove(event:MouseEvent):void{
			if(_objectForBuying){
				var isoMouse:Point = stageToIso(new Point(_scene.container.mouseX,_scene.container.mouseY));
				if((_objectForBuying.y != isoMouse.y) || (_objectForBuying.x != isoMouse.x)){
					_objectForBuying.x = isoMouse.x;
					_objectForBuying.y = isoMouse.y;
					_objectForBuying.isoSprite.moveTo(isoMouse.x, isoMouse.y, 0);
				}
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
		
		private function placeAvailable(object:MapObject):Boolean{
			var obj:MapObject;
			var rect:Rectangle;
			const objectRect:Rectangle = new Rectangle(int(object.isoSprite.x/Main.UNIT_SIZE), int(object.isoSprite.y/Main.UNIT_SIZE), object.vo.width, object.vo.length);
			const objRect:Rectangle = new Rectangle();
			for each (obj in _shownObjects.concat(_castle, _plot)) {
//				if (obj != _plot) {
					objRect.x = int(obj.isoSprite.x/Main.UNIT_SIZE);
					objRect.y = int(obj.isoSprite.y/Main.UNIT_SIZE);
//				} else {
//					objRect.x = 14; objRect.y = 6;
//				}
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
			p.x = Math.floor(pt.x / (Main.UNIT_SIZE)) * (Main.UNIT_SIZE);
			p.y = Math.floor(pt.y / (Main.UNIT_SIZE)) * (Main.UNIT_SIZE);
			return p;
		}
		
		private function getObjectByXY(oX:int, oY:int):MapObject{
			for(var i:int = 0; i<objects.length; i++){
				if((objects[i].x == oX) && (objects[i].y == oY)){
					return objects[i];
				}
			}
			return null;
		}
		
		public function updateRegion():void {
			//grid.moveTo(_controller.minUnitIsoPoint.x*Main.UNIT_SIZE, _controller.minUnitIsoPoint.y * Main.UNIT_SIZE, 0);
			//grid.render();
			_gameView.getScene(ScenesENUM.GRID).render();
			for (var k:int = 0; k<objects.length; k++){
				if((objects[k].x>_controller.minUnitIsoPoint.x) && (objects[k].y>_controller.minUnitIsoPoint.y) && (objects[k].x<_controller.maxUnitIsoPoint.x) && (objects[k].y<_controller.maxUnitIsoPoint.y)){
					if(objects[k].shown == false){
						objects[k].shown = true;
						_newObjectsForShow.push(objects[k]);
					}
				}
			}
			_tempObjects = [];
			for (k = 0; k < _shownObjects.length; k++){
				if((_shownObjects[k].x<_controller.minUnitIsoPoint.x) || (_shownObjects[k].y<_controller.minUnitIsoPoint.y) || (_shownObjects[k].x>_controller.maxUnitIsoPoint.x) || (_shownObjects[k].y>_controller.maxUnitIsoPoint.y)){
					_scene.removeChild(_shownObjects[k].isoSprite);
					getObjectByXY(_shownObjects[k].x, _shownObjects[k].y).shown = false;
				}else{
					_tempObjects.push(_shownObjects[k]);
				}
			}
			_shownObjects = _tempObjects;
		}
		
		public function showNewObjects():void {
			if(_newObjectsForShow.length >0){
				var max:int;
				if(_newObjectsForShow.length >= SHOW_NUM){
					max = SHOW_NUM;
				}else{
					max = _newObjectsForShow.length;
				}
				for (var i:int = 0; i < SHOW_NUM; i++){
					tempObject = _newObjectsForShow[_newObjectsForShow.length -1];
					if(tempObject && ((tempObject.x>_controller.minUnitIsoPoint.x) || (tempObject.y>_controller.minUnitIsoPoint.y) || (tempObject.x<_controller.maxUnitIsoPoint.x) || (tempObject.y<_controller.maxUnitIsoPoint.y))){
						var object:MapObject = _newObjectsForShow.shift();
						if(object){
							_shownObjects.push(object);
							_shownObjects[_shownObjects.length-1].isoSprite.moveTo(object.x * Main.TILE_SIZE, object.y * Main.TILE_SIZE, 0);
							_scene.addChild(_shownObjects[_shownObjects.length-1].isoSprite);
							_shownObjects[_shownObjects.length-1].isoSprite.render();
							//_scene.render();
						}
					}
				}
			}
		}
		
		public function setSize(sW:int, sL:int):void {
			//grid.setGridSize(_controller.maxUnitIsoPoint.x - _controller.minUnitIsoPoint.x,_controller.maxUnitIsoPoint.y - _controller.minUnitIsoPoint.y);
			//grid.y = -Main.UNIT_SIZE/2;
			//grid.x = Main.UNIT_SIZE/2;
		}
	}
}