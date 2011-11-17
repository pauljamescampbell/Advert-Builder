package com.guardian.advertbuilder.advert {
	/**
	 * @author plcampbell
	 */
	public class AdvertConfig {
		
		public static const MAX_LAYERS:Number = 10;
		public static const MIN_LAYERS:Number = 1;
		
		private var _minLayers:Number;
		private var _maxLayers:Number;
		private var _canTargetLayers:Boolean;
		
		public function AdvertConfig(minLayers:Number = MIN_LAYERS, maxLayers:Number = MAX_LAYERS, canTargetLayers:Boolean = false) {
			_maxLayers = maxLayers;
			_canTargetLayers = canTargetLayers;
			_minLayers = minLayers;	
		}
		
		public function minLayers():Number {
			return(_minLayers);
		}
		
		public function maxLayers():Number {
			return(_maxLayers);
		}
		
		public function canTargetLayers():Boolean {
			return(_canTargetLayers);
		}
		
	}
}
