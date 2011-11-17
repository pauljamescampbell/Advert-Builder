package com.guardian.advertbuilder.errors {
	/**
	 * @author plcampbell
	 */
	public class AdvertError extends Error {
		
		public static const NO_LAYER_FOUND:Number = 0;
		public static const TOO_MANY_LAYERS:Number = 1;
		public static const TOO_FEW_LAYERS:Number = 2;
		public static const INVALID_LAYER_LINK:Number = 3;
		public static const INVALID_SIZE:Number = 4;
		public static const INVALID_TYPE:Number = 5;
		
		public function AdvertError(message : * = "", id : * = 0) {
			super(message, id);
		}
	}
}
