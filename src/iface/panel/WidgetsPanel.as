/**
 * User: dima
 * Date: 10/04/12
 * Time: 3:54 PM
 */
package iface.panel {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import game.model.UserSession;

import mouse.MouseManager;

public class WidgetsPanel {
	private var _view:Sprite;
	private var _money:TextField;
	private var _food:TextField;
	private var _level:TextField;

	public function WidgetsPanel(view:Sprite) {
		_view = view;
		init();
		addListeners();
		UserSession.instance.addEventListener(Event.CHANGE, onUserStateChange);
	}

	private function init():void {
		_money = _view["moneyTxt"];
		_food = _view["foodTxt"];
		_level = _view["levelTxt"];
	}

	private function addListeners():void {
		_money.addEventListener(MouseEvent.MOUSE_OVER, onTxtMouseOver);
		_food.addEventListener(MouseEvent.MOUSE_OVER, onTxtMouseOver);
		_level.addEventListener(MouseEvent.MOUSE_OVER, onTxtMouseOver);
		_money.addEventListener(MouseEvent.MOUSE_OUT, onTxtMouseOut);
		_food.addEventListener(MouseEvent.MOUSE_OUT, onTxtMouseOut);
		_level.addEventListener(MouseEvent.MOUSE_OUT, onTxtMouseOut);
	}

	private function onTxtMouseOver(event:MouseEvent):void {
		switch (event.target) {
			case _money : MouseManager.showHint("money"); break;
			case _food : MouseManager.showHint("food"); break;
			case _level : MouseManager.showHint("level"); break;
		}
	}
	private function onTxtMouseOut(evnet:MouseEvent):void {
		MouseManager.hideHint();
	}

	private function onUserStateChange(event:Event):void {
		_money.text = UserSession.instance.money.toString();
		_food.text = UserSession.instance.food.toString();
		_level.text = UserSession.instance.level.toString();
	}
}
}
