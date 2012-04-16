/**
 * Created by : Dmitry
 * Date: 4/11/12
 * Time: 10:11 PM
 */
package game.map {
import as3isolib.display.IsoSprite;

import core.component.MapObjectPreloader;

import core.display.AssetManager;
import core.display.InteractivePNG;
import core.enum.WindowsENUM;
import core.event.AssetEvent;
import core.event.WindowEvent;
import core.window.WindowManager;

import flash.events.Event;

import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import game.crafting.PlotVO;
import game.model.UserSession;

import game.vo.MapObjectVO;

import iface.windows.StoreWindow;

import rpc.GameRpc;


public class FarmPlot extends MapObject {

	private var _plotVo:PlotVO;
	private var _assetsLoadedCount:int = 0;

	private const GLOW_FILTER:GlowFilter = new GlowFilter(0xffffff);

	public static const URLS:Array = ["assets/plot/plot_1.png", "assets/plot/plot_2.png", "assets/plot/plot_3.png", "assets/plot/plot_4.png"];

	public static function create(controller:ObjectsMap):FarmPlot {
		var vo:MapObjectVO = new MapObjectVO();
		vo.length = 3;
		vo.width = 3;
		vo.offsetY = -270;
		vo.offsetX = -270;
		vo.name = "farm plot";
		//vo.url = URLS[0];
		return new FarmPlot(vo, controller);
	}

	public function FarmPlot(vo:MapObjectVO, controller:ObjectsMap) {
		super(vo, controller);
		_plotVo = UserSession.instance.plot;
		UserSession.instance.addEventListener(Event.CHANGE, onStateChange);
	}

	override public function init():void{
		if(!isoSprite){
			isoSprite = new IsoSprite();
			isoSprite.container.mouseEnabled = false;
			isoSprite.setSize(vo.width * Main.UNIT_SIZE,vo.length * Main.UNIT_SIZE, 1);
			isoSprite.moveTo(x * Main.UNIT_SIZE, y * Main.UNIT_SIZE, 0);
			isoSprite.data = {x:x, y:y}

			AssetManager.instance.addEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
			for (var i:int = 0; i < URLS.length; ++i) {
				AssetManager.load(URLS[i]);
			}
			//preloader = new MapObjectPreloader(vo.width, vo.length);
			//isoSprite.container.addChild(preloader);
		}
	}

	public function plantIfCan():void {
		if (!_plotVo.completed && _plotVo._timeLeft == 0) {
			GameRpc.instance.plantPlot();
		}
	}

	override protected function onAssetLoaded(event:AssetEvent):void {
		if(URLS.indexOf(event.url) != -1 ){
			_assetsLoadedCount++;
			if (_assetsLoadedCount == URLS.length) {
				trace("try set asset [FarmPlot.onAssetLoaded]");
				AssetManager.instance.removeEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
				updateAsset();
			}
		}
	}

	private function setAsset():void {
		if (img && isoSprite.container.contains(img)) {
			removeListeners();
			isoSprite.container.removeChild(img);
		}
		img = new InteractivePNG(AssetManager.getImageByURL(vo.url));
		addListeners();
		trace("add child [FarmPlot.setAsset]");
		img.x = vo.offsetX;
		img.y = vo.offsetY;
		isoSprite.container.addChild(img);
	  //_controller.scene.render(true);
	}

	private function updateAsset():void {
		var url:String;
		if (_plotVo.completed) { url = URLS[URLS.length-1];
		} else if (_plotVo._timeLeft == 0) {
			url = URLS[0];
		} else {
			url = URLS[3 - int(_plotVo._timeLeft/5000 * 2)-1];
		}
		if (vo.url != url) {
			vo.url = url;
			setAsset();
		}

	}

	override protected function addListeners():void {
		img.addEventListener(MouseEvent.CLICK, onClick);
		img.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		img.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}
	protected function removeListeners():void {
		img.removeEventListener(MouseEvent.CLICK, onClick);
		img.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		img.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}


	private function onStateChange(event:Event):void {
		if (_assetsLoadedCount == URLS.length) {
			updateAsset();
		}
	}

	private function onClick(event:MouseEvent):void {
		if (!_plotVo.completed && _plotVo._timeLeft == 0) {
			var window:StoreWindow = WindowManager.instance.getWindow(WindowsENUM.STORE_WINDOW) as StoreWindow;
			window.setTab(StoreWindow.FARM_TAB);
			WindowManager.instance.showWindow(WindowsENUM.STORE_WINDOW);
		} else if (_plotVo.completed) {
			GameRpc.instance.getPlotProfit();
			_plotVo.completed = true;
			updateAsset();
		}
	}

	private function onMouseOver(event:MouseEvent):void {
		if (_plotVo._timeLeft == 0) {
			img.filters = [GLOW_FILTER];
		}
	}
	private function onMouseOut(event:MouseEvent):void {
		img.filters = [];
	}

}
}
