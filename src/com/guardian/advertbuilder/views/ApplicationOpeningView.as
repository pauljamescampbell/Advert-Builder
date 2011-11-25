package com.guardian.advertbuilder.views {
	import flash.display.Stage;
	import com.guardian.advertbuilder.utils.StageResizer;
	import flash.events.Event;
	/**
	 * @author plcampbell
	 */
	public class ApplicationOpeningView extends UILoadingScreen implements IDraggable, IResizeable {
	
		public function ApplicationOpeningView() {
			StageResizer.attach(this);
		}
		
		public function onStageResize(event:Event):void {
			x = Math.round((stage.stageWidth / 2) - (getBounds(this).width/2));
			y = Math.round((stage.stageHeight / 2) - (getBounds(this).height/2));
		}
		
	}
}
