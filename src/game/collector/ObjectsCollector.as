/**
 * User: dima
 * Date: 10/04/12
 * Time: 1:59 PM
 */
package game.collector {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLLoader;
import flash.net.URLRequest;

import game.vo.MapObjectVO;

public class ObjectsCollector extends EventDispatcher {

	private static var _instance:ObjectsCollector;

	private var _loader:URLLoader;

	private var _objects:Vector.<MapObjectVO>;

	public static function get instance():ObjectsCollector {
		if (!_instance) { _instance = new ObjectsCollector(); }
		return _instance;
	}

	public function ObjectsCollector():void {}

	public function init():void {
		loadObjects();
	}


	protected function loadObjects():void{
		var urlrequest:URLRequest = new URLRequest(Configuration.HOST + "/data/objects.xml");
		_loader = new URLLoader();
		_loader.addEventListener(Event.COMPLETE, onObjectsLoaded);
		_loader.load(urlrequest);
	}

	protected function onObjectsLoaded(event:Event):void{
		_loader.removeEventListener(Event.COMPLETE, onObjectsLoaded);
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
			addObject(objectVO);
		}
		dispatchEvent(new Event(Event.COMPLETE));
	}

	private function addObject(objectVO:MapObjectVO):void {
		if (!_objects) { _objects = new Vector.<MapObjectVO>(); }
		_objects.push(objectVO);
	}

}
}
