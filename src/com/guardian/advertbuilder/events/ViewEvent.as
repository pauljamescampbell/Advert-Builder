package com.guardian.advertbuilder.events {
	import com.guardian.advertbuilder.advert.Layer;
	import flash.events.Event;

	/**
	 * @author plcampbell
	 */
	public class ViewEvent extends Event {
		
		public static const ADD_LAYER:String = "add_layer";
		public static const REMOVE_LAYER:String = "remove_layer";
		public static const MOVE_LAYER:String = "move_layer";
		public static const HIDE_LAYER:String = "hide_layer";
		public static const SHOW_LAYER:String = "show_layer";
		
		public static const TOOL_HOTSPOT:String = "tool_hotspot";
		public static const TOOL_SELECT:String = "tool_select";
		public static const TOOL_ZOOM:String = "tool_select";
		
		public var layer:Layer;
		
		public function ViewEvent(type : String, bubbles : Boolean = true, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
