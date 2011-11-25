package com.guardian.advertbuilder {
	import com.guardian.advertbuilder.advert.AdvertConfig;

	import fl.data.DataProvider;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * @author plcampbell
	 */
	public class Config {
		public static const BYTES_IN_KILOBYTES : uint = 1024;
		public static const DEFAULT_NONE_ITEM : String = "";
		public static const SIZE_PORTRAIT : String = "Portrait";
		public static const SIZE_PORTRAIT_HASH : String = "oneByTwo";
		public static const SIZE_PORTRAIT_WIDTH : Number = 172;
		public static const SIZE_PORTRAIT_HEIGHT : Number = 418;
		public static const SIZE_PORTRAIT_FILESIZE : Number = 250 * BYTES_IN_KILOBYTES;
		public static const SIZE_LANDSCAPE : String = "Landscape";
		public static const SIZE_LANDSCAPE_HASH : String = "twoByOne";
		public static const SIZE_LANDSCAPE_WIDTH : Number = 418;
		public static const SIZE_LANDSCAPE_HEIGHT : Number = 172;
		// public static const SIZE_LANDSCAPE_FILESIZE:Number= 250;
		public static const SIZE_LANDSCAPE_FILESIZE : Number = 500 * BYTES_IN_KILOBYTES;
		// Testing
		public static const SIZE_FOOTER : String = "Footer";
		public static const SIZE_FOOTER_HASH : String = "threeByOne";
		public static const SIZE_FOOTER_WIDTH : Number = 664;
		public static const SIZE_FOOTER_HEIGHT : Number = 172;
		public static const SIZE_FOOTER_FILESIZE : Number = 250 * BYTES_IN_KILOBYTES;
		public static const SIZE_FULLPAGE : String = "Fullpage";
		public static const SIZE_FULLPAGE_HASH : String = "rotate";
		public static const SIZE_FULLPAGE_WIDTH : Number = 1024;
		public static const SIZE_FULLPAGE_HEIGHT : Number = 768;
		public static const SIZE_FULLPAGE_FILESIZE : Number = 250 * BYTES_IN_KILOBYTES;
		public static const TYPE_STATIC : String = "Static";
		public static const TYPE_STATIC_HASH : String = "default";
		public static const TYPE_STATIC_CONFIG : AdvertConfig = new AdvertConfig(AdvertConfig.MIN_LAYERS, 1);
		public static const TYPE_FLIP : String = "Flip";
		public static const TYPE_FLIP_HASH : String = "flip";
		public static const TYPE_FLIP_CONFIG : AdvertConfig = new AdvertConfig(2, 2, true);
		public static const TYPE_HOTSPOT : String = "Hotspot";
		public static const TYPE_HOTSPOT_HASH : String = "default";
		public static const TYPE_HOTSPOT_CONFIG : AdvertConfig = new AdvertConfig(2, AdvertConfig.MAX_LAYERS, true);
		public static const TYPE_CURL : String = "Curl";
		public static const TYPE_CURL_HASH : String = "curl";
		public static const TYPE_CURL_CONFIG : AdvertConfig = new AdvertConfig(2, AdvertConfig.MIN_LAYERS);
		public static const TYPE_ZOOM : String = "Zoom";
		public static const TYPE_ZOOM_HASH : String = "zoom";
		public static const TYPE_ZOOM_CONFIG : AdvertConfig = new AdvertConfig(2, 2);
		public static const TYPE_SLIDE : String = "Slide";
		public static const TYPE_SLIDE_HASH : String = "slide";
		public static const TYPE_SLIDE_CONFIG : AdvertConfig = new AdvertConfig(AdvertConfig.MIN_LAYERS, AdvertConfig.MAX_LAYERS);

		public static function getFileSizeLimitForAdvertSize(size : String) : Number {
			switch(size) {
				case SIZE_FOOTER :
					return(SIZE_FOOTER_FILESIZE);
				case SIZE_PORTRAIT:
					return(SIZE_PORTRAIT_FILESIZE);
				case SIZE_LANDSCAPE:
					return(SIZE_LANDSCAPE_FILESIZE);
				case SIZE_FULLPAGE:
					return(SIZE_FULLPAGE_FILESIZE);
				default :
					return(SIZE_PORTRAIT_FILESIZE);
			}
		}

		public static function getConfigurationForAdvertType(type : String) : AdvertConfig {
			switch(type) {
				case TYPE_CURL :
					return(TYPE_CURL_CONFIG);
				case TYPE_FLIP:
					return(TYPE_FLIP_CONFIG);
				case TYPE_HOTSPOT:
					return(TYPE_HOTSPOT_CONFIG);
				case TYPE_SLIDE:
					return(TYPE_SLIDE_CONFIG);
				case TYPE_STATIC:
					return(TYPE_STATIC_CONFIG);
				case TYPE_ZOOM:
					return(TYPE_ZOOM_CONFIG);
			}
			return null;
		}

		public static function getSizesAsDataProvider() : DataProvider {
			var data : DataProvider = new DataProvider();
			data.addItem({label:SIZE_LANDSCAPE});
			data.addItem({label:SIZE_PORTRAIT});
			data.addItem({label:SIZE_FOOTER});
			// data.addItem({ label:SIZE_FULLPAGE} );
			return(data);
		}

		public static function getTypesAsDataProvider() : DataProvider {
			var data : DataProvider = new DataProvider();
			data.addItem({label:TYPE_STATIC});
			data.addItem({label:TYPE_FLIP});
			data.addItem({label:TYPE_HOTSPOT});
			data.addItem({label:TYPE_SLIDE});
			// data.addItem({ label:TYPE_CURL} );
			// data.addItem({ label:TYPE_ZOOM} );
			return(data);
		}

		public static function getSizeForAdvertAsRectangle(size : String) : Rectangle {
			var rect : Rectangle = new Rectangle();
			switch( size ) {
				case SIZE_PORTRAIT :
					rect.height = SIZE_PORTRAIT_HEIGHT;
					rect.width = SIZE_PORTRAIT_WIDTH;
					break;
				case SIZE_LANDSCAPE:
					rect.height = SIZE_LANDSCAPE_HEIGHT;
					rect.width = SIZE_LANDSCAPE_WIDTH;
					break;
				case SIZE_FOOTER :
					rect.height = SIZE_FOOTER_HEIGHT;
					rect.width = SIZE_FOOTER_WIDTH;
					break;
				case SIZE_FULLPAGE :
					rect.height = SIZE_FULLPAGE_HEIGHT;
					rect.width = SIZE_FULLPAGE_WIDTH;
					break;
			}
			return( rect );
		}

		public static function mapType(type : String) : String {
			switch(type) {
				case Config.TYPE_HOTSPOT :
					return(Config.TYPE_HOTSPOT_HASH);
				case Config.TYPE_CURL:
					return(Config.TYPE_CURL_HASH);
				case Config.TYPE_FLIP:
					return(Config.TYPE_FLIP_HASH);
				case Config.TYPE_SLIDE:
					return(Config.TYPE_SLIDE_HASH);
				case Config.TYPE_STATIC:
					return(Config.TYPE_STATIC_HASH);
				case Config.TYPE_ZOOM:
					return(Config.TYPE_ZOOM_HASH);
				case Config.TYPE_HOTSPOT_HASH :
					return(Config.TYPE_HOTSPOT);
				case Config.TYPE_CURL_HASH:
					return(Config.TYPE_CURL);
				case Config.TYPE_FLIP_HASH:
					return(Config.TYPE_FLIP);
				case Config.TYPE_SLIDE_HASH:
					return(Config.TYPE_SLIDE);
				case Config.TYPE_STATIC_HASH:
					return(Config.TYPE_STATIC);
				case Config.TYPE_ZOOM_HASH:
					return(Config.TYPE_ZOOM);
				default:
					return(null);
			}
		}

		public static function mapSize(size : String) : String {
			switch(size) {
				case Config.SIZE_PORTRAIT :
					return( Config.SIZE_PORTRAIT_HASH);
				case Config.SIZE_LANDSCAPE :
					return( Config.SIZE_LANDSCAPE_HASH);
				case Config.SIZE_FOOTER :
					return( Config.SIZE_FOOTER_HASH);
				case Config.SIZE_PORTRAIT_HASH :
					return( Config.SIZE_PORTRAIT);
				case Config.SIZE_LANDSCAPE_HASH :
					return( Config.SIZE_LANDSCAPE);
				case Config.SIZE_FOOTER_HASH :
					return( Config.SIZE_FOOTER);
				default:
					return(null);
			}
		}
	}
}
