/**
 * User: dima
 * Date: 10/04/12
 * Time: 2:05 PM
 */
package iface.windows {
import core.component.IfaceBtnWrapper;
import core.component.panel.PanelItem;
import core.event.WindowEvent;
import core.window.IScreenWindow;
import core.window.WindowBase;

import flash.events.Event;

import flash.events.MouseEvent;
import flash.ui.Mouse;

import game.collector.ObjectsCollector;
import game.vo.MapObjectVO;

public class StoreWindow  extends WindowBase implements IScreenWindow{
	private var _view:Store_view;

	private var _page:int;
	private var _objectVOs:Vector.<MapObjectVO>;

	private const ITEMS_NUM:int = 8;

	public function StoreWindow() {
		super();
		_view = new Store_view();
		_view.x = Main.APP_WIDTH/2 - _view.width/2;
		_view.y = Main.APP_HEIGHT/2 - _view.height/2;
		addChild(_view);
		init();
		addListeners();
		ObjectsCollector.instance.addEventListener(Event.COMPLETE, onObjectsLoaded);
	}

	private function init():void {
		_view.buildTab.bg.gotoAndStop(1);
		_view.farmTab.bg.gotoAndStop(2);
	}

	private function updateItems():void {
		var itemIndex:int;
		var panelItem:PanelItem;
		for (var i:int = _page * ITEMS_NUM; i < (_page+1)*ITEMS_NUM; ++i){
			itemIndex = (i - _page * ITEMS_NUM + 1);
			if (_view["item" + itemIndex]["photo"].numChildren > 0) { _view["item" + itemIndex]["photo"].removeChildAt(0); }
			if (i < _objectVOs.length) {
				panelItem = new PanelItem(_objectVOs[i]);
				_view["item" + itemIndex]["photo"].addChild(panelItem);
			}
		}
		if (_page == 0) {
			_view.prevBtn.visible = false;
		} else { _view.prevBtn.visible = true; }
		if ((_page+1) * ITEMS_NUM >= _objectVOs.length) { _view.nextBtn.visible = false;
		} else { _view.nextBtn.visible = true; }
	}

	private function addListeners():void {
		IfaceBtnWrapper.wrap(_view.closeBtn);
		IfaceBtnWrapper.wrap(_view.prevBtn);
		IfaceBtnWrapper.wrap(_view.nextBtn);
		_view.closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtnClick);
		for (var i:int = 1; i <= 8; ++i) {
			IfaceBtnWrapper.wrap(_view["item" + i].buyBtn);
			_view["item" + i].buyBtn.addEventListener(MouseEvent.CLICK, onItemClick);
		}
	}

	private function onObjectsLoaded(event:Event):void {
		_page = 0;
		_objectVOs = ObjectsCollector.instance.objectVOs;
		_view.prevBtn.addEventListener(MouseEvent.CLICK, onPrevBtnClick);
		_view.nextBtn.addEventListener(MouseEvent.CLICK, onNextBtnClick);
		updateItems();
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
		_page--;
		updateItems();
	}
	private function onNextBtnClick(event:MouseEvent):void {
		_page++;
		updateItems();
	}

}
}
