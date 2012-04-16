/**
 * Created by : Dmitry
 * Date: 4/15/12
 * Time: 11:17 AM
 */
package game.map {
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

	public static function create(controller:ObjectsMap):Castle {
		var vo:MapObjectVO = new MapObjectVO();
		vo.length = 8;
		vo.width = 9;
		vo.offsetY = -80;
		vo.offsetX = -160;
		vo.name = "castle";
		vo.url = "assets/Buildings/castle.png";
		return new Castle(vo, controller);
	}

	public function Castle(vo:MapObjectVO, controller:ObjectsMap) {
		super(vo, controller);
	}

	override protected function addListeners():void {
		img.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		img.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		img.addEventListener(MouseEvent.CLICK, onClick);
	}

	override protected function onAssetLoaded(event:AssetEvent):void{
		if(vo.url == event.url){
			AssetManager.instance.removeEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
			img = new InteractivePNG(AssetManager.getImageByURL(vo.url), false);
			isoSprite.container.addChild(img);
			img.scaleX = 0.5;
			img.scaleY = 0.5;
			img.x = vo.offsetX;
			img.y = vo.offsetY;
			addListeners();
			if(preloader && isoSprite.container.contains(preloader)){
				isoSprite.container.removeChild(preloader);
				preloader = null;
			}
		}
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
	}
}
}
