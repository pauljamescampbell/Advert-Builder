package com.guardian.advertbuilder.advert {
	import com.guardian.advertbuilder.Config;
	import com.guardian.advertbuilder.errors.AdvertError;
	import flash.geom.Rectangle;
	/**
	 * @author plcampbell
	 */
	public class Advert {
		
		private var _size:String;
		private var _background:Image;
		private var _type:String;
		private var _layers:Array = new Array();
		private var _zoomSize:Rectangle = new Rectangle(0, 0, 836, 334);
		
		/*
		registerClassAlias("com.guardian.advertbuilder.advert.Layer", Layer);
		registerClassAlias("com.guardian.advertbuilder.advert.LayerImage", LayerImage);
		registerClassAlias("com.guardian.advertbuilder.advert.Hotspot", Hotspot);
		 */
		 
		public function Advert(size:String = null, type:String = null) {
			_size = size;
			_type = type;
		}
		 
		public function getSize() : String {
			return( _size );
		}
		
		public function getTotalFilesize(conversion:String = null):Number {
			if(conversion == null) {
				conversion = Image.FILESIZE_IN_BYTES;
			}
			var total:Number = 0;
			var layer:Layer;
			for(var i:Number = 0; i<_layers.length; i++) {
				layer = _layers[i] as Layer;
				if(layer.hasImage()) {
					total += layer.getImage().getImageFilesize(conversion);
				}
			}
			return(total);
		}
		
		public function getType() : String {
			return( _type );
		}
		
		public function getZoomSize():Rectangle {
			return(_zoomSize);
		}
		
		public function getLayers():Array {
			return(_layers);
		}
		
		/*
		 * Setters
		 * 
		 * 
		 */
		public function addLayer( layer:Layer ):Layer {
			_layers.push(layer);
			return(layer);
		}
		
		public function isLayerNameAvailable(name:String):Boolean {
			for(var i:Number = 0; i<_layers.length; i++) {
				if( (_layers[i] as Layer).getName() == name ) {
					return(false);
				}
			}
			return(true);
		}
		
		
		public function destroy():void {
			var image:Image;
			for(var i:Number = 0;i<getLayers().length; i++) {
				image = (getLayers()[i] as Layer).getImage();
				if(image) {
					image.destroy();
				}
			}
		}
		
		public function moveLayer(layer:Layer, amount:int):Boolean{
			var index:int = _layers.indexOf(layer);
			var loc:int = index + amount;
			if(loc > -1 || loc < _layers.length) { 
				_layers.splice(index, 1); // take it out
				_layers.splice(loc, 0, layer); // put it back in
				return(true);
			}
			return(false);
		}
		
		public function removeLayer(layer:Layer):void {
			var index:int = _layers.indexOf(layer);
			if(index > -1) {
				layer.remove();
				_layers[index] = null;
				_layers.splice(index, 1);
			}
		}
		
		public function getLayerPositionByName(layerName:String):int {
			var layer:Layer;
			 for(var i:int = 0; _layers.length; i++) {
				layer = _layers[i] as Layer;
				if(layer.getName() == layerName) {
					return(i + 1);	
				}
			 }
			 return(0);
		}
		
		 
		/*
		 * Checkers
		 * 
		 * 
		 */
		public function isExportReady():Boolean {
			var config:AdvertConfig = Config.getConfigurationForAdvertType(getType());
			if(_layers.length > config.maxLayers()) {
				throw new AdvertError("Too many layers", AdvertError.TOO_MANY_LAYERS);
				return(false);
			}
			if(_layers.length < config.minLayers()) {
				throw new AdvertError("Too few layers", AdvertError.TOO_FEW_LAYERS);
				return(false);
			}
			/*
			 Too much checking!!!
			 * 
			if(config.canTargetLayers() == false) {
				var hotspots:Array;
				for(var i:Number = 0;i<_layers.length; i++) {
					hotspots = (_layers[i] as Layer).getHotspots();
					for(var a:Number = 0;a<hotspots.length;a++) {
						if((hotspots[a] as Hotspot).getTargetLayer()) {
							throw new AdvertError("You can't link to other layers in this ad type", AdvertError.INVALID_LAYER_LINK);
							return(false);
						}
					}
				}
			}
			*/
			return(true);
		} 
		
	}
}
