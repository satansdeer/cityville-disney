package game {
import game.editor.EditorPanel;
import game.map.TileMapController;
import game.tower.TowerBase;

public class SceneController {
	private var _container:GameContainer;
	private var _tileMap:TileMapController;
	private var _editorPanel:EditorPanel;

	public function SceneController(gameContainer:GameContainer) {
		_container = gameContainer;
		_tileMap = new TileMapController(gameContainer, 20, 20);
		_tileMap.drawBaseMap();
		createEditorPanel();
		_container.addChild(_editorPanel);
		addListeners();
	}
	/* Internal functions */

	private function createEditorPanel():void {
		_editorPanel = new EditorPanel();
		_editorPanel.moveToTop();
		for (var i:int = 0; i < 4; ++i) {
			_editorPanel.addComponent(Math.random() < .5 ? TowerBase.createOneTower() : TowerBase.createTwoTower());
		}
	}

	private function addListeners():void {
	}

}
}
