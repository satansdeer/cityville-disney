/**
 * User: dima
 * Date: 16/02/12
 * Time: 12:18 PM
 */
package game.map {
import game.SceneSprite;
import game.layer.Layers;

public class Tile extends SceneSprite {
	public function Tile(x:Number, y:Number) {
		super(Layers.MAP);
		draw();
		this.x = x;
		this.y = y;
	}

	/* temp */
	private function draw():void {
		this.graphics.beginFill(0x0fadc3);
		this.graphics.drawRect(0, 0, TileMapController.TILE_WIDTH, TileMapController.TILE_WIDTH);
		this.graphics.endFill();
	}
}
}
