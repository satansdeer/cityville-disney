package core.helper
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * XMLHelper
	 * @author satansdeer
	 */
	public class XMLHelper{
		
		public static function readXML (xml_name:String):XML {
			var xml_file:File;
			xml_file  = new File();
			xml_file.nativePath = xml_name;
			var output:XML;
			if (xml_file.exists) {
				var fs:FileStream = new FileStream();
				fs.open(xml_file, FileMode.READ);
				var input:String = fs.readUTFBytes(fs.bytesAvailable)
				var db_xml:XML = new XML(input);
				output = db_xml;
				fs.close();
			}else{
				output = null;
			}
			return output;
		}
		
		public static function saveXML(xml:XML, xml_name:String):void {
			var saveStr:String = xml.toXMLString();
			var xml_file:File;
			xml_file  = new File();
			xml_file.nativePath = xml_name;
			var fs:FileStream = new FileStream();
			fs.open(xml_file, FileMode.WRITE);
			fs.writeUTFBytes(saveStr);
			fs.close();
		}
	}
}