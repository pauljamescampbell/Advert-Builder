package com.guardian.advertbuilder.views.preview {
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.guardian.advertbuilder.events.PreviewEvent;
	import com.guardian.advertbuilder.advert.Layer;
	import com.guardian.advertbuilder.advert.Advert;
	import com.guardian.advertbuilder.Config;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	/**
	 * @author plcampbell
	 */
	public class Preview extends Sprite {
		
		private var _scenes:Array;
		private var _advert:Advert;
		
		public function Preview( advert:Advert ) {
			_advert = advert;
			//
			var rect:Rectangle = Config.getSizeForAdvertAsRectangle(_advert.getSize());
			width = rect.width;
			height = rect.height;
			//
			renderScenes();
		}
		
		private function renderScenes():void {
			var layer:Layer;
			var scene:PreviewScene;
			var layers:Array = _advert.getLayers();
			_scenes = new Array();
			for(var i:int = 0; i<layers.length; i++) {
				layer = layers[i];
				scene = new PreviewScene(layer.getImage(), layer.getHotspots());
				addChild(scene);
				_scenes.push(scene);
			}
		}
		
		private function onHotspotClicked(event:PreviewEvent):void {
			trace(event);
			// What happens depends on the type
			switch(_advert.getType()) {
				case Config.TYPE_STATIC_HASH :
					// Static ads can ONLY link URLs
					// Except in the case it links to another ad (out of scope)
					goToUrl(
						event.hotspot.getTargetUrl()
					);
					break; 
			}
		}
		
		private function goToUrl(url:String):void {
			navigateToURL(new URLRequest(url));
		}
		
	}
}
