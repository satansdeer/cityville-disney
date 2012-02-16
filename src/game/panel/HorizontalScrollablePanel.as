/**
 * User: dima
 * Date: 16/02/12
 * Time: 12:49 PM
 */
package game.panel {
import game.SceneSprite;

public class HorizontalScrollablePanel extends ScrollablePanel{
	public function HorizontalScrollablePanel(width:Number, height:Number) {
		super(width, height);
	}

	override protected function componentOutside(component:SceneSprite):Boolean {
		return (component.x < 0 || component.x + component.width > panelWidth);
	}

	override protected function showScroll():void {}
	override protected function hideScroll():void {}

}
}
