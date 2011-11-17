package com.guardian.advertbuilder.io {
	import com.guardian.advertbuilder.advert.Advert;
	/**
	 * @author plcampbell
	 */
	public class ExportForSaving extends Export {
		
		public static const EXTENSION:String = "gab";
		
		public function ExportForSaving(advert:Advert):void {
			super(advert);
		}
		
		public function save():void {
			try {
				$extension = EXTENSION;
				output();
			} catch (error:Error) {
				trace(error.message);
			}		
		}
	}
}
