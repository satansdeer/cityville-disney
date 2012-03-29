package game.map
{
	/**
	 * MapsController
	 * @author satansdeer
	 */
	import as3isolib.geom.Pt;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import game.GameView;
	import game.events.GameViewEvent;
	
	import org.casalib.util.StageReference;
	
	public class MapsController extends EventDispatcher{
		
		protected var minPoint:Point = new Point();
		protected var maxPoint:Point = new Point();
		protected var tempPoint:Point = new Point();
		protected var tempPt:Pt = new Pt();
		protected var minIsoPoint:Pt = new Pt();
		protected var maxIsoPoint:Pt = new Pt();
		public var minUnitIsoPoint:Point = new Point();
		public var maxUnitIsoPoint:Point = new Point();
		
		private var _gameView:GameView;
		private var _groundMap:GroundMap;
		private var _objectsMap:ObjectsMap;
		
		private var _stage:Stage;
		private static var _instance:MapsController;
		
		public function MapsController(gV:GameView)
		{
			super(null);
			_gameView = gV;
			_instance = this;
			_stage = StageReference.getStage();
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_gameView.addEventListener(GameViewEvent.MOVE, onGameViewMove);
			initMaps();
		}
		
		public static function get instance():MapsController{
			return _instance;
		}
		
		public function setSize(sW:int, sL:int):void{
			_groundMap.setSize(sW, sL);
			_objectsMap.setSize(sW, sL);
		}
		
		protected function onEnterFrame(event:Event):void{
			_groundMap.showNewTiles();
			_objectsMap.showNewObjects();
		}
		
		protected function onGameViewMove(event:Event):void{
			recountRegion();
			_groundMap.updateRegion();
			_objectsMap.updateRegion();
		}
		
		private function initMaps():void {
			_groundMap = new GroundMap(_gameView, this);
			//_road1Map = new Road1Map(_gameView);
			_objectsMap = new ObjectsMap(_gameView, this);
		}
		
		protected function recountRegion():void{
			tempPoint.x = _stage.stageWidth/2;
			tempPoint.y = 0;
			minPoint = _gameView.globalToLocal(tempPoint);
			tempPoint.x = _stage.stageWidth/2;
			tempPoint.y = _stage.stageHeight;
			maxPoint = _gameView.globalToLocal(tempPoint);
			tempPt.x = minPoint.x;
			tempPt.y = minPoint.y;
			minIsoPoint = _gameView.localToIso(tempPt);
			tempPt.x = maxPoint.x;
			tempPt.y = maxPoint.y;
			maxIsoPoint = _gameView.localToIso(tempPt);
			minUnitIsoPoint.x = int(minIsoPoint.x/Main.UNIT_SIZE);
			minUnitIsoPoint.y = int(minIsoPoint.y/Main.UNIT_SIZE);
			maxUnitIsoPoint.x = int(maxIsoPoint.x/Main.UNIT_SIZE);
			maxUnitIsoPoint.y = int(maxIsoPoint.y/Main.UNIT_SIZE);
		}
	}
}