package game.map
{
	import as3isolib.display.scene.IsoScene;
	
	import game.GameView;

	public class MapBase
	{
		protected var _gameView:GameView;
		protected var _scene:IsoScene;
		
		public function MapBase(gameView:GameView)
		{
			_gameView = gameView;
		}
	}
}