package com.guardian.advertbuilder.events {
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class ExportEvent extends Event {
		
		public static const FAILED:String = "export_failed";
		public static const ERROR:String = "export_error";
		public static const SAVED:String = "export_saved";
		
		public function ExportEvent(type : String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
