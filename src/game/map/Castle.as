/**
 * Created by : Dmitry
 * Date: 4/15/12
 * Time: 11:17 AM
 */
package game.map {
import core.enum.WindowsENUM;
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
		vo.length = 4;
		vo.width = 4;
		vo.offsetY = -60;
		vo.offsetX = -80;
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

	private function onMouseOver(event:MouseEvent):void {
		MouseManager.instance.mode = MouseManager.UPGRADE_MODE;
		img.filters = [GLOW_FILTER];
	}
	private function onMouseOut(evnent:MouseEvent):void {
		MouseManager.instance.mode = MouseManager.NORMAL_MODE;
		img.filters = [];
	}

	private function onClick(event:MouseEvent):void {
		dispatchEvent(new CastleEvent());
	}
}
}
