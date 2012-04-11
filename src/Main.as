/**
 * User: dima
 * Date: 10/02/12
 * Time: 1:59 PM
 */
package {
import core.enum.ScenesENUM;
import core.enum.WindowsENUM;
import core.layer.LayersENUM;
import core.window.WindowManager;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.system.Security;

import game.GameView;
import game.SceneController;
import game.collector.ObjectsCollector;
import game.map.MapsController;
import game.model.UserSession;

import iface.GameInterface;
import iface.panel.ObjectsPanel;
import iface.windows.ResizeMapWindow;
import iface.windows.StoreWindow;

import org.casalib.util.StageReference;

import rpc.GameRpc;

import ru.beenza.framework.layers.LayerManager;

[SWF(width=760, height=760, frameRate=45, backgroundColor="0xFFFFFF")]
public class Main extends Sprite {
	public static const APP_WIDTH:int = 760;
	public static const APP_HEIGHT:int = 760;
	public static const UNIT_SIZE:int = 32;
	
	private var sceneController:SceneController;

	private var _gameView:GameView;
	private var _mapsController:MapsController;
	
	private var _iface:GameInterface;
	
	public function Main() {
		trace("app started");
		Security.allowDomain("*");
		Security.allowInsecureDomain("*");
		//Security.allowDomain("http://www.mochiads.com/static/lib/services/");
		//MonsterDebugger.initialize(this);
		//flash.profiler.showRedrawRegions ( true, 0x0000FF );
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	/* Internal functions */

	private function addedToStageHandler(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

		GameRpc.instance.init("localhost", 8080);

		UserSession.instance.init();
		ObjectsCollector.instance.init();
		
			// stage settings
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		StageReference.setStage(stage);
		stage.addEventListener(Event.RESIZE, onStageResize);
		//stage.quality = StageQuality.LOW;
			//layers
		LayerManager.init();
		LayerManager.addLayer(LayersENUM.SCENE);
		LayerManager.addLayer(LayersENUM.ICONS);
		LayerManager.addLayer(LayersENUM.INTERFACE);
		LayerManager.addLayer(LayersENUM.WINDOWS);
		LayerManager.addLayer(LayersENUM.CURSOR);
		addChild(LayerManager.appLayer);
			//controllers
		initGameView();
		//initPanel();
		registerWindows();
		_iface = new GameInterface();
	}
	
	protected function onStageResize(event:Event):void{
		//_gameView.resize();
	}
	
	private function registerWindows():void {
		WindowManager.instance.layer = LayerManager.getLayer(LayersENUM.WINDOWS);
		WindowManager.instance.registerWindow(WindowsENUM.RESIZE_MAP_WINDOW, new ResizeMapWindow());
		WindowManager.instance.registerWindow(WindowsENUM.STORE_WINDOW, new StoreWindow());
	}
	
	private function initPanel():void {
		var panel:ObjectsPanel = new ObjectsPanel(APP_WIDTH, 100);
		LayerManager.getLayer(LayersENUM.INTERFACE).addChild(panel);
		panel.y = APP_HEIGHT - panel.height;
	}
	
	private function initGameView():void {
		_gameView = new GameView(UNIT_SIZE);
		_gameView.addSceneWithName(ScenesENUM.BACKGROUND);
		_gameView.addSceneWithName(ScenesENUM.GROUND);
		_gameView.addSceneWithName(ScenesENUM.ROAD_1);
		_gameView.addSceneWithName(ScenesENUM.ROAD_2);
		_gameView.addSceneWithName(ScenesENUM.GRID);
		_gameView.addSceneWithName(ScenesENUM.OBJECTS);
		_gameView.addSceneWithName(ScenesENUM.FOG);
		_gameView.addSceneWithName(ScenesENUM.HIDDEN_OBJECTS);
		LayerManager.getLayer("scene").addChild(_gameView);
		_mapsController = new MapsController(_gameView);
	}
}
}
