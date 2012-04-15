/**
 * Created by : Dmitry
 * Date: 4/15/12
 * Time: 12:28 PM
 */
package game.events {
import flash.events.Event;

public class CastleEvent extends Event {

	public static const CLICK:String = "onCastleClick";

	public function CastleEvent() {
		super(CLICK);
	}
}
}
