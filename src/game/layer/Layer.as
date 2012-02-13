/**
 * User: dima
 * Date: 13/02/12
 * Time: 1:33 PM
 */
package game.layer {
import flash.display.Sprite;

public class Layer extends Sprite {
	private var _type:uint;

	public function Layer(type:uint) {
		_type = type;
	}

	public function get type():uint { return _type; }
}
}
