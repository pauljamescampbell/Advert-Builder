package com.guardian.advertbuilder.views.preview {
	import flash.geom.Rectangle;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import com.guardian.advertbuilder.advert.Advert;
	import flash.display.NativeWindowType;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;

	/**
	 * @author plcampbell
	 */
	public class PreviewWindow extends NativeWindow {
		
		private var _preview:Preview;
		
		public function PreviewWindow() {
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.maximizable = false;
			options.minimizable = true;
			options.resizable = false; 
			options.transparent = false;
			options.systemChrome = NativeWindowSystemChrome.STANDARD;
			options.type = NativeWindowType.NORMAL;
			//
			super(options);
			//
			title = "Guardian Advert Previewer";
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			//
			activate();	
		}
		
		public function init(advert:Advert):void {
			_preview = new Preview(advert);
			this.stage.addChild(_preview);
		}

	}
}
