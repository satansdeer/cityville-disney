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
	
	import org.casalib.util.StageReference;
	
	import ru.beenza.framework.layers.LayerManager;

	/**
	 * Interface
	 * @author satansdeer
	 */
	public class GameInterface{
		
		private var stage:Stage;
		private var optionsButton:PushButton;
		
		private var _topPanelBackground:Sprite;
		
		private var _actionButtonsPanel:ActionButtonsPanel;
		private var _terraformingPanel:TerraformingPanel;
		
		private var _stage:Stage;
		
		private var fpsLabel:GameValueLabel;
		private var donateLabel:GameValueLabel;
		private var moneyLabel:GameValueLabel;
		private var foodLabel:GameValueLabel;
		private var woodLabel:GameValueLabel;
		private var peapleLabel:GameValueLabel;
		
		public function GameInterface()
		{
			_stage = StageReference.getStage();
			initLabels();
			drawTopPanel();
			initActionButtonsPanel();
			initTerraformingPanel();
			FpsMeter.instance.addEventListener(Event.CHANGE, onChange);
		}
		
		public function resize():void{
			_topPanelBackground.graphics.beginFill(0x888888);
			_topPanelBackground.graphics.drawRect(0, 0, _stage.stageWidth, 26);
			_topPanelBackground.graphics.endFill();
			_terraformingPanel.y = _stage.stageHeight/2 - _terraformingPanel.height/2;
		}
		
		protected function onChange(event:Event):void{
			fpsLabel.value = event.target.fps;
		}
		
		private function initTerraformingPanel():void {
			_terraformingPanel = new TerraformingPanel();
			_terraformingPanel.x = 4;
			_terraformingPanel.y = _stage.stageHeight/2 - _terraformingPanel.height/2;
			LayerManager.getLayer(LayersENUM.INTERFACE).addChild(_terraformingPanel);
		}
		
		private function initLabels():void {
			fpsLabel = new GameValueLabel("FPS", 40);
			fpsLabel.x = 4;
			fpsLabel.y = 4;
			fpsLabel.hint = "Current fps";
		}
		
		private function initActionButtonsPanel():void{
			_actionButtonsPanel = new ActionButtonsPanel();
			_actionButtonsPanel.x = _stage.stageWidth - _actionButtonsPanel.backgroundWidth - 32;
			_actionButtonsPanel.y = _stage.stageHeight - 100 - _actionButtonsPanel.height + 4;
			LayerManager.getLayer(LayersENUM.INTERFACE).addChild(_actionButtonsPanel);
		}
		
		private function drawTopPanel():void{
			_topPanelBackground = new Sprite();
			_topPanelBackground.graphics.beginFill(0x888888);
			_topPanelBackground.graphics.drawRect(0, 0, Main.APP_WIDTH, 26);
			_topPanelBackground.graphics.endFill();
			LayerManager.getLayer(LayersENUM.INTERFACE).addChild(_topPanelBackground);
			_topPanelBackground.addChild(fpsLabel);
		}
	}
}