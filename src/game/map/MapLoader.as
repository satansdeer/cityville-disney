package game.map
{
	/**
	 * MapLoader
	 * @author satansdeer
	 */
	import core.helper.XMLHelper;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	
	public class MapLoader extends EventDispatcher{
		
		public function MapLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function mapFromFile(path:String):Vector.<Vector.<Tile>>{
			var mapXml:XML = XMLHelper.readXML(path);
			var output:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>(mapXml.@width, true);
			var k:int;
			if(mapXml){
				for (var i:int = 0; i < mapXml.@width; i++){
					output[i] = new Vector.<Tile>(mapXml.@height, true);
					for(var j:int = 0; j < mapXml.@height; j++){
						k++;
						//output[i][j] = mapXml.tile[k];
						output[i][j] = new Tile(i,j, mapXml.tile[k], null);
					}
				}
			}
			return output;
		}
	}
}