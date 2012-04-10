/**
 * User: dima
 * Date: 10/04/12
 * Time: 11:40 AM
 */
package game.model {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

import game.crafting.PlotVO;

import rpc.GameRpc;

public class UserSession extends EventDispatcher {
	private static var _instance:UserSession;

	private var _level:int;
	private var _money:int;
	private var _food:int;
	private var _plot:PlotVO; //грядка епт!

	private var _timer:Timer;

	private var _canRequest:Boolean;

	private const REQUEST_TIMEOUT:int = 1000; //milliseconds

	public static function get instance():UserSession {
		if (!_instance) { _instance = new UserSession(); }
		return _instance;
	}

	public function UserSession() {}

	public function get money():int { return _money; }
	public function get level():int { return _level; }
	public function get food():int { return _food; }

	public function init():void {
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
		_food = state["food"];
		if (!_plot) {
			_plot = new PlotVO();
		}
		_plot._timeLeft = state["plot"]["time"];
		_plot.completed = state["plot"]["completed"];
		_canRequest = true;
		dispatchEvent(new Event(Event.CHANGE));
	}

}
}
