package iface.windows
{
	/**
	 * ResizeMapWindow
	 * @author satansdeer
	 */
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	
	import core.window.IScreenWindow;
	import core.window.WindowBase;
	import core.window.WindowManager;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.map.GroundMap;
	import game.map.MapsController;
	
	import org.casalib.util.StageReference;
	
	public class ResizeMapWindow extends WindowBase implements IScreenWindow{
		
		private var background:Window;
		
		private var _stage:Stage;
		
		private var _widthInput:InputText;
		private var _lengthInput:InputText;
		
		private var _okButton:PushButton;
		
		private var _mapWidth:int;
		private var _mapLength:int;
		
		public function ResizeMapWindow()
		{
			super();
			background = new Window(this, 0,0, "Resize window");
			background.hasCloseButton = true;
			background.addEventListener(Event.CLOSE, onClose);
			background.width = 96;
			background.height = 66;
			_widthInput = new InputText(background, 4, 4, "width");
			_widthInput.width = 42;
			_widthInput.addEventListener(MouseEvent.CLICK , onWidthClick);
			_widthInput.addEventListener(Event.CHANGE, onWidthChange);
			_lengthInput = new InputText(background, 50, 4, "length");
			_lengthInput.width = 42;
			_lengthInput.addEventListener(MouseEvent.CLICK, onHeightClick);
			_lengthInput.addEventListener(Event.CHANGE, onLengthChange);
			_okButton = new PushButton(background, 4, 22, "ok");
			_okButton.width = 88;
			_okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			_stage = StageReference.getStage();
			center();
		}
		
		protected function onOkClick(event:MouseEvent):void{
			MapsController.instance.setSize(_mapWidth, _mapLength);
			WindowManager.instance.hideCurrentWindow();
		}
		
		protected function onWidthChange(event:Event):void{
			_mapWidth = int(_widthInput.text);
		}
		
		protected function onLengthChange(event:Event):void{
			_mapLength = int(_lengthInput.text);
		}
		
		protected function onHeightClick(event:MouseEvent):void{
			_lengthInput.text = "";
			if(_mapWidth == 0){
				_widthInput.text = "width";
			}
		}
		
		protected function onWidthClick(event:MouseEvent):void{
			_widthInput.text = "";
			if(_mapLength == 0){
				_lengthInput.text = "length";
			}
		}
		
		protected function onClose(event:Event):void{
			WindowManager.instance.hideCurrentWindow();
		}
		
		private function center():void {
			x = _stage.stageWidth/2 - width/2;
			y = _stage.stageHeight/2 - height/2;
		}
	}
}