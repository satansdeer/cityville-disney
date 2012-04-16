/**
 * Created by : Dmitry
 * Date: 4/15/12
 * Time: 11:17 AM
 */
package game.map {
import as3isolib.display.IsoSprite;

import core.component.MapObjectPreloader;

import core.display.AssetManager;
import core.display.InteractivePNG;
import core.enum.WindowsENUM;
import core.event.AssetEvent;
import core.window.WindowManager;

import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import game.events.CastleEvent;

import game.vo.MapObjectVO;

import mouse.MouseManager;

public class Castle extends MapObject {


	private const GLOW_FILTER:GlowFilter = new GlowFilter(0xffffff);
	private static const URLS:Array = ["assets/Buildings/castle.png", "assets/Buildings/castle-down.png"];
	private var _assetsLoadedCount:int = 0;

	public static function create(controller:ObjectsMap):Castle {
		var vo:MapObjectVO = new MapObjectVO();
		vo.length = 8;
		vo.width = 9;
		vo.offsetY = -80;
		vo.offsetX = -160;
		vo.name = "castle";
		vo.url = URLS[1];
		return new Castle(vo, controller);
	}

	public function Castle(vo:MapObjectVO, controller:ObjectsMap) {
		super(vo, controller);
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

			preloader = new MapObjectPreloader(vo.width, vo.length);
			isoSprite.container.addChild(preloader);
		}
	}

	override protected function addListeners():void {
		img.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		img.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		img.addEventListener(MouseEvent.CLICK, onClick);
	}

	override protected function onAssetLoaded(event:AssetEvent):void{
		if(URLS.indexOf(event.url) != -1 ){
			_assetsLoadedCount++;
			if (_assetsLoadedCount == URLS.length) {
				trace("try set asset [FarmPlot.onAssetLoaded]");
				AssetManager.instance.removeEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
				if(preloader && isoSprite.container.contains(preloader)){
					isoSprite.container.removeChild(preloader);
					preloader = null;
				}
				setImg();
			}
		}
	}

	private function removeImg():void {
		//remove listeners please
		if (isoSprite.container.contains(img)) {
			isoSprite.container.removeChild(img);
		}
	}

	private function setImg():void {
		img = new InteractivePNG(AssetManager.getImageByURL(vo.url), false);
		isoSprite.container.addChild(img);
		img.scaleX = 0.5;
		img.scaleY = 0.5;
		img.x = vo.offsetX;
		img.y = vo.offsetY;
		addListeners();
	}

	private function onMouseOver(event:MouseEvent):void {
		MouseManager.instance.mode = MouseManager.UPGRADE_MODE;
		img.filters = [GLOW_FILTER];
		MouseManager.showHint("          Upgrade castle", true);
	}
	private function onMouseOut(evnent:MouseEvent):void {
		MouseManager.instance.mode = MouseManager.NORMAL_MODE;
		img.filters = [];
		MouseManager.hideHint();
	}

	private function onClick(event:MouseEvent):void {
		dispatchEvent(new CastleEvent());
		removeImg();
		if (vo.url == URLS[0]) {
			vo.url = URLS[1];
		} else {
			vo.url = URLS[0];
		}
		setImg();
	}
}
}
