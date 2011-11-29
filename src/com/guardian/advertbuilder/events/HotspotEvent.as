package com.guardian.advertbuilder.events {
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class HotspotEvent extends Event {
		
		public static const REMOVE:String = "remove";
		
		public function HotspotEvent(type : String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
