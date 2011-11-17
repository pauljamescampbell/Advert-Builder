package com.guardian.advertbuilder {
	import flash.display.Bitmap;
	import flash.desktop.NativeApplication;
	/**
	 * @author plcampbell
	 */
	public class System {
		/*
		[Embed(source="../assets/icon_016.png")];
		public static const ICON_16:Class;
		
		[Embed(source="../assets/icon_032.png")];
		public static const ICON_32:Class;
		
		[Embed(source="../assets/icon_048.png")];
		public static const ICON_48:Class;
		
		[Embed(source="../assets/icon_128.png")];
		public static const ICON_128:Class;
		
		[Embed(source="../assets/icon_256.png")];
		public static const ICON_256:Class;
		
		[Embed(source="../assets/icon_512.png")];
		public static const ICON_512:Class;
		 */
		
		public static function init():void {
			if(NativeApplication.supportsDockIcon) {
				//NativeApplication.nativeApplication.icon.bitmaps = [ICON_16 as Bitmap, ICON_32 as Bitmap, ICON_48 as Bitmap];	
			}
		}
	}
	
	
}
