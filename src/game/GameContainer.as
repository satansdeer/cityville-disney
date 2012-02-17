/**
 * User: dima
 * Date: 10/02/12
 * Time: 5:18 PM
 */
package game {
import core.display.SceneSprite;

import flash.display.Sprite;

import core.layer.Layer;
import core.layer.Layers;
import game.tower.TowerBase;

public class GameContainer {
	private var layerList:Vector.<Layer>;

	public function GameContainer(mainContainer:Sprite) {
		createLayers();
		for each (var sceneLayer:Layer in layerList) {
			mainContainer.addChild(sceneLayer);
		}
	}

	public function addChild(child:SceneSprite):void {
		var sceneLayer:Layer = getLayer(child.layerType);
		if (sceneLayer) {
			sceneLayer.addChild(child);
		}
	}

	public function removeChild(child:SceneSprite):void {
		var sceneLayer:Layer = getLayer(child.layerType);
		if (sceneLayer && sceneLayer.contains(child)) {
			sceneLayer.removeChild(child);
		}
	}

	/* Internal functions */

	private function createLayers():void {
		layerList = new Vector.<Layer>();
		layerList.push(new Layer(Layers.MAP));
		layerList.push(new Layer(Layers.TOWERS));
		layerList.push(new Layer(Layers.MAIN));
		layerList.push(new Layer(Layers.ICON));
		layerList.push(new Layer(Layers.WINDOWS));
	}

	private function getLayer(layerType:uint):Layer {
		for each (var sceneLayer:Layer in layerList) {
			if (sceneLayer.type == layerType) { return sceneLayer; }
		}
		return null;
	}
}
}
