package iface
{
	import com.bit101.components.FPSMeter;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	
	import core.FpsMeter;
	import core.layer.LayersENUM;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import iface.components.GameValueLabel;
import iface.panel.ActionButtonsPanel;
import iface.panel.GamePlayPanel;
import iface.panel.GamePlayPanel;
import iface.panel.GamePlayPanel;
import iface.panel.TerraformingPanel;
import iface.panel.WidgetsPanel;

import org.casalib.util.StageReference;
	
	import ru.beenza.framework.layers.LayerManager;

	/**
	 * Interface
	 * @author satansdeer
	 */
	public class GameInterface {
		private var _view:MainScene_view;
		
		private var _gamePlayPanel:GamePlayPanel;
		private var _widgetsPanel:WidgetsPanel;

		private var fpsLabel:GameValueLabel;

		public function GameInterface() {
			_view = new MainScene_view();
			LayerManager.getLayer(LayersENUM.INTERFACE).addChild(_view);
			initLabels();
			initPanels();
			FpsMeter.instance.addEventListener(Event.CHANGE, onChange);
		}
		
		protected function onChange(event:Event):void{
			fpsLabel.value = event.target.fps;
		}
		
		private function initLabels():void {
			fpsLabel = new GameValueLabel("FPS", 40);
			fpsLabel.x = 4;
			fpsLabel.y = 4;
			fpsLabel.hint = "Current fps";
		}
		
		private function initPanels():void{
			_gamePlayPanel = new GamePlayPanel(_view.menu);
			_widgetsPanel = new WidgetsPanel(_view.widgets);
		}

}
}