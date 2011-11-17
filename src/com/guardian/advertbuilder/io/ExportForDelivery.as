package com.guardian.advertbuilder.io {
	import com.guardian.advertbuilder.Config;
	import com.guardian.advertbuilder.advert.Advert;
	/**
	 * @author plcampbell
	 */
	public class ExportForDelivery extends Export {
		
		public static const OAS_CAMPAIGN_ID:String = "%%CAMP%%";
		public static const OAS_PATH:String = "%%CDN%%/RealMedia/ads/Creatives/%%CAMP%%/";
		public static const EXTENSION:String = "zip";
		
		public function ExportForDelivery(advert:Advert):void {
			super(advert);
		}
		
		public function save():void {
			try {
				$id = OAS_CAMPAIGN_ID;
				$path = OAS_PATH;
				$extension = EXTENSION;
				output();
			} catch (error:Error) {
				trace(error.message);
			}		
		}
	}
}
