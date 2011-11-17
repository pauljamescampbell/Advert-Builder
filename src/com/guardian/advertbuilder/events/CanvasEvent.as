package com.guardian.advertbuilder.events {
	import com.guardian.advertbuilder.advert.Hotspot;
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class CanvasEvent extends Event {
		
		public static const HOTSPOT_SELECTED:String = "hotspot_selected";
		public static const HOTSPOT_UNSELECTED:String = "hotspot_unselected";
		public static const REMOVE_HOTSPOT:String = "hotspot_remove";
		public static const ADD_HOTSPOT:String = "hotspot_add";
		
		public var hotspot:Hotspot;
		
		public function CanvasEvent(type : String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}
}
