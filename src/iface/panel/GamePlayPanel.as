/**
 * User: dima
 * Date: 10/04/12
 * Time: 3:02 PM
 */
package iface.panel {
import core.component.IfaceBtnWrapper;
import core.enum.WindowsENUM;
import core.window.WindowManager;

import flash.display.Sprite;
import flash.events.MouseEvent;

import game.map.MapsController;

import mouse.MouseManager;

public class GamePlayPanel {
	private var _view:Sprite;
	private var _storeBtn:Sprite;
	private var _resetBtn:Sprite;
	private var _deleteBtn:Sprite;

	public function GamePlayPanel(view:Sprite) {
		_view = view;
		init();
		addListeners();
	}

	private function init():void {
		_storeBtn = _view["storeBtn"];
		_resetBtn = _view["resetBtn"];
		_deleteBtn = _view["deleteBtn"];
		IfaceBtnWrapper.wrap(_storeBtn);
		IfaceBtnWrapper.wrap(_resetBtn);
		IfaceBtnWrapper.wrap(_deleteBtn);
	}

	private function addListeners():void {
		_storeBtn.addEventListener(MouseEvent.CLICK, onStoreBtnClick);
		_resetBtn.addEventListener(MouseEvent.CLICK, onResetBtnClick);
		_deleteBtn.addEventListener(MouseEvent.CLICK, onDeleteBtnClick);

		_storeBtn.addEventListener(MouseEvent.MOUSE_OVER, onTxtMouseOver);
		_resetBtn.addEventListener(MouseEvent.MOUSE_OVER, onTxtMouseOver);
		_deleteBtn.addEventListener(MouseEvent.MOUSE_OVER, onTxtMouseOver);
		_storeBtn.addEventListener(MouseEvent.MOUSE_OUT, onTxtMouseOut);
		_resetBtn.addEventListener(MouseEvent.MOUSE_OUT, onTxtMouseOut);
		_deleteBtn.addEventListener(MouseEvent.MOUSE_OUT, onTxtMouseOut);
	}

	private function onTxtMouseOver(event:MouseEvent):void {
		switch (event.target) {
			case _storeBtn : MouseManager.showHint("store"); break;
			case _resetBtn : MouseManager.showHint("reset cursor"); break;
			case _deleteBtn : MouseManager.showHint("delete mode"); break;
		}
	}
	private function onTxtMouseOut(evnet:MouseEvent):void {
		MouseManager.hideHint();
	}

	private function onStoreBtnClick(event:MouseEvent):void {
		WindowManager.instance.showWindow(WindowsENUM.STORE_WINDOW);
	}

	private function onResetBtnClick(event:MouseEvent):void{
		MouseManager.instance.mode = MouseManager.NORMAL_MODE;
		//MapsController.instance.saveToServer();
		trace("reset btn");
	}
	private function onDeleteBtnClick(event:MouseEvent):void {
		MouseManager.instance.mode = MouseManager.REMOVE_MODE;
		trace("delete btn");
	}
}
}
