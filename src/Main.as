/**
 * User: dima
 * Date: 10/02/12
 * Time: 1:59 PM
 */
package {
import flash.display.Sprite;

import game.GameContainer;

import game.SceneController;

public class Main extends Sprite {
	private var sceneController:SceneController;

	public function Main() {
		trace("app started");
		startGame();
	}

	/* Internal functions */

	private function startGame():void {
		sceneController = new SceneController(new GameContainer(this));
	}
}
}
