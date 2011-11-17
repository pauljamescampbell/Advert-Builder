package com.guardian.advertbuilder.advert {
	import flash.geom.Rectangle;

	/**
	 * @author plcampbell
	 */
	public class Hotspot extends Rectangle {
		
		private var _id:Number;
		private var _url:String = "";
		private var _layerName:String = "";
		private var _layer:Number = 0;
		
		public function Hotspot(x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0) {
			_id = Math.floor(Math.random() * (1+10000000-1)) + 1;
			super(x, y, width, height);
		}
		
		public function setTargetUrl(url:String):void {
			_url = url;
		}
		
		public function getTargetUrl():String{
			return(_url);
		}
		
		public function setTargetLayerName(name:String):void {
			_layerName = name;
		}
		
		public function getTargetLayerName():String {
			return(_layerName);
		}
		
		// Why keep the below?
		
		public function setTargetLayer(layer:Number):void {
			_layer = layer;
		}
		
		public function getTargetLayerPosition():Number {
			return(_layer);
		}
	}
}
