/**
 * User: dima
 * Date: 13/02/12
 * Time: 4:52 PM
 */
package game.panel {
import game.SceneSprite;
import game.layer.Layers;

public class PanelBase extends SceneSprite {
	private var components:Vector.<SceneSprite>;

	public function PanelBase():void {
		super(Layers.MAIN);
	}

	public function addComponent(component:SceneSprite, x:Number, y:Number):void {
		component.x = x;
		component.y = y;
		this.addChild(component);
	}

	public function removeComponent(component:SceneSprite):void {
		if (this.contains(component)) {
			this.removeChild(component);
		}
	}
}
}
