/**
 * User: dima
 * Date: 10/02/12
 * Time: 5:19 PM
 */
package game {
import flash.display.Sprite;

public class SceneSprite extends Sprite{

	private var _layerType:uint;

	public function SceneSprite(layerType:uint) {
		_layerType = layerType;
	}

	public function get layerType():uint { return _layerType; }

}
}
