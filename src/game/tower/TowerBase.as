/**
 * Created by : Dmitry
 * Date: 2/17/12
 * Time: 1:27 AM
 */
package game.tower {
import game.SceneSprite;
import game.layer.Layers;

public class TowerBase extends SceneSprite {
	public static function createOneTower():TowerBase {
		var result:TowerBase = new TowerBase();
		result.graphics.beginFill(0xffaa33);
		result.graphics.drawRect(-20, -20, 40, 40);
		result.graphics.drawCircle(0, 0, 10);
		result.graphics.endFill();
		return result;
	}

	public static function createTwoTower():TowerBase {
		var result:TowerBase = new TowerBase();
		result.graphics.beginFill(0xffaa33);
		result.graphics.drawCircle(0, 0, 40);
		result.graphics.drawCircle(0, 0, 20);
		result.graphics.endFill();
		return result;
	}

	public function TowerBase() {
		super(Layers.TOWERS);
	}
}
}
