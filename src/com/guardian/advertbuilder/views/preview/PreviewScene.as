package com.guardian.advertbuilder.views.preview {
	import com.guardian.advertbuilder.advert.Hotspot;
	import flash.display.DisplayObject;
	import com.guardian.advertbuilder.events.PreviewEvent;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import com.guardian.advertbuilder.advert.Image;
	import flash.display.Sprite;

	/**
	 * @author plcampbell
	 */
	public class PreviewScene extends Sprite {
		
		public function PreviewScene( image:Image, hotspots:Array ) {
			addImage(image);
			addHotspots(hotspots);
		}
		
		public function destroy():void {
			var child:DisplayObject;
			for(var i:int = 0; i<numChildren; i++) {
				child = getChildAt(i);
				if(child is PreviewHotspot) {
					child.removeEventListener(MouseEvent.CLICK, onHotspotClicked);
				}
			}
		}
		
		private function addImage(image:Image):void {
			addChild( image.getBitmap() );
		}
		
		private function addHotspots(hotspots:Array):void {
			var previewSpot:PreviewHotspot;
			var hotspot:Hotspot;
			for(var i:int =0; i<hotspots.length; i++) {
				hotspot = hotspots[i];
				previewSpot = new PreviewHotspot(hotspot);
				previewSpot.addEventListener(MouseEvent.CLICK, onHotspotClicked);
				addChild(previewSpot);
			}
		}
		
		private function onHotspotClicked(event:MouseEvent):void {
			var prevEvent:PreviewEvent = new PreviewEvent(PreviewEvent.HOTSPOT_CLICK);
			prevEvent.hotspot = (event.target as PreviewHotspot).getHotspot();
			dispatchEvent(prevEvent);
		}
	}
}
