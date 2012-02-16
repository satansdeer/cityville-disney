package game {
import game.editor.EditorPanel;
import game.map.TileMapController;

public class SceneController {
	private var _tileMap:TileMapController;
	private var _editorPanel:EditorPanel;

	public function SceneController(gameContainer:GameContainer) {
		_tileMap = new TileMapController(gameContainer, 20, 20);
		_tileMap.drawBaseMap();
		addListeners();
	}

	private function addListeners():void {
	}

}
}
