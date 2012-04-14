/**
 * User: dima
 * Date: 10/04/12
 * Time: 2:05 PM
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

import game.collector.ObjectsCollector;
import game.map.FarmPlot;
import game.map.MapsController;
import game.vo.MapObjectVO;

import mouse.MouseManager;

public class StoreWindow  extends WindowBase implements IScreenWindow{
	private var _view:Store_view;

	private var _page:int;
	private var _objectVOs:Vector.<MapObjectVO>;
	private var _tab:uint;
	private var _farmItem:PanelItem;

	public static const BUILD_TAB:uint = 0;
	public static const FARM_TAB:uint = 1;

	private const ITEMS_NUM:int = 8;

	public function StoreWindow() {
		super();
		_view = new Store_view();
		_view.x = Main.APP_WIDTH/2 - _view.width/2;
		_view.y = Main.APP_HEIGHT/2 - _view.height/2;
		_tab = BUILD_TAB;
		addChild(_view);
		init();
		addListeners();
		ObjectsCollector.instance.addEventListener(Event.COMPLETE, onObjectsLoaded);
	}

	public function setTab(tabName:uint):void {
		_tab = tabName;
		updateItems();
	}

	private function init():void {
		_view.buildTab.bg.gotoAndStop(1);
		_view.farmTab.bg.gotoAndStop(2);
		for (var i:int = 1; i <= 8; ++i) {
			IfaceBtnWrapper.wrap(_view["item" + i].buyBtn);
			_view["item" + i].buyBtn.mouseChildren = false;
		}
	}

	private function updateItems():void {
		if (_tab == BUILD_TAB) {
			updateBuildItems();
		} else {
			updateFarmItems();
		}
	}

	private function updateBuildItems():void {
		var itemIndex:int;
		var panelItem:PanelItem;
		for (var i:int = _page * ITEMS_NUM; i < (_page+1)*ITEMS_NUM; ++i){
			itemIndex = (i - _page * ITEMS_NUM + 1);
			if (_view["item" + itemIndex]["photo"].numChildren > 0) { _view["item" + itemIndex]["photo"].removeChildAt(0); }
			if (i < _objectVOs.length) {
				panelItem = new PanelItem(_objectVOs[i]);
				_view["item" + itemIndex]["photo"].addChild(panelItem);
				_view["item" + itemIndex].visible = true;
			} else {
				_view["item" + itemIndex].visible = false;
			}
		}
		if (_page == 0) {
			_view.prevBtn.visible = false;
		} else { _view.prevBtn.visible = true; }
		if ((_page+1) * ITEMS_NUM >= _objectVOs.length) { _view.nextBtn.visible = false;
		} else { _view.nextBtn.visible = true; }
	}

	private function updateFarmItems():void {
		for (var i:int = 0; i < ITEMS_NUM; ++i) {
			if (_view["item" + (i+1)]["photo"].numChildren > 0) { _view["item" + (i+1)]["photo"].removeChildAt(0); }
			if (i > 0) { _view["item" + (i+1)].visible = false; }
		}
		if (!_farmItem) {
			var vo:MapObjectVO = new MapObjectVO();
			vo.url = FarmPlot.URLS[FarmPlot.URLS.length-1];
			vo.length = 2;
			vo.width = 2;
			_farmItem = new PanelItem(vo);
		}
		_view["item1"]["photo"].addChild(_farmItem);
	}

	private function addListeners():void {
		IfaceBtnWrapper.wrap(_view.closeBtn);
		IfaceBtnWrapper.wrap(_view.prevBtn);
		IfaceBtnWrapper.wrap(_view.nextBtn);
		IfaceBtnWrapper.wrap(_view.buildTab);
		IfaceBtnWrapper.wrap(_view.farmTab);
		_view.buildTab.addEventListener(MouseEvent.CLICK, onBuildTabClick);
		_view.farmTab.addEventListener(MouseEvent.CLICK, onFarmTabClick);

		_view.closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtnClick);
		for (var i:int = 1; i <= 8; ++i) {
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
		if (_tab == BUILD_TAB) {
			for (var i:int = 1; i <= 8; ++i) {
				if (event.target.parent == _view["item" + i]) {
					MouseManager.instance.mode = MouseManager.NORMAL_MODE;
					MouseManager.instance.img = new InteractivePNG(AssetManager.getImageByURL(_objectVOs[_page*ITEMS_NUM + i-1].url))
					MouseManager.instance.data = _objectVOs[_page*ITEMS_NUM + i-1];
					dispatchEvent(new WindowEvent(WindowEvent.JUST_HIDE_REQUEST));
					break;
				}
			}
		} else {
			MapsController.instance.plantPlot();
			dispatchEvent(new WindowEvent(WindowEvent.JUST_HIDE_REQUEST));
		}
	}

	private function onBuildTabClick(event:MouseEvent):void {
		if (_tab != BUILD_TAB) {
			_tab = BUILD_TAB;
			updateItems();
			_view.buildTab.bg.gotoAndStop(1);
			_view.farmTab.bg.gotoAndStop(2);
		}
	}
	private function onFarmTabClick(event:MouseEvent):void {
		if (_tab != FARM_TAB) {
			_tab = FARM_TAB;
			updateItems();
			_view.buildTab.bg.gotoAndStop(2);
			_view.farmTab.bg.gotoAndStop(1);
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
