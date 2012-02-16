/**
 * User: dima
 * Date: 10/02/12
 * Time: 1:59 PM
 */
package {
import flash.display.Sprite;

import game.GameContainer;

import game.SceneController;

[SWF(width=400, height=400, frameRate=25)]
public class Main extends Sprite {
	public static const APP_WIDTH:int = 400;
	public static const APP_HEIGHT:int = 400;

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
