/**
 * User: dima
 * Date: 10/04/12
 * Time: 2:05 PM
 */
package iface.windows {
import core.component.IfaceBtnWrapper;
import core.event.WindowEvent;
import core.window.IScreenWindow;
import core.window.WindowBase;

import flash.events.MouseEvent;
import flash.ui.Mouse;

public class StoreWindow  extends WindowBase implements IScreenWindow{
	private var _view:Store_view;

	public function StoreWindow() {
		super();
		_view = new Store_view();
		_view.x = Main.APP_WIDTH/2 - _view.width/2;
		_view.y = Main.APP_HEIGHT/2 - _view.height/2;
		addChild(_view);
		init();
		addListeners();
	}

	private function init():void {
		_view.buildTab.bg.gotoAndStop(2);
		_view.farmTab.bg.gotoAndStop(0);
	}

	private function addListeners():void {
		IfaceBtnWrapper.wrap(_view.closeBtn);
		IfaceBtnWrapper.wrap(_view.prevBtn);
		IfaceBtnWrapper.wrap(_view.nextBtn);
		_view.closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtnClick);
		_view.prevBtn.addEventListener(MouseEvent.CLICK, onPrevBtnClick);
		_view.nextBtn.addEventListener(MouseEvent.CLICK, onNextBtnClick);
		for (var i:int = 1; i <= 8; ++i) {
			IfaceBtnWrapper.wrap(_view["item" + i].buyBtn);
			_view["item" + i].buyBtn.addEventListener(MouseEvent.CLICK, onItemClick);
		}

	}

	private function onItemClick(event:MouseEvent):void {
		for (var i:int = 1; i <= 8; ++i) {
			if (event.target.parent is _view["item" + i]) {
				trace("clicked on " + i + " item [StoreWindow.onItemClick]");
			}
		}
	}

	private function onCloseBtnClick(event:MouseEvent):void {
		dispatchEvent(new WindowEvent(WindowEvent.HIDE_AND_SHOW_NEXT_REQUEST));
	}

	private function onPrevBtnClick(event:MouseEvent):void {
		trace("next");
	}
	private function onNextBtnClick(event:MouseEvent):void {
		trace("previous");
	}

}
}
