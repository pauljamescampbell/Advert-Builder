package com.guardian.advertbuilder.utils {
	import com.adobe.errors.IllegalStateError;
	import com.guardian.advertbuilder.views.IDraggable;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	/**
	 * @author plcampbell
	 */
	public class DraggablePalette {
		
		public static const GRAB_HEIGHT:int = 18;
		
		public static function apply(target:Sprite):void {
			target.addEventListener(MouseEvent.MOUSE_DOWN, DraggablePalette.onGrab);
			target.addEventListener(MouseEvent.MOUSE_MOVE, DraggablePalette.onOverAndOut);
			target.addEventListener(MouseEvent.MOUSE_OUT, DraggablePalette.onOverAndOut);
			target.addEventListener(MouseEvent.MOUSE_UP, DraggablePalette.onRelease);
		}
		
		private static function onOverAndOut(event:MouseEvent):void {
			var obj:Sprite = event.target as Sprite;
			if(obj is IDraggable) {
				if(event.localY <= GRAB_HEIGHT) {
					obj.useHandCursor = true;
					obj.buttonMode = true;
				} else {
					obj.buttonMode = false;
					obj.useHandCursor = false;
				}
			}
		}
		
		private static function onGrab(event:MouseEvent):void {
			var obj:Sprite = event.target as Sprite;
			if(obj is IDraggable && event.localY <= GRAB_HEIGHT) {
				obj.startDrag(false);
			}
		}
		
		private static function onRelease(event:MouseEvent):void {
			if(event.target is IDraggable) {
				(event.target as Sprite).stopDrag();
			}
		}
		
	}
}
