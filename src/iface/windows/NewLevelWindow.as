/**
 * Created by : Dmitry
 * Date: 4/15/12
 * Time: 11:48 AM
 */
package iface.windows {
import core.component.IfaceBtnWrapper;
import core.component.panel.PanelItem;
import core.display.AssetManager;
import core.display.InteractivePNG;
import core.event.WindowEvent;
import core.window.IScreenWindow;
import core.window.WindowBase;

import flash.events.Event;

import flash.events.MouseEvent;

import game.model.UserSession;
import game.vo.MapObjectVO;

import mouse.MouseManager;

public class NewLevelWindow extends WindowBase implements IScreenWindow{
	private var _view:LevelUp_view;
	private var _objectVOs:Vector.<MapObjectVO> = new Vector.<MapObjectVO>(3, true);

	public function NewLevelWindow() {
		_view = new LevelUp_view();
		_view.x = Main.APP_WIDTH/2 - _view.width/2;
		_view.y = Main.APP_HEIGHT/2 - _view.height/2;
		addChild(_view);
		init();
		addListeners();
		UserSession.instance.addEventListener(Event.CHANGE, onStateChange);
	}

	public function updateItems(objectVOs:Vector.<MapObjectVO>):void {
		var index:int;
		for (var i:int = 0; i < 3; ++i) {
			index = Math.random() * (objectVOs.length/3) + i*(objectVOs.length/3);
			if (index < objectVOs.length) {
				_view["item" + (i+1)].visible = true;
				if (_view["item" + (i+1)]["photo"].numChildren > 0) { _view["item" + (i+1)]["photo"].removeChildAt(0); }
				_view["item" + (i+1)]["photo"].addChild(new PanelItem(objectVOs[index]));
				_view["item" + (i+1)]["priceTxt"].text = 500;
				_objectVOs[i] = objectVOs[index];
			} else {
				_view["item" + (i+1)].visible = false;
			}
		}
	}


	private function init():void {
		for (var i:int = 1; i <= 3; ++i) {
			IfaceBtnWrapper.wrap(_view["item" + i].buyBtn);
			_view["item" + i].buyBtn.mouseChildren = false;
		}
	}

	private function addListeners():void {
		IfaceBtnWrapper.wrap(_view.closeBtn);

		_view.closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtnClick);
		for (var i:int = 1; i <= 3; ++i) {
			_view["item" + i].buyBtn.addEventListener(MouseEvent.CLICK, onItemClick);
		}
	}

	private function onItemClick(event:MouseEvent):void {
		for (var i:int = 1; i <= 3; ++i) {
			if (event.target.parent == _view["item" + i]) {
				MouseManager.instance.mode = MouseManager.NORMAL_MODE;
				MouseManager.instance.img = new InteractivePNG(AssetManager.getImageByURL(_objectVOs[i-1].url))
				MouseManager.instance.data = _objectVOs[i-1];
				dispatchEvent(new WindowEvent(WindowEvent.JUST_HIDE_REQUEST));
				break;
			}
		}
	}

	private function onStateChange(event:Event):void {
		_view.levelTxt.text = UserSession.instance.level.toString();
	}

	private function onCloseBtnClick(event:MouseEvent):void {
		dispatchEvent(new WindowEvent(WindowEvent.HIDE_AND_SHOW_NEXT_REQUEST));
	}

}
}
