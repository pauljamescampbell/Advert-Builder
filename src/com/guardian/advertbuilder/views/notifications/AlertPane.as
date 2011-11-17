package com.guardian.advertbuilder.views.notifications {
	import com.guardian.advertbuilder.views.IResizeable;
	import flash.display.Sprite;
	import com.guardian.advertbuilder.utils.StageResizer;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	import flash.text.TextFormatAlign;
	import com.guardian.advertbuilder.events.AlertEvent;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	/**
	 * @author plcampbell
	 */
	public class AlertPane extends UIAlert implements IResizeable {
		
		private static var ALERT:AlertPane;
		private static var PARENT:Sprite;
		
		public function AlertPane(text:String) {
			StageResizer.attach(this);
			//
			var format:TextFormat = textAlert.getTextFormat();
			format.align = TextFormatAlign.CENTER;
			textAlert.multiline = true;
			textAlert.autoSize = TextFieldAutoSize.LEFT;
			textAlert.text = text;
			textAlert.setTextFormat(format);
			//
			buttonOk.addEventListener(MouseEvent.CLICK, onOK);
			buttonCancel.addEventListener(MouseEvent.CLICK, onCancel);
		}
		
		public static function parent(sprite:Sprite):void {
			PARENT = sprite;
		}
		
		public static function show(...args):AlertPane {
			if(ALERT) {
				ALERT.remove();
				ALERT = null;
			}
			ALERT = new AlertPane(args.join(" "));
			PARENT.addChild(ALERT);
			return(ALERT);
		}
				
		public function onStageResize(event:Event):void {
			ALERT.x = Math.round((stage.stageWidth / 2) - (ALERT.getBounds(this).width/2));
			ALERT.y = Math.round((stage.stageHeight / 2) - (ALERT.getBounds(this).height/2));
		}
		
		private function remove():void {
			if(parent) {
				parent.removeChild(ALERT);
			}
		}
		
		private function onOK(event:MouseEvent):void {
			remove();
			dispatchEvent(new AlertEvent(AlertEvent.OK));
		}
		
		private function onCancel(event:MouseEvent):void {
			remove();
			dispatchEvent(new AlertEvent(AlertEvent.CANCEL));
		}
		
	}
}
