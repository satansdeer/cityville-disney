package iface.panel
{
	/**
	 * ActionButtonsPanel
	 * @author satansdeer
	 */
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mouse.MouseManager;
	
	public class ActionButtonsPanel extends Sprite{
		
		private var _removeButton:PushButton;
		private var _normalButton:PushButton;
		private var _moveButton:PushButton;
		
		private var _background:Sprite;
		private var _backgroundWidth:int = 150;
		
		public function ActionButtonsPanel()
		{
			super();
			drawBackground();
			addButtons();
		}
		
		public function get backgroundWidth():int{
			return _backgroundWidth;
		}
		
		private function drawBackground():void{
			_background = new Sprite();
			_background.graphics.beginFill(0x888888);
			_background.graphics.drawRoundRect(0, 0, _backgroundWidth, 40, 4);
			addChild(_background);
		}
		
		private function addButtons():void{
			_removeButton = new PushButton(this, 8, 8, "remove");
			_removeButton.width = 43;
			_removeButton.addEventListener(MouseEvent.CLICK, onRemoveClick);
			_normalButton = new PushButton(this, 53, 8, "normal");
			_normalButton.width = 43;
			_normalButton.addEventListener(MouseEvent.CLICK, onNormalClick);
			_moveButton = new PushButton(this, 98, 8, "move");
			_moveButton.width = 43;
			_moveButton.addEventListener(MouseEvent.CLICK, onMoveClick);
		}	
		
		protected function onMoveClick(event:MouseEvent):void{
			MouseManager.instance.mode = MouseManager.MOVE_MODE;
		}
		
		protected function onNormalClick(event:MouseEvent):void{
			MouseManager.instance.mode = MouseManager.NORMAL_MODE;
		}
		
		protected function onRemoveClick(event:MouseEvent):void{
			MouseManager.instance.mode = MouseManager.REMOVE_MODE;
		}
	}
}