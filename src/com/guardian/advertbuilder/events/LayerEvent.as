package com.guardian.advertbuilder.events {
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class LayerEvent extends Event {
		
		public static const MOVE_UP:String = "move_up";
		public static const MOVE_DOWN:String = "move_down";
		public static const SHOW:String = "show";
		public static const CHANGE_NAME:String = "change_name";
		
		public function LayerEvent(type : String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
