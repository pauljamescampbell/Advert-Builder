package com.guardian.advertbuilder.utils {
	import com.guardian.advertbuilder.views.IResizeable;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Sprite;
	/**
	 * @author plcampbell
	 */
	
	public class StageResizer {
		
		public static function attach(object:Sprite): void {
			object.addEventListener(Event.ADDED_TO_STAGE, StageResizer.ready );
			object.addEventListener(Event.ADDED_TO_STAGE, (object as IResizeable).onStageResize);
			object.addEventListener(Event.REMOVED_FROM_STAGE, StageResizer.remove );
		}
		
		public static function ready(event:Event):void {
			var sprite:Sprite = (event.target as Sprite);
			var inter:IResizeable = (event.target as IResizeable);
			sprite.stage.addEventListener(Event.RESIZE, function(event:Event):void {
				trace(1);
			});
			sprite.stage.addEventListener(Event.RESIZE, inter.onStageResize);
			sprite.removeEventListener(Event.ADDED_TO_STAGE, inter.onStageResize);
			sprite.removeEventListener(Event.ADDED_TO_STAGE, StageResizer.ready); 
		}
		
		public static function remove(event:Event):void {
			(event.target as Sprite).stage.removeEventListener(Event.RESIZE, (event.target as IResizeable).onStageResize);
			(event.target as Sprite).removeEventListener(Event.REMOVED_FROM_STAGE, StageResizer.remove );
		}
		
	}
	
}
