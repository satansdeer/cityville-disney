/**
 * User: dima
 * Date: 10/04/12
 * Time: 11:40 AM
 */
package game.staticModel {
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

import game.crafting.PlotVO;

import rpc.GameRpc;

public class UserSession extends EventDispatcher {
	private var _level:int;
	private var _money:int;
	private var _plot:PlotVO; //грядка епт!

	private var _timer:Timer;

	private var _canRequest:Boolean;

	private const REQUEST_TIMEOUT:int = 1000; //milliseconds

	public function UserSession() {
		_canRequest = true;
		_timer = new Timer(REQUEST_TIMEOUT);
		_timer.addEventListener(TimerEvent.TIMER, onTimer);
		_timer.start();
	}

	public function onTimer(event:TimerEvent):void {
		if (_canRequest) {
			GameRpc.instance.getState(onState);
			_canRequest = false;
		}
	}

	public function onState(state:Object):void {
		_level = state["level"];
		_money = state["money"];
		if (!_plot) {
			_plot = new PlotVO();
		}
		_plot._timeLeft = state["plot"]["time"];
		_plot.completed = state["plot"]["completed"];
		_canRequest = true;
	}

}
}
