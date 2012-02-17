package core.windows {
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	
	public class WindowManagerBase extends EventDispatcher {
		
		protected const registeredWindows:Dictionary = new Dictionary();
		protected const queue:Vector.<WindowBase> = new Vector.<WindowBase>();
		
		protected var currentWindow:WindowBase;
		
		protected var _layer:Sprite;
		
		public function WindowManagerBase() {
		}
		
		protected function register(name:String, window:WindowBase):void {
			registeredWindows[name] = window;
			window.addEventListener(WindowEvent.HIDE_AND_SHOW_NEXT_REQUEST, onHideWindow);
			window.addEventListener(WindowEvent.JUST_HIDE_REQUEST, onHideWindow);
		}
		
		protected function show(window:WindowBase):void {
			if (window is IScreenWindow) {
				forceShow(window);
			} else {
				scheduleShow(window);
			}
		}
		
		private function onHideWindow(event:WindowEvent):void {
			const window:WindowBase = event.target as WindowBase;
			if (window == currentWindow) {
				hideCurrentWindow();
				if (event.type == WindowEvent.HIDE_AND_SHOW_NEXT_REQUEST) {
					showNextInQueue();
				}
			}
		}
		
		protected function hideCurrentWindow():void {
			if (currentWindow && currentWindow.view.parent) {
				if (layer.contains(currentWindow.view)) {
					currentWindow.dispatchEvent(new WindowEvent(WindowEvent.ABOUT_TO_HIDE));
					layer.removeChild(currentWindow.view);
				}
				currentWindow = null;
			}
		}
		
		protected function forceShow(window:WindowBase):void {
			
		}
		
		protected function scheduleShow(window:WindowBase):void {
			if (currentWindow is IInformerWindow) {
				if (window is IInformerWindow) {
					queue.push(window);
				} else if (window is IScreenWindow) {
					queue.unshift(window);
				}
			} else {
				queue.push(window);
			}
		}
		
		public function showNextInQueue():void {
			
		}
		
		public function get layer():Sprite { return _layer }
		
	}
	
}
