package com.guardian.advertbuilder.events {
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class DocumentEvent extends Event {
		
		public static const OPEN:String = "document_open";
		public static const NEW:String = "document_new";
		public static const PREVIEW:String = "document_preview";
		public static const EXPORT:String = "document_export";
		public static const SAVE:String = "document_save";
		public static const UPDATE:String = "document_update";
		
		public var adSize:String;
		public var adType:String;
		
		public function DocumentEvent(type : String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
