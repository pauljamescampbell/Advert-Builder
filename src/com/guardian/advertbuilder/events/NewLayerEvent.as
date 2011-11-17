package com.guardian.advertbuilder.events {
	import com.guardian.advertbuilder.events.AlertEvent;

	/**
	 * @author plcampbell
	 */
	public class NewLayerEvent extends AlertEvent {
		
		public var text:String;
		
		public function NewLayerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
