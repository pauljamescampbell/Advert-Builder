package com.guardian.advertbuilder.io {
	import maja.air.LogApp;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.guardian.advertbuilder.advert.Image;
	import com.coltware.airxzip.ZipFileWriter;
	import com.guardian.advertbuilder.advert.Hotspot;
	import com.guardian.advertbuilder.advert.Layer;
	import com.guardian.advertbuilder.Config;
	import com.adobe.serialization.json.JSONDecoder;
	import flash.events.EventDispatcher;
	import com.guardian.advertbuilder.advert.Advert;
	import flash.utils.ByteArray;
	import com.coltware.airxzip.ZipCRC32;
	import com.coltware.airxzip.ZipEntry;
	import com.coltware.airxzip.ZipFileReader;
	import com.coltware.airxzip.ZipEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import com.guardian.advertbuilder.events.ImportEvent;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.filesystem.File;
	import flash.display.*;
	/**
	 * @author plcampbell
	 */
	public class Import extends EventDispatcher {
		
		public static const OPEN_TITLE:String = "Open advert...";
		public static var TEMP_COUNT:int = 1;
		private static const UNPACK_TIMEOUT:int = 20;
		
		private var _queue:Array;
		private var _json:JSONDecoder;
		private var _numImagesReady:int = 0;
		private var _zip:ZipFileReader;
		private var _file:File;
		private var _advert:Advert;
		private var _images:Object;
		
		public function Import():void {
			_file = new File();
			_images = new Object();
			_file.addEventListener(Event.SELECT, onFileSelected);
			_queue = new Array();
		}
		
		public function openFileDialog(extension:String):void {
			var filter:FileFilter = new FileFilter("Guardian advert", "*."+ extension );
			try {
				_file.browseForOpen(OPEN_TITLE, [filter]);
			} catch(error:Error) {
				_file.removeEventListener(Event.SELECT, onFileSelected);
				dispatchEvent(new ImportEvent(ImportEvent.FAILED));
			}
		}
		
		public function openInvokedFile(file:File, types:Array):void {
			if(!types.indexOf(file.extension)) {
				dispatchEvent(new ImportEvent(ImportEvent.INVALID_FILETYPE));
				return;
			}
			_file = file;
			openFile();
		}
		
		public function getAdvert():Advert {
			return(_advert);
		}
		
		
		private function onFileSelected(event:Event):void {
			openFile();
		}
		
		private function openFile():void {
			LogApp.log("opening file " + _file.nativePath);
			_zip = new ZipFileReader();
        	
			try {
				_zip.open(_file);
				
				var entries:Array = _zip.getEntries();
				if(entries.length < 2) {
					dispatchEvent(new ImportEvent(ImportEvent.FILE_MALFORMED));
				}
			} catch(error:Error) {
				trace(error);
				dispatchEvent(new ImportEvent(ImportEvent.FAILED));
				return;
			}
			
			_queue = new Array();
			var bytes:ByteArray;
			for each(var entry:ZipEntry in entries) {
				if(entry.getFilename() == Export.JSON_FILENAME) {
					unpackToJson(entry);
				} else {
					// Lets NOT unpack the JSON cause that will change on repackage.
					bytes = _zip.unzip(entry);
					bytes.position = 0;
					_queue.push(new TempFileObject( bytes, entry.getFilename() ));
				}
			}
			
			// Close the file stream
			_zip.close();
			
			// Has this worked? Do we have a JSON file?
			if(_json) {
				unpackQueueToTempDirectory();
			} else {
				dispatchEvent(new ImportEvent(ImportEvent.FAILED));
			}
			
		}
		
		private function onTempImageReady(event:ImportEvent):void {
			_numImagesReady++;
			if(_numImagesReady == _queue.length) {
				trace("haveAllImagesLoaded : " + _numImagesReady +"..."+ _queue.length);
				mapJSONToAdvert();
			}
		}
		
		private function onTempImageFailed(event:ImportEvent):void {
			dispatchEvent(new ImportEvent(ImportEvent.FAILED));
		}
		
		private function unpackQueueToTempDirectory():void {
			//var dir:File = File.createTempDirectory();
			var dir:File = File.desktopDirectory.resolvePath("unpack_"+ TEMP_COUNT++);
			LogApp.log("unpacking zip to " + dir.nativePath);
			//
			var file:File;
			var stream:FileStream;
			var temp:TempFileObject;
			for(var i:Number = 0; i<_queue.length; i++) {
				temp = _queue[i] as TempFileObject;
				temp.addEventListener(ImportEvent.IMAGE_LOADED, onTempImageReady);
				temp.addEventListener(ImportEvent.IMAGE_FAILED, onTempImageFailed);
				//
				file = dir.resolvePath(temp.getFilename());
				stream = new FileStream();
				stream.open(file, FileMode.WRITE);
				stream.writeBytes(temp.getBytes(), 0, temp.getBytes().length);
				stream.close();
				//
				temp.openBitmap();
				temp.setFile(file);
			}
		}
		
		private function unpackToJson(entry:ZipEntry):void {
			var bytes:ByteArray = _zip.unzip(entry);
			bytes.position = 0;
			try {
	            var json:JSONDecoder = new JSONDecoder(bytes.readUTFBytes(bytes.length), false);
				if(json) {
					_json = json;
				}
			} catch(error:Error) {
				dispatchEvent(new ImportEvent(ImportEvent.FAILED));
			}
		}
		
		private function getTempFileByFilename(filename:String):TempFileObject {
			var file:TempFileObject;
			for(var i:int = 0; i<_queue.length; i++) {
				file = _queue[i];
				if(file.getFilename() == filename) {
					return(file);
				}
			}
			return(null);
		}
		
		private function mapJSONToAdvert():void {
			var data:Object = _json.getValue();
			
			_advert = new Advert(Config.mapSize(data.size), Config.mapType(data.type));
			
			// Get the layers
			var dataLayer:Object;
			var layer:Layer;
			for(var i:int = 0; i<data.stack.length; i++) {
				dataLayer = data.stack[i];
				layer = new Layer();
				
				// Get image
				if(dataLayer.media.reference) {
					var file:TempFileObject = getTempFileByFilename(dataLayer.media.reference as String);
					layer.setLayerImage(
						file.getAsImage()
					);
				}
				
				// Get the hotspots
				var dataSpot:Object;
				var hotspot:Hotspot;
				for(var a:int = 0; a<dataLayer.hotspots.length; a++) {
					dataSpot = dataLayer.hotspots[i];
					hotspot = new Hotspot(dataSpot.left, dataSpot.top, dataSpot.width, dataSpot.height);
					if(dataSpot.targetLayer) {
						hotspot.setTargetLayer(dataSpot.targetLayer);	
					} else if(dataSpot.targetURL) {
						hotspot.setTargetUrl(dataSpot.targetURL);
					}
					layer.setHotspot(hotspot);
				}
				
				// Update advert
				_advert.addLayer(layer);
			}
			dispatchEvent(new ImportEvent(ImportEvent.DONE));
		}
		
	}
}
