package com.guardian.advertbuilder.views.preview {
	import com.guardian.advertbuilder.advert.Hotspot;
	import flash.display.Sprite;

	/**
	 * @author plcampbell
	 */
	public class PreviewHotspot extends Sprite {
		
		private var _hotspot:Hotspot;
		
		public function PreviewHotspot(hotspot:Hotspot) {
			_hotspot = hotspot;
			x = hotspot.x;
			y = hotspot.y;
			width = hotspot.width;
			height = hotspot.height;
			//
			fill();
		}
		
		public function getHotspot():Hotspot {
			return(_hotspot);
		}
		
		private function fill():void {
			graphics.beginFill(0xcc0000, 1);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
	}
}
