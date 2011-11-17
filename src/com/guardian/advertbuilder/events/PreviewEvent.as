package com.guardian.advertbuilder.events {
	import com.guardian.advertbuilder.advert.Hotspot;
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class PreviewEvent extends Event {
		
		static public const HOTSPOT_CLICK:String = "hotspot_click";
		
		public var hotspot:Hotspot; 
		
		public function PreviewEvent(type : String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
