/**
 * User: dima
 * Date: 10/04/12
 * Time: 2:49 PM
 */
package core.component {
import flash.display.Sprite;
import flash.events.MouseEvent;

public class IfaceBtnWrapper {
	private var _btn:Sprite;

	public function IfaceBtnWrapper(btn:Sprite):void {
		super();
		_btn = btn;
		btn.addEventListener(MouseEvent.MOUSE_OVER, onBtnMouseOver);
		btn.addEventListener(MouseEvent.MOUSE_OUT, onBtnMouseOut);
	}

	public function get btn():Sprite { return _btn; }

	public static function wrap(btn:Sprite):void {
		new IfaceBtnWrapper(btn);
	}

	private function onBtnMouseOver(event:MouseEvent):void {
		_btn.alpha = .5;
	}
	private function onBtnMouseOut(event:MouseEvent):void {
		_btn.alpha = 1;
	}

}
}
