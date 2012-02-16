package game {
import game.map.TileMapController;

public class SceneController {
	private var _tileMap:TileMapController;

	public function SceneController(gameContainer:GameContainer) {
		_tileMap = new TileMapController(gameContainer, 1000, 1000);
		_tileMap.drawBaseMap();
		addListeners();
	}

	private function addListeners():void {
	}

}
}
