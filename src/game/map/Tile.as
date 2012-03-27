/**
 * User: dima
 * Date: 16/02/12
 * Time: 12:18 PM
 */
package game.map {
import as3isolib.display.IsoSprite;

import core.display.SceneSprite;
import core.layer.LayersENUM;

import flash.display.Sprite;

public class Tile {
	
	public var view:IsoSprite = new IsoSprite;
	
	public function Tile(x:Number, y:Number) {
		draw();
		view.moveTo(x,y,0);
	}

	/* temp */
	private function draw():void {
		if(!view.sprites){
			view.sprites = [];
		}
		view.sprites[0] = new Sprite;
		view.sprites[0].graphics.beginFill(0x0fadc3);
		view.sprites[0].graphics.drawRect(0, 0, TileMapController.TILE_WIDTH, TileMapController.TILE_WIDTH);
		view.sprites[0].graphics.endFill();
	}
}
}
