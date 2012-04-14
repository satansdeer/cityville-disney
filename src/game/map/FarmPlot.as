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

	private var _vo:PlotVO;

	public static function create(controller:ObjectsMap):FarmPlot {
		var vo:MapObjectVO = new MapObjectVO();
		vo.length = 2;
		vo.width = 2;
		vo.offsetY = -40;
		vo.offsetX = -40;
		vo.name = "farm plot";
		vo.url = "assets/plot/plot_1.png";
		return new FarmPlot(vo, controller);
	}

	public function FarmPlot(vo:MapObjectVO, controller:ObjectsMap) {
		super(vo, controller);
		_vo = UserSession.instance.plot;
	}

	override public function init():void{
		if(!isoSprite){
			isoSprite = new IsoSprite();
			isoSprite.setSize(vo.width * Main.UNIT_SIZE,vo.length * Main.UNIT_SIZE, 1);
			isoSprite.moveTo(x * Main.UNIT_SIZE, y * Main.UNIT_SIZE, 0);
			isoSprite.data = {x:x, y:y}
			if(AssetManager.getImageByURL(vo.url)){
				img = new InteractivePNG(AssetManager.getImageByURL(vo.url));
				isoSprite.container.addChild(img);
				img.x = vo.offsetX;
				img.y = vo.offsetY;
				addListeners();
			}else{
				AssetManager.load(vo.url);
				AssetManager.instance.addEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
				preloader = new MapObjectPreloader(vo.width, vo.length);
				isoSprite.container.addChild(preloader);
			}
		}
	}
	override protected function onAssetLoaded(event:AssetEvent):void {
		if(vo.url == event.url){
			AssetManager.instance.removeEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
			img = new InteractivePNG(AssetManager.getImageByURL(vo.url));
			isoSprite.container.addChild(img);
			img.x = vo.offsetX;
			img.y = vo.offsetY;
			addListeners();
			if(preloader && isoSprite.container.contains(preloader)){
				isoSprite.container.removeChild(preloader);
				preloader = null;
			}
		}
	}

	override protected function addListeners():void {
		img.addEventListener(MouseEvent.CLICK, onClick);
	}

	private function onStateChange(event:Event):void {

	}

	private function onClick(event:MouseEvent):void {
		if (!_vo.completed && _vo._timeLeft == 0) {
			GameRpc.instance.plantPlot();
		} else if (_vo.completed) {
			GameRpc.instance.getPlotProfit();
		}
	}

}
}
