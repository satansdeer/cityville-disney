/**
 * User: dima
 * Date: 10/02/12
 * Time: 1:59 PM
 */
package {
import as3isolib.display.IsoView;
import as3isolib.display.scene.IsoScene;

import core.AppData;
import core.component.panel.HorizontalScrollablePanel;
import core.component.panel.PanelItem;
import core.enum.ScenesENUM;
import core.enum.WindowsENUM;
import core.layer.LayersENUM;
import core.window.WindowManager;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

import game.GameView;
import game.SceneController;
import game.map.GroundMap;
import game.map.MapBase;
import game.map.MapsController;
import game.map.ObjectsMap;
import game.map.Road1Map;

import iface.Interface;
import iface.ObjectsPanel;
import iface.windows.ResizeMapWindow;

import org.casalib.util.StageReference;

import ru.beenza.framework.layers.LayerManager;

[SWF(width=700, height=670, frameRate=25, backgroundColor="0x000000")]
public class Main extends Sprite {
	public static const APP_WIDTH:int = 700;
	public static const APP_HEIGHT:int = 670;
	public static const UNIT_SIZE:int = 32;
	
	private var sceneController:SceneController;

	private var _gameView:GameView;
	private var _mapsController:MapsController;
	
	public function Main() {
		trace("app started");
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	/* Internal functions */

	private function addedToStageHandler(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		
		loadOptions();
		
			// stage settings
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		StageReference.setStage(stage);
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
		initPanel();
		registerWindows();
		new Interface();
	}
	
	private function registerWindows():void {
		WindowManager.instance.layer = LayerManager.getLayer(LayersENUM.WINDOWS);
		WindowManager.instance.registerWindow(WindowsENUM.RESIZE_MAP_WINDOW, new ResizeMapWindow());
	}
	
	private function loadOptions():void {
		var req:URLRequest = new URLRequest("options.xml");
		var loader:URLLoader = new URLLoader;
		loader.addEventListener(Event.COMPLETE, onOptionsComplete);
		loader.load(req);
	}
	
	protected function onOptionsComplete(event:Event):void{
		AppData.options = new XML(event.target.data);
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
