package com.guardian.advertbuilder.views.palettes {
	import com.guardian.advertbuilder.events.ViewEvent;
	import flash.events.MouseEvent;
	/**
	 * @author plcampbell
	 */
	public class ToolBar extends UIToolBar {
		
		public static const TOOL_MODE_SELECT:String = "tool_mode_select";
		public static const TOOL_MODE_HOTSPOT:String = "tool_mode_hotspot";
		public static const TOOL_MODE_ZOOM:String = "tool_mode_zoom";
		
		public function ToolBar() {
			buttonSelect.useHandCursor = true;
			buttonSelect.toggle = true;
			buttonSelect.addEventListener(MouseEvent.CLICK, onSelect);
			//
			buttonHotspot.useHandCursor = true;
			buttonHotspot.toggle = true;
			buttonHotspot.addEventListener(MouseEvent.CLICK, onHotspot);
		}
		
		public function toggleToolButtonState(tool:String):void {
			buttonSelect.selected = false;
			buttonHotspot.selected = false;
			switch(tool) {
				case TOOL_MODE_SELECT :
					buttonSelect.selected = true;
					break;
				case TOOL_MODE_HOTSPOT:
					buttonHotspot.selected = true;
					break; 
			}
		}

		private function onSelect(event:MouseEvent):void {
			dispatchEvent(new ViewEvent(ViewEvent.TOOL_SELECT));
		}
		private function onHotspot(event:MouseEvent):void { 
			dispatchEvent(new ViewEvent(ViewEvent.TOOL_HOTSPOT));
		}
	
	}
	
}
