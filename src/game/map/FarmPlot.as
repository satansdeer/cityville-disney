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
import core.event.AssetEvent;

import flash.events.Event;

import flash.events.MouseEvent;

import game.crafting.PlotVO;
import game.model.UserSession;

import game.vo.MapObjectVO;

import rpc.GameRpc;


public class FarmPlot extends MapObject {

	private var _plotVo:PlotVO;
	private var _assetsLoadedCount:int = 0;


	private static const URLS:Array = ["assets/plot/plot_1.png", "assets/plot/plot_2.png", "assets/plot/plot_3.png", "assets/plot/plot_4.png"];

	public static function create(controller:ObjectsMap):FarmPlot {
		var vo:MapObjectVO = new MapObjectVO();
		vo.length = 2;
		vo.width = 2;
		vo.offsetY = -40;
		vo.offsetX = -40;
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
	override protected function onAssetLoaded(event:AssetEvent):void {
		trace("asset loaded : " + event.url + " [FarmPlot.onAssetLoaded]");
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
		isoSprite.container.addChild(img);
	  //_controller.scene.render(true);
	}

	private function updateAsset():void {
		var url:String;
		if (_plotVo.completed) { url = URLS[URLS.length-1];
		} else if (_plotVo._timeLeft == 0) {
			url = URLS[0];
		} else {
			trace("plot url : " + (3 - int(_plotVo._timeLeft/5000 * 2)) + " [FarmPlot.updateAsset]");
			url = URLS[3 - int(_plotVo._timeLeft/5000 * 2)-1];
		}
		trace("vo url : " + vo.url + ", url : " + url + " [FarmPlot.updateAsset]");
		if (vo.url != url) {
			vo.url = url;
			setAsset();
		}

	}

	override protected function addListeners():void {
		img.addEventListener(MouseEvent.CLICK, onClick);
	}
	protected function removeListeners():void {
		img.removeEventListener(MouseEvent.CLICK, onClick);
	}


	private function onStateChange(event:Event):void {
		if (_assetsLoadedCount == URLS.length) {
			updateAsset();
		}
	}

	private function onClick(event:MouseEvent):void {
		if (!_plotVo.completed && _plotVo._timeLeft == 0) {
			GameRpc.instance.plantPlot();
		} else if (_plotVo.completed) {
			GameRpc.instance.getPlotProfit();
			_plotVo.completed = true;
			updateAsset();
		}
	}

}
}
