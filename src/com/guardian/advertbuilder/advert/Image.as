package com.guardian.advertbuilder.advert {
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import org.bytearray.gif.events.GIFPlayerEvent;
	import org.bytearray.gif.events.FileTypeEvent;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import org.bytearray.gif.player.GIFPlayer;
	import com.guardian.advertbuilder.Config;
	import flashx.textLayout.formats.Float;
	import flash.display.Bitmap;
	import flash.filesystem.File;
	/**
	 * @author plcampbell
	 */
	public class Image {
		
		public static const FILESIZE_IN_BYTES:String = "in_bytes";
		public static const FILESIZE_IN_KILOBYTES:String = "in_kilobytes";
		public static const EXTENSION_GIF:String = "gif";
		
		private var _file:File;
		private var _bytes:ByteArray;
		private var _bitmap:Bitmap;
		private var _gif:GIFPlayer;
		private var _isAnimatedGIF:Boolean = false;
		
		public function Image(bitmap:Bitmap, file:File, bytes:ByteArray) {
			_bitmap = bitmap;
			_file = file;
			_bytes = bytes;
			if(_file.extension == EXTENSION_GIF) {
				_gif = new GIFPlayer();
				_gif.addEventListener(IOErrorEvent.IO_ERROR, onGIFIOError);
				_gif.addEventListener(FileTypeEvent.INVALID, onGIFFileTypeError);
				_gif.addEventListener(GIFPlayerEvent.COMPLETE, onGIFReady);
				_gif.loadBytes(_bytes); // Get initial dataarray
			}
		}
		
		public function destroy():void {
			_bitmap.bitmapData.dispose();
			_bitmap = null;
			_file = null;
			if(isAnimated()) {
				if(_gif.parent) {
					_gif.parent.removeChild(_gif);
					_gif.dispose();
					_gif = null;
				}
			}
		}
		
		public function getBitmap():Bitmap {
			return(_bitmap);
		}
		
		public function getAnimation():GIFPlayer {
			return(_gif);
		}
		
		public function isAnimated():Boolean {
			return(_isAnimatedGIF);
		}
		
		public function getFile():File {
			return(_file); 
		}
		
		public function getImageFilesize(conversion:String = FILESIZE_IN_BYTES):Number {
			switch(conversion) {
				case FILESIZE_IN_KILOBYTES :
					return(_file.size / Config.BYTES_IN_KILOBYTES);
			}
			return(_file.size);
		}
		
		public function getImagePath():String {
			return(_file.nativePath);
		}
		
		public function getImageFilename():String {
			var parts:Array = (_file.nativePath as String).split("/");
			return(parts[parts.length-1]);
		}
		
		private function onGIFIOError(event:IOErrorEvent):void {
			_isAnimatedGIF = false;
			trace(event);
		}
		
		private function onGIFFileTypeError(event:FileTypeEvent):void {
			_isAnimatedGIF = false;
			trace(event);	
		}
		
		private function onGIFReady(event:GIFPlayerEvent):void {
			if(_gif.totalFrames > 1) {
				_isAnimatedGIF = true;	
			}
			_gif.stop();
		}
		
	}
}
