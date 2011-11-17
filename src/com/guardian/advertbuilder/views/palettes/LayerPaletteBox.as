package com.guardian.advertbuilder.views.palettes {

	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import com.guardian.advertbuilder.events.LayerEvent;
	import com.guardian.advertbuilder.advert.Layer;
	import com.guardian.advertbuilder.events.ViewEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author plcampbell
	 */
	public class LayerPaletteBox extends UILayer {
		
		private static var NEW_LAYER_COUNT:Number = 1;
		private static var NEW_LAYER_NAME_PREFIX:String = "New layer ";
		private static var DISPLAY_LABEL_ON:String = "on";
		private static var DISPLAY_LABEL_OFF:String = "off";
		
		private var _layer:Layer;
		
		public function LayerPaletteBox( layer:Layer ) {
			_layer = layer;
			this.setName( layer.getName() );
			addEventListener(MouseEvent.DOUBLE_CLICK, onNameChange);
			buttonDelete.addEventListener(MouseEvent.CLICK, onDelete);
			buttonUp.addEventListener(MouseEvent.CLICK, onMoveUp);
			buttonDown.addEventListener(MouseEvent.CLICK, onMoveDown);
			buttonDisplay.addEventListener(MouseEvent.CLICK, onShow);
			buttonDisplay.gotoAndStop(1);
		}
		
		public function getLayer():Layer {
			return(_layer);
		}
		
		public function hide():void {
			buttonDisplay.gotoAndStop(DISPLAY_LABEL_OFF);
		}
		
		public function show():void {
			buttonDisplay.gotoAndStop(DISPLAY_LABEL_ON);
		}
		
		public function setName(name:String):void {
			_layer.setName(name);
			layerID.text = name;
		}
		
		public function getName():String {
			return(_layer.getName());
		}
		
		public function isVisible():Boolean {
			return( buttonDisplay.currentFrameLabel == DISPLAY_LABEL_ON );
		}
		
		private function onNameChange(event:MouseEvent):void {
			dispatchEvent(new LayerEvent(LayerEvent.CHANGE_NAME));
		}
		
		private function onShow(event:MouseEvent):void {
			if( isVisible() == false ) {
				dispatchEvent(new LayerEvent(LayerEvent.SHOW));
			}
		}
		
		private function onDelete(event:MouseEvent):void {
			var viewEvent:ViewEvent = new ViewEvent(ViewEvent.REMOVE_LAYER);
			viewEvent.layer = getLayer();
			dispatchEvent(viewEvent);
		}
		
		private function onMoveUp(event:MouseEvent):void {
			dispatchEvent(new LayerEvent(LayerEvent.MOVE_UP));
		}
		
		private function onMoveDown(event:MouseEvent):void {
			dispatchEvent(new LayerEvent(LayerEvent.MOVE_DOWN));
		}
		
	}
}
