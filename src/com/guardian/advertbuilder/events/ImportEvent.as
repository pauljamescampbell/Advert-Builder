package com.guardian.advertbuilder.events {
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class ImportEvent extends Event {
		
		public static const DONE:String = "ImportEvent_done";
		public static const FAILED:String = "ImportEvent_failed";
		public static const INVALID_FILETYPE:String = "ImportEvent_invalid_filetype";
		public static const FILE_MALFORMED:String = "ImportEvent_malformed";
		public static const IMAGE_LOADED:String = "ImportEvent_image_loaded";
		public static const IMAGE_FAILED:String = "ImportEvent_image_failed";
		
		public function ImportEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
