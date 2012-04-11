package iface.panel
{
	/**
	 * ObjectsPanel
	 * @author satansdeer
	 */
	import com.bit101.components.PushButton;
	
	import core.component.panel.HorizontalScrollablePanel;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;

	public class ObjectsPanel extends HorizontalScrollablePanel{
		
		protected var leftButton:PushButton;
		protected var rightButton:PushButton;
		
		private var loader:URLLoader;
		
		public function ObjectsPanel(panelWidth:Number, panelHeight:Number)
		{
			super(panelWidth, panelHeight);
			drawButtons();
			drawMask();
		}
		
		protected function drawButtons():void {
			leftButton = new PushButton(this, 0, 0, "<");
			rightButton = new PushButton(this, panelWidth - 32, 0, ">");
			leftButton.width = 32;
			leftButton.height = panelHeight;
			leftButton.addEventListener(MouseEvent.CLICK, onLeftClick);
			rightButton.width = 32;
			rightButton.height = panelHeight;
			rightButton.addEventListener(MouseEvent.CLICK, onRightClick);
		}
		
		override protected function drawMask():void{
			itemsMask = new Sprite();
			itemsMask.graphics.beginFill(0x000000);
			itemsMask.graphics.drawRect(leftButton.width, 0, panelWidth - 64, panelHeight);
			itemsMask.graphics.endFill();
			addChild(itemsMask);
			itemsMask.visible = false;
		}
		
		override protected function isVisible(item:Sprite):Boolean{
			return (item.width + spacing) * (items.length -1) + 40 < panelWidth;
		}

		protected function onLeftClick(event:MouseEvent):void{
			scrollLeft();
		}
		
		protected function onRightClick(event:MouseEvent):void{
			scrollRight();
		}
	}
}