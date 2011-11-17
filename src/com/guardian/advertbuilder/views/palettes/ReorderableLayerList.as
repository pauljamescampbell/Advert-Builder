package com.guardian.advertbuilder.views.palettes {
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/**
	 * @author plcampbell
	 */
	public class ReorderableLayerList extends Sprite {
		
		private var _box:LayerPaletteBox;
		
		public function ReorderableLayerList() {
		}
		
		public function addItem(item:LayerPaletteBox):void {
			item.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			item.y = height;
			addChild(item);
		}
		
		private function onStartDrag(event:MouseEvent):void {
			if(event.target is LayerPaletteBox) {
				_box = event.target as LayerPaletteBox;
				_box.startDrag(false, getRect(this));
				stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			}
		}
		
		private function onStopDrag(event:MouseEvent):void {
			_box.stopDrag();
			var hits:Array = getObjectsUnderPoint(new Point(_box.x, _box.y));
			if(hits.length) {
				
				for(var i:Number = 0; i<hits.length;i++) {
					if(hits[i] is LayerPaletteBox) {
						var newBox:LayerPaletteBox = hits[i];
						if(_box.y > (newBox.y + newBox.height/2)) {
							// Push it below this one
							_box.y = newBox.y + newBox.height;
						} else {
							_box.y = newBox.y;
						}
					}
				}
			}
		}
	}
}
