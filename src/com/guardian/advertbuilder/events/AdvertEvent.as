package com.guardian.advertbuilder.events {
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class AdvertEvent extends Event {
		
		// All events force a full refresh of related area;
		public static const IMAGE_CHANGE:String = "image_change";
		public static const POSITION_CHANGE:String = "position_change";
		public static const HOTSPOT_CHANGE:String = "hotspot_change";
		public static const FILESIZE_LIMIT_EXCEEDED:String = "filesize_exceeded";
		
		public function AdvertEvent(type : String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
