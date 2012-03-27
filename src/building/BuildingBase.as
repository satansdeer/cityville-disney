/**
 * Created by : Dmitry
 * Date: 2/17/12
 * Time: 1:27 AM
 */
package building {
import core.display.SceneSprite;
import core.layer.LayersENUM;

public class BuildingBase extends SceneSprite {
	public static function createOneTower():BuildingBase {
		var result:BuildingBase = new BuildingBase();
		result.graphics.beginFill(0xffaa33);
		result.graphics.drawRect(-20, -20, 40, 40);
		result.graphics.drawCircle(0, 0, 10);
		result.graphics.endFill();
		return result;
	}

	public static function createTwoTower():BuildingBase {
		var result:BuildingBase = new BuildingBase();
		result.graphics.beginFill(0xffaa33);
		result.graphics.drawCircle(0, 0, 40);
		result.graphics.drawCircle(0, 0, 20);
		result.graphics.endFill();
		return result;
	}

	public function BuildingBase() {
		super(LayersENUM.SCENE);
	}
}
}
