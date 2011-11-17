package com.guardian.advertbuilder.events {
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class AlertEvent extends Event {
		
		public static const OK:String = "ok";
		public static const CANCEL:String = "cancel";
		
		public function AlertEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
