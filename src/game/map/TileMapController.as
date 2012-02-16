/**
 * User: dima
 * Date: 16/02/12
 * Time: 12:14 PM
 */
package game.map {
import game.GameContainer;

public class TileMapController {
	private var _width:Number;
	private var _height:Number;
	private var _container:GameContainer;

	private var tiles:Vector.<Tile>;

	public static const TILE_WIDTH:Number = 50;

	public function TileMapController(container:GameContainer, width:Number, height:Number) {
		_width = width;
		_height = height;
		_container = container;
	}

	/* API */

	public function drawBaseMap():void {
		var tile:Tile;
		for (var i:int = 0; i < _width; ++i) {
			for (var j:int = 0; j < _height; ++j) {
				tile = new Tile(i * TILE_WIDTH, j * TILE_WIDTH);
				addTileToList(tile);
				_container.addChild(tile);
			}
		}
	}

	/* Internal functions */

	private function addTileToList(tile:Tile):void {
		if (!tiles) { tiles = new Vector.<Tile>(); }
		tiles.push(tile);
	}
}
}
