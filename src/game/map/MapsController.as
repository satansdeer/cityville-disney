package game.map
{
	/**
	 * MapsController
	 * @author satansdeer
	 */
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import game.GameView;
	import game.events.GameViewEvent;
	
	public class MapsController extends EventDispatcher{
		
		private var _gameView:GameView;
		private var _groundMap:GroundMap;
		private var _objectsMap:ObjectsMap;
		
		public function MapsController(gV:GameView)
		{
			super(null);
			_gameView = gV;
			_gameView.addEventListener(GameViewEvent.MOVE, onGameViewMove);
			initMaps();
		}
		
		protected function onGameViewMove(event:Event):void{
			
		}
		
		private function initMaps():void {
			_groundMap = new GroundMap(_gameView);
			//_road1Map = new Road1Map(_gameView);
			_objectsMap = new ObjectsMap(_gameView);
		}
	}
}