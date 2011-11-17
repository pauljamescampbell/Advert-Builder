package com.guardian.advertbuilder.io {
	import com.guardian.advertbuilder.events.ExportEvent;
	import flash.events.EventDispatcher;
	import com.adobe.serialization.json.JSONEncoder;
	import com.coltware.airxzip.ZipFileWriter;
	import com.guardian.advertbuilder.advert.Advert;
	import com.guardian.advertbuilder.advert.AdvertConfig;
	import com.guardian.advertbuilder.advert.Hotspot;
	import com.guardian.advertbuilder.advert.Layer;
	import com.guardian.advertbuilder.Config;
	import com.guardian.advertbuilder.GuardianAdBuilder;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	/**
	 * @author plcampbell
	 */
	public class Export extends EventDispatcher {
		
		public static const IMAGE_MEDIA_TYPE:String = "image";
		public static const JSON_FILENAME:String = "advert.json";
		public static var OUTPUT_COUNT:Number = 1;
		
		private var _advert:Advert;
		private var _config:AdvertConfig;
		private var _data:Object;
		private var _zip:ZipFileWriter;
		private var _outputFile:File;
		
		protected var $extension:String;
		protected var $path:String = "";
		protected var $id:String = "";
		
		public function Export(advert:Advert):void {
			_advert = advert;
			_config = Config.getConfigurationForAdvertType(_advert.getType());
		}
		
		protected function output():void {
			
			if(_outputFile == null) {
				resolveFileLocation();
				return;
			}
			
			// Open new ZIP instance
			_zip = new ZipFileWriter();
			_zip.open(_outputFile);
			
			// Parse and add JSON to ZIP 
			try {
				parseAdvertData();
				// --- Maybe should use direct file reference from initial image section
				// --- Allowing users to compress optimally locally, and push into the package.
				var bytes:ByteArray = getDataAsJSONStringByteArray();
				_zip.addBytes(bytes, JSON_FILENAME);
			} catch(error:Error) {
				trace(error.message);
			}
			
			// Add images to ZIP
			var layers:Array = _advert.getLayers();
			var layer:Layer;
			for(var i:Number = 0; i<layers.length; i++) {
				layer = layers[i] as Layer;
				_zip.addFile(
					layer.getImage().getFile(), 
					layer.getImage().getImageFilename()
				);
			}
			
			// Finish up
			_zip.close();
			OUTPUT_COUNT++;
			//
			dispatchEvent(new ExportEvent(ExportEvent.SAVED));
		}
		
		private function resolveFileLocation():void {
			var file:File = new File();
			file.addEventListener(Event.SELECT, onFileSelect);
			file.browseForSave("Save file");
		}
		
		private function onFileSelect(event:Event):void {
			_outputFile = event.target as File;
			if( _outputFile.extension !== $extension) {
				_outputFile.url +=  "." + $extension;
			}
			output();
		}
		
		private function parseAdvertData():void {
			_data = new Object();
			// Do everything in REVERSE as JSONEcoder traverses bottom up and alphabetises... sometimes
			_data.stack = new Array();
			var layers:Array = _advert.getLayers();
			if(layers.length) {
				var layer:Layer;
				var itemLayer:Object;
				for(var i:Number = 0; i<layers.length; i++) {
					layer = layers[i] as Layer;
					itemLayer = new Object();
					itemLayer.media = new Object();
					itemLayer.media.type = IMAGE_MEDIA_TYPE;
					itemLayer.media.reference = $path + layer.getImage().getImageFilename();
					
					var hotspots:Array = layer.getHotspots();
					if(hotspots.length) {
						itemLayer.hotspots = new Array();
						var hotspot:Hotspot;
						var itemHotspot:Object;
						
						for(var o:Number = 0; o<hotspots.length; o++) {
							hotspot = hotspots[o] as Hotspot;
							// Create hotspot regardless of URL/target state
							itemHotspot = new Object();
							itemHotspot.top = hotspot.y;
							itemHotspot.left = hotspot.x;
							itemHotspot.width = hotspot.width;
							itemHotspot.height = hotspot.height;
							
							if(_config.canTargetLayers() && hotspot.getTargetLayerName().length ) {
								// Convert the name to a numerical position, relevant to order
								var position:int = _advert.getLayerPositionByName( hotspot.getTargetLayerName() );
								if(position > 0) {
									itemHotspot.targetLayer = position;
								} 
							} else if(hotspot.getTargetUrl().length ) {
								itemHotspot.targetURL = hotspot.getTargetUrl(); 
							}
							itemLayer.hotspots.push(itemHotspot);
						}
					}
					_data.stack.push(itemLayer);
				}
			}
			
			_data.views = new Object();
			
			if(_advert.getType() == Config.TYPE_ZOOM) {
				_data.initialZoomLayerSize = new Object();
				_data.initialZoomLayerSize.width = _advert.getZoomSize().width;
				_data.initialZoomLayerSize.height = _advert.getZoomSize().height;
			}
			
			if(_advert.getType() == Config.TYPE_SLIDE) {
				_data.vertical = true;
			}
			
			_data.campaignID = $id;
			_data.size = Config.mapSize(_advert.getSize());	
			
			_data.background = "";
			_data.frameworkVersion = GuardianAdBuilder.FRAMEWORK_VERSION;
			_data.applicationReleaseVersion = GuardianAdBuilder.APPLICATION_RELEASE;
			_data.type = Config.mapType(_advert.getType());
			
		}
		
		private function getDataAsJSONStringByteArray():ByteArray {
			var encoder:JSONEncoder = new JSONEncoder(_data);
			var byte:ByteArray = new ByteArray();
			byte.writeUTFBytes(encoder.getString());
			return(byte);
		}
		
	}
}
