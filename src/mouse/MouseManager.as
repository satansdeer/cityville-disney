package mouse
{
	/**
	 * MouseManager
	 * @author satansdeer
	 */
	import com.bit101.components.Label;
	
	import core.display.InteractivePNG;
	import core.layer.LayersENUM;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.ui.Mouse;
	
	import org.casalib.util.StageReference;
	
	import ru.beenza.framework.layers.LayerManager;
	
	public class MouseManager extends EventDispatcher{
		
		public static const FOG_MODE:String = "fog_mode";
		public static const NORMAL_MODE:String = "normal_mode";
		public static const REMOVE_MODE:String = "remove_mode";
		public static const MOVE_MODE:String = "move_mode";
		public static const UPGRADE_MODE:String = "upgrade_mode";

		private const REMOVE_ICON:Sprite = new DeleteCursor_view();
		private const UPGRADE_ICON:Sprite = new UpgradeCursor_view();
		
		private static var _instance:MouseManager;
		private var _cursorContainer:Sprite;
		
		private var _img:InteractivePNG;
		private var stage:Stage;
		
		public var data:Object;
		
		public var moved:Boolean;
		
		private var _mode:String = NORMAL_MODE;
		
		private var _hint:Hint_view;
		private var _icon:Sprite;
		private var _labelBack:Sprite;
		
		public function MouseManager(target:IEventDispatcher=null) {
			super(target);
			_cursorContainer = LayerManager.getLayer(LayersENUM.CURSOR);
			_hint = new Hint_view();
			_hint.visible = false;
			_hint.contentTxt.autoSize = TextFieldAutoSize.LEFT;
			_cursorContainer.addChild(_hint);
			stage = StageReference.getStage();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void{
		}
		
	public function set mode(value:String):void{
			if(_mode == value){ return; }
			_mode = value;
			if (_icon && _cursorContainer.contains(_icon)) {
				_cursorContainer.removeChild(_icon);
			}
			switch (_mode) {
				case REMOVE_MODE :
					_icon = REMOVE_ICON;
					_cursorContainer.addChild(_icon);
					break;
				case UPGRADE_MODE :
					_icon = UPGRADE_ICON;
					_cursorContainer.addChild(_icon);
					break;
			}
			correctIconPos();
		}
		
		public function get mode():String{
			return _mode;
		}
		
		protected function onMouseUp(event:MouseEvent):void{
			moved = false;
			img = null;
			data = null;
		}
		
		protected function onMouseDown(event:MouseEvent):void{
			moved = false;
		}
		
		protected function onMouseMove(event:MouseEvent):void{
			moved = true;
			if (_mode != NORMAL_MODE) {
				correctIconPos();
			}
			if (_hint.visible) { correctHintPos(); }
		}

		private function correctIconPos():void {
			_icon.x = stage.mouseX + 20;
			_icon.y = stage.mouseY + 20;
		}
		private function correctHintPos():void {
			if (stage.mouseX > Main.APP_WIDTH - _hint.width) {
				_hint.x = stage.mouseX - 10 - _hint.width;
			} else {
				_hint.x = stage.mouseX + 10;
			}
			if (stage.mouseY > Main.APP_HEIGHT - _hint.height) {
				_hint.y = stage.mouseY - 10 - _hint.height;
			} else {
				_hint.y = stage.mouseY + 10;
			}
		}
		
		public static function get instance():MouseManager{
			if(!_instance){
				_instance = new MouseManager();
			}
			return _instance;
		}
		
		public function get img():InteractivePNG{
			return _img;
		}
		
		public function set img(value:InteractivePNG):void{
			if(value){
				removeOldImg();
				_img = value;
				LayerManager.getLayer(LayersENUM.CURSOR).addChild(_img);
				_img.scaleX = 0.25;
				_img.scaleY = 0.25;
				_img.x = stage.mouseX - _img.width/2;
				_img.y = stage.mouseY - _img.height/2;
				_img.startDrag();
				_img.mouseEnabled = false;
			}else{
				if(_img && LayerManager.getLayer(LayersENUM.CURSOR).contains(img)){
					LayerManager.getLayer(LayersENUM.CURSOR).removeChild(_img);
					_img.stopDrag();
				}
			}
		}
		
		private function removeOldImg():void {
			if(_img){
				if(LayerManager.getLayer(LayersENUM.CURSOR).contains(_img)){
					_img.stopDrag();
					LayerManager.getLayer(LayersENUM.CURSOR).removeChild(_img);
					_img = null;
				}
			}
		}
		
		public static function hideHint():void {
			//if(instance.mode == NORMAL_MODE){
				instance._hint.visible = false;
			//}else{
			//	instance._label.text = instance.mode;
			//}
		}
		
		public static function showHint(hint:String):void {
			instance._hint.visible = true;
			instance._hint.contentTxt.text = hint;
			instance._hint.bg.width = instance._hint.contentTxt.textWidth + 23;
			instance._hint.bg.height = instance._hint.contentTxt.height + 20;
			instance.correctHintPos();
		}
	}
}