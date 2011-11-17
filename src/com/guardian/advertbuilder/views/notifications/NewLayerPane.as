package com.guardian.advertbuilder.views.notifications {
	import com.guardian.advertbuilder.views.IResizeable;
	import com.guardian.advertbuilder.events.NewLayerEvent;
	import flash.display.Sprite;
	import com.guardian.advertbuilder.utils.StageResizer;
	import flash.events.Event;
	import com.guardian.advertbuilder.events.AlertEvent;
	import flash.events.MouseEvent;
	/**
	 * @author plcampbell
	 */
	public class NewLayerPane extends UINewLayer implements IResizeable {
		
		public static var LAYER_NUM:uint = 1; 
		
		private static var PANE:NewLayerPane;
		private static var PARENT:Sprite;
		
		public function NewLayerPane() {
			StageResizer.attach(this);
			//
			buttonOk.addEventListener(MouseEvent.CLICK, onOkClick);
			buttonCancel.addEventListener(MouseEvent.CLICK, onCancelClick);
		}
		
		public static function parent(sprite:Sprite):void {
			PARENT = sprite;
		}
		
		public static function show():NewLayerPane {
			if(PANE) {
				PANE.remove();
				PANE = null;
			}
			PANE = new NewLayerPane();
			PANE.layerName.text = "New Layer " + LAYER_NUM++;
			PARENT.addChild(PANE);
			return(PANE);
		}
				
		public function onStageResize(event:Event):void {
			PANE.x = Math.round((stage.stageWidth / 2) - (PANE.getBounds(this).width/2));
			PANE.y = Math.round((stage.stageHeight / 2) - (PANE.getBounds(this).height/2));
		}
		
		private function remove():void {
			if(parent) {
				parent.removeChild(PANE);
			}
		}
		
		private function onOkClick(event:MouseEvent):void {
			remove();
			var layerEvent:NewLayerEvent = new NewLayerEvent(AlertEvent.OK);
			layerEvent.text = this.layerName.text;
			dispatchEvent(layerEvent);
		}
		
		private function onCancelClick(event:MouseEvent):void {
			remove();
			dispatchEvent(new NewLayerEvent(AlertEvent.CANCEL));
		}
		
	}
}
