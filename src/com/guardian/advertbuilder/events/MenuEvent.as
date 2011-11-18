package com.guardian.advertbuilder.events {
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class MenuEvent extends Event {
		
		public static const OPEN:String = "open";
		public static const NEW:String = "new";
		public static const EXPORT:String = "export";
		public static const IMPORT:String = "import";
		public static const CLOSE:String = "close"; 
		
		public function MenuEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
