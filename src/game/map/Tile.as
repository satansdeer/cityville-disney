/**
 * User: dima
 * Date: 16/02/12
 * Time: 12:18 PM
 */
package game.map {
import as3isolib.display.IsoSprite;
import as3isolib.display.scene.IsoScene;

import core.component.MapObjectPreloader;
import core.display.AssetManager;
import core.display.InteractivePNG;
import core.display.SceneSprite;
import core.event.AssetEvent;
import core.layer.LayersENUM;

import flash.display.Sprite;

public class Tile {
	
	public var shown:Boolean = false;
	
	private var _x:int;
	private var _y:int;
	private var _url:String;
	private var _scene:IsoScene;
	private var _preloader:MapObjectPreloader;
	
	private var img:InteractivePNG;
	
	public var sprite:Sprite;

	public static const TILE_URLS:Array = ["assets/tile/land_01.png", "assets/tile/land_02.png", "assets/tile/land_03.png",
																					"assets/tile/land_04.png", "assets/tile/land_05.png"];
	
	public function Tile(x:Number, y:Number, url:String) {
		_x = x;
		_y = y;
		_url = url;
	}
	
	public function get x():int{
		return _x;
	}
	
	public function get y():int{
		return _y;
	}

	public function get url():String { return _url; }
	
	public function remove():void{
		AssetManager.instance.removeEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
	}
	
	public function draw():void{
		sprite = new Sprite();
		//sprite.width = Main.TILE_SIZE;
		//sprite.height = Main.TILE_SIZE;
		//sprite.x = _x;
		//sprite.y = _y;
		//sprite.data = {x:_x, y:_y}
		if(AssetManager.getImageByURL(_url)){
			setImg();
		}else{
			AssetManager.load(_url);
			AssetManager.instance.addEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
			_preloader = new MapObjectPreloader(1, 1);
			_preloader.x = Main.TILE_SIZE;
			sprite.addChild(_preloader);
		}
	}
	
	protected function onAssetLoaded(event:AssetEvent):void{
		if(_url == event.url){
			AssetManager.instance.removeEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
			setImg();
			if(_preloader && sprite.contains(_preloader)){
				sprite.removeChild(_preloader);
				_preloader = null;
			}
		}
	}
	
	private function setImg():void{
		img = new InteractivePNG(AssetManager.getImageByURL(_url));
		img.cacheAsBitmap = true;
		img.mouseEnabled = false;
		sprite.addChild(img);
	}

}
}
