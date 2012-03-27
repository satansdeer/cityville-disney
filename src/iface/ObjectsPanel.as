package iface
{
	/**
	 * ObjectsPanel
	 * @author satansdeer
	 */
	import com.bit101.components.PushButton;
	
	import core.AppData;
	import core.component.panel.HorizontalScrollablePanel;
	import core.component.panel.PanelItem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import game.vo.MapObjectVO;
	
	public class ObjectsPanel extends HorizontalScrollablePanel{
		
		protected var leftButton:PushButton;
		protected var rightButton:PushButton;
		
		private var loader:URLLoader;
		
		public function ObjectsPanel(panelWidth:Number, panelHeight:Number)
		{
			super(panelWidth, panelHeight);
			drawButtons();
			drawMask();
			loadObjects();
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
		
		protected function loadObjects():void{
			var urlrequest:URLRequest = new URLRequest("data/objects.xml");
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(urlrequest);
		}
		
		protected function onComplete(event:Event):void{
			AppData.objects = new XML(event.target.data);
			var xml:XML = new XML(event.target.data);
			var objectVO:MapObjectVO;
			for (var i:int = 0; i < xml.object.length(); i++){
				objectVO = new MapObjectVO();
				objectVO.id = xml.object[i].@id;
				objectVO.name = xml.object[i].@name;
				objectVO.url = xml.object[i].@url;
				objectVO.length = xml.object[i].@length;
				objectVO.width = xml.object[i].@width;
				objectVO.offsetX = xml.object[i].@offsetX;
				objectVO.offsetY = xml.object[i].@offsetY;
				addItem(new PanelItem(objectVO));
			}
		}
		
		protected function onLeftClick(event:MouseEvent):void{
			scrollLeft();
		}
		
		protected function onRightClick(event:MouseEvent):void{
			scrollRight();
		}
	}
}