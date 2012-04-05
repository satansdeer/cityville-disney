package iface
{
	/**
	 * TerraformingPanel
	 * @author satansdeer
	 */
	import com.bit101.components.PushButton;
	
	import core.enum.WindowsENUM;
	import core.window.WindowManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

import game.map.MapsController;

import mouse.MouseManager;
	
	public class TerraformingPanel extends Sprite{
		
		private var _resizeMapButton:PushButton;
		private var _makeFogButton:PushButton;
		private var _saveButton:PushButton;
		
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
			_resizeMapButton.addEventListener(MouseEvent.CLICK, onResizeMapButtonClick);
			_makeFogButton = new PushButton(this, 4, 26, "fog");
			_makeFogButton.addEventListener(MouseEvent.CLICK, onFogButtonClick);
			_makeFogButton.width = 42;
			_saveButton = new PushButton(this, 4, 48, "save");
			_saveButton.width = 42;
			_saveButton.addEventListener(MouseEvent.CLICK,  onSaveMapButtonClick);
		}
		
		protected function onFogButtonClick(event:MouseEvent):void{
			MouseManager.instance.mode = MouseManager.FOG_MODE;
		}
		
		protected function onResizeMapButtonClick(event:MouseEvent):void{
			WindowManager.instance.showWindow(WindowsENUM.RESIZE_MAP_WINDOW);
		}

		private function onSaveMapButtonClick(event:MouseEvent):void {
			MapsController.instance.saveToServer();
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