/**
 * Created by : Dmitry
 * Date: 4/11/12
 * Time: 10:11 PM
 */
package game.map {
import game.vo.MapObjectVO;

public class FarmPlot extends MapObject {

	public static function create(controller:ObjectsMap):FarmPlot {
		var vo:MapObjectVO = new MapObjectVO();
		vo.length = 1;
		vo.width = 1;
		vo.name = "farm plot";
		vo.url = "assets/plot/plot_1";
		return new FarmPlot(vo, controller);
	}

	public function FarmPlot(vo:MapObjectVO, controller:ObjectsMap) {
		super(vo, controller);
	}

}
}
