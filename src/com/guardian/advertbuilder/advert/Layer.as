package com.guardian.advertbuilder.advert {
	import com.guardian.advertbuilder.events.AdvertEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.utils.Timer;
	import mx.utils.NameUtil;
	import org.osmf.utils.TimeUtil;
	/**
	 * @author plcampbell
	 */
	public class Layer extends EventDispatcher {	
		
		private var _image:Image;
		private var _hotspots:Array = new Array();
		private var _id:Number;
		private var _name:String;
		
		public function Layer() {
			_id = Math.floor(Math.random() * (1+10000000-1)) + 1;
		}
		
		public function getID():Number{
			return(_id);
		}
		
		public function getImage():Image {
			return(_image);
		}
		
		public function getHotspots():Array {
			return(_hotspots);
		}
		
		public function getName() : String {
			return( _name);
		}
		
		public function setName(name:String) : void {
			_name = name;
		}
		 
		 public function setLayerImage(image:Image):void {
			trace("Layer -> Image added");
			_image = image;
			dispatchEvent( new AdvertEvent(AdvertEvent.IMAGE_CHANGE) );
		}
		
		public function setHotspot(hotspot:Hotspot):void {
			trace("Adding hotspot: " + hotspot);
			_hotspots.push(hotspot);
			dispatchEvent( new AdvertEvent(AdvertEvent.HOTSPOT_CHANGE));
		}
		 
		/*
		 * Modifiers
		 * 
		 * 
		 */
		public function removeHotspot(hotspot:Hotspot):void {
			for(var i:Number = 0;i<_hotspots.length;i++) {
				if(_hotspots[i] === hotspot) {
					_hotspots.splice(i, 1);
					break;
				}
			}
			dispatchEvent( new AdvertEvent(AdvertEvent.HOTSPOT_CHANGE));
		}
		
		public function remove():void{
			_image.getBitmap().bitmapData.dispose();
			_image.getBitmap().bitmapData = null;
			_image = null;
		}
		
		/*
		 * Checkers
		 * 
		 * 
		 */
		public function hasImage():Boolean {
			return(_image !== null);
		}
		
	}
}
