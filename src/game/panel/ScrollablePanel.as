/**
 * User: dima
 * Date: 13/02/12
 * Time: 4:56 PM
 */
package game.panel {

import game.SceneSprite;

public class ScrollablePanel extends PanelBase {
	private var _panelWidth:Number;
	private var _panelHeight:Number;

	public function ScrollablePanel(width:Number, height:Number) {
		super();
		_panelHeight = height;
		_panelWidth = width;
	}

	override public function addComponent(component:SceneSprite, x:Number, y:Number):void {
		super.addComponent(component, x, y);
		if (componentOutsideByX(component)) { showHorizontalScroll(); }
		if (componentOutsideByY(component)) { showVerticalScroll(); }
	}

	/* Internal functions */

	private function showVerticalScroll():void {

	}

	private function hideVerticalScroll():void {

	}

	private function showHorizontalScroll():void {

	}
	private function hideHorizontalScroll():void {

	}

	private function componentOutsideByX(component:SceneSprite):Boolean {
		return (component.x < 0 || component.x + component.width > _panelWidth);
	}

	private function componentOutsideByY(component:SceneSprite):Boolean {
		return (component.y< 0 || component.y + component.height > _panelHeight);
	}
}
}
