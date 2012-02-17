/**
 * User: dima
 * Date: 13/02/12
 * Time: 4:52 PM
 */
package core.component.panel {
import core.display.SceneSprite;
import core.layer.Layers;

public class PanelBase extends SceneSprite {
	private var components:Vector.<SceneSprite>;

	public function PanelBase():void {
		super(Layers.MAIN);
	}

	public function addComponent(component:SceneSprite):void {
//		component.x = x;
//		component.y = y;
		//this.addChild(component);
		if (!components) { components = new Vector.<SceneSprite>(); }
		if (components.indexOf(component) == -1) { components.push(component); }
	}

	public function removeComponent(component:SceneSprite):void {
//		if (this.contains(component)) {
//			this.removeChild(component);
			var index:int = components.indexOf(component);
			if (index >= 0) { components.splice(index, 1); }
//		}
	}
}
}
