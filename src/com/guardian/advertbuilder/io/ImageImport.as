package com.guardian.advertbuilder.io {
	import flash.utils.ByteArray;
	import com.guardian.advertbuilder.advert.Image;
	import com.guardian.advertbuilder.events.AdvertEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;

	/**
	 * @author plcampbell
	 */
	public class ImageImport extends Sprite {
		
		public static const FILE_FILTER:FileFilter = new FileFilter("Image", "*.jpg;*.png;*.gif;*.jpeg;");
		
		private var _file:File;
		private var _loader:Loader;
		private var _sizeRectangle:Rectangle;
		private var _maxFilesize:Number = 0;
		
		public function ImageImport(dimensions:Rectangle, maxFilesize:Number) {
			_sizeRectangle = dimensions;
			_maxFilesize = maxFilesize;
		}
		
		public function selectFile():void {
			_file = new File();
			_file.addEventListener(Event.SELECT, onFileSelected);
    		_file.browse(getFilters()); 
		}
		
		public function getImage():Image {
			return(
				new Image(getImportAsBitmap(), _file.clone(), (_file.data as ByteArray))
			);
		}
		
		public function getImportAsBitmap():Bitmap {
			var bitmapData:BitmapData = new BitmapData(_sizeRectangle.width, _sizeRectangle.height);
			bitmapData.draw(_loader);
			return(new Bitmap(bitmapData.clone()));
		}
		
		public function getPath():String {
			return(_file.nativePath);
		}
		
		public function flush():void {
			if(_loader) {
				removeChild(_loader);
				_loader = null;
				_file.cancel();//
				_file = null;
			}
		}
		
		private function onFileSelected(event:Event):void {
			if(isValidFilesize()) {
				_file.addEventListener(Event.COMPLETE, onFileLoaded);
				_file.load();
			} else {
				dispatchEvent(new AdvertEvent(AdvertEvent.FILESIZE_LIMIT_EXCEEDED));
			}
		}
		
		private function isValidFilesize():Boolean {
			trace(_file.size, _file.size <= _maxFilesize, _maxFilesize );
			return( _file.size <= _maxFilesize );
		}
		
		private function onFileLoaded(event:Event):void {
			event.stopPropagation();
			_loader = new Loader();
			_loader.alpha = 0;
			_loader.loadBytes(_file.data);
			addEventListener(Event.ENTER_FRAME, onWaitToAddedToStage);
			addChild(_loader);
		}
		
		private function onWaitToAddedToStage(event:Event):void {
			if(_loader.width > 0 && _loader.height > 0) {
				removeEventListener(Event.ENTER_FRAME, onWaitToAddedToStage);
				if(isCorrectSize()) {
					dispatchEvent(new Event(Event.COMPLETE));
				} else {
					dispatchEvent(new Event(Event.CANCEL));
				}
			}
		}
		
		private function isCorrectSize():Boolean {
			if(_loader.width == _sizeRectangle.width || _loader.height == _sizeRectangle.height) {
				trace("Import: Correct size image");
				return(true);
			}
			trace("Import: Wrong size image");
			return(false);
		}
		
		private function getFilters():Array {
			return( [ FILE_FILTER ] );
		}
	}
}