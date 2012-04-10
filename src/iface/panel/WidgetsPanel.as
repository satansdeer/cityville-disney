/**
 * User: dima
 * Date: 10/04/12
 * Time: 3:54 PM
 */
package iface.panel {
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

import game.model.UserSession;

public class WidgetsPanel {
	private var _view:Sprite;
	private var _money:TextField;
	private var _food:TextField;
	private var _level:TextField;

	public function WidgetsPanel(view:Sprite) {
		_view = view;
		init();
		UserSession.instance.addEventListener(Event.CHANGE, onUserStateChange);
	}

	private function init():void {
		_money = _view["moneyTxt"];
		_food = _view["foodTxt"];
		_level = _view["levelTxt"];
	}

	private function onUserStateChange(event:Event):void {
		_money.text = UserSession.instance.money.toString();
		_food.text = UserSession.instance.food.toString();
		_level.text = UserSession.instance.level.toString();
	}
}
}
