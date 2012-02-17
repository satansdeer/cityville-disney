/**
 * User: dima
 * Date: 13/02/12
 * Time: 4:56 PM
 */
package game.panel {

import core.display.SceneSprite;

public class ScrollablePanel extends PanelBase {
	private var _panelWidth:Number;
	private var _panelHeight:Number;

	public function ScrollablePanel(width:Number, height:Number) {
		super();
		_panelHeight = height;
		_panelWidth = width;
	}

	public function get panelWidth() { return _panelWidth; }
	public function get panelHeight() { return _panelHeight; }

	override public function addComponent(component:SceneSprite, x:Number, y:Number):void {
		super.addComponent(component, x, y);
		if (componentOutside(component)) { showScroll(); }
	}

	override public function removeComponent(component:SceneSprite):void {
		super.removeComponent(component);
		if (!componentOutside(component)) { hideScroll(); }
	}

	/* Internal functions */

	protected function showScroll():void {}
	protected function hideScroll():void {}

	protected function componentOutside(component:SceneSprite):Boolean {
		return false;
	}
}
}
