package iface.components
{
	/**
	 * GameValueLabel
	 * @author satansdeer
	 */
	import com.bit101.components.Label;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mouse.MouseManager;
	
	public class GameValueLabel extends Sprite{
		
		private var _name:String;
		private var _value:int;
		
		private var _w:int;
		
		private var _nameLabel:Label;
		private var _valueLabel:Label;
		
		public var hint:String = new String();
		
		public function GameValueLabel(name:String, w:int)
		{
			super();
			_w = w;
			drawBackground()
			addLabels();
			addListeners();
		}
		
		private function addListeners():void {
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			MouseManager.hideHint();
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			MouseManager.showHint(hint);
		}
		
		private function addLabels():void {
			_nameLabel = new Label(this, 0,0,"LVL");
		}
		
		private function drawBackground():void {
			graphics.beginFill(0xCCCCCC);
			graphics.drawRoundRect(0,0,_w, 18, 4);
			graphics.endFill();
		}
	}
}