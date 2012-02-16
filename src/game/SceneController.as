package game {
import game.editor.EditorPanel;
import game.map.TileMapController;

public class SceneController {
	private var _container:GameContainer;
	private var _tileMap:TileMapController;
	private var _editorPanel:EditorPanel;

	public function SceneController(gameContainer:GameContainer) {
		_container = gameContainer;
		_tileMap = new TileMapController(gameContainer, 20, 20);
		_tileMap.drawBaseMap();
		_editorPanel = new EditorPanel();
		_editorPanel.moveToRight();
		_container.addChild(_editorPanel);
		addListeners();
	}

	private function addListeners():void {
	}

}
}
