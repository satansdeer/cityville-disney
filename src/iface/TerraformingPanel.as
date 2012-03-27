package iface
{
	/**
	 * TerraformingPanel
	 * @author satansdeer
	 */
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class TerraformingPanel extends Sprite{
		
		private var _resizeMapButton:PushButton;
		
		public function TerraformingPanel()
		{
			super();
			drawBackground();
			createButtons();
			addListeners();
		}
		
		private function createButtons():void {
			_resizeMapButton = new PushButton(this, 4,4, "resize");
			_resizeMapButton.width = 42;
		}
		
		private function addListeners():void {
		}
		
		private function drawBackground():void {
			graphics.beginFill(0x888888);
			graphics.drawRoundRect(0,0, 50, 200, 4);
			graphics.endFill();
		}
	}
}