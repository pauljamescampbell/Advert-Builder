package com.guardian.advertbuilder.io {
	import com.guardian.advertbuilder.advert.Image;
	import com.guardian.advertbuilder.events.ImportEvent;
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	/**
	 * @author plcampbell
	 */
	public class TempFileObject extends EventDispatcher {
		
		private var _bytearray:ByteArray;
		private var _filename:String;
		private var _bitmapData:BitmapData;
		private var _file:File;
		
		function TempFileObject(data:ByteArray, filename:String):void {
			_bytearray = data;
			_filename = filename;
		}
		
		public function setFile(file:File):void {
			_file = file;
		}
		
		public function getBytes():ByteArray {
			return(_bytearray);
		}
		
		public function getFilename():String{
			return(_filename);
		}
		
		public function getBitmap():Bitmap {
			return(new Bitmap(_bitmapData.clone()));
		}
		
		public function getFile():File {
			return(_file);
		}
		
		public function openBitmap():void {
			loadBitmapData();
		}
		
		public function getAsImage():Image {
			return(
				new Image(getBitmap(), getFile(), getBytes() )
			);
		}
		
		private function loadBitmapData():void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBitmapLoaded);
			try {
				loader.loadBytes(_bytearray);
			} catch(error:Error) {
				dispatchEvent(new ImportEvent(ImportEvent.IMAGE_FAILED));
			}
		}
		
		private function onBitmapLoaded(event:Event):void {
			//(event.target as Loader).contentLoaderInfo.removeEventListener(Event.COMPLETE, onBitmapLoaded);
			if(event.target.content is Bitmap) {
				_bitmapData = (event.target.content as Bitmap).bitmapData;
				dispatchEvent(new ImportEvent(ImportEvent.IMAGE_LOADED));	
			}
		}
		
	}
}
