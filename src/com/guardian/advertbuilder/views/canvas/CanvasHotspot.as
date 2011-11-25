package com.guardian.advertbuilder.views.canvas {
	import com.guardian.advertbuilder.events.HotspotEvent;
	import flash.ui.ContextMenu;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	import com.guardian.advertbuilder.advert.Hotspot;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author plcampbell
	 */
	public class CanvasHotspot extends Sprite {
		
		public static const HIGHLIGHT_LINE_THICKNESS:Number = 1;
		public static const COLOUR:uint = 0x00fff6;
		
		private var _hotspot:Hotspot;
		private var _originPoint:Point;
		private var _menu:ContextMenu;
		private var _highlight:Sprite;
		
		public function CanvasHotspot() {
			mouseChildren = false;
			graphics.beginFill(COLOUR, .5);
			graphics.drawRect(0, 0, 1, 1);
			graphics.endFill();
			//
			addContextMenu();
		}
			
		private function addContextMenu() {
			_menu = new ContextMenu();
			_menu.hideBuiltInItems();
			var item:ContextMenuItem = new ContextMenuItem("Delete hotspot");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuSelect);
			_menu.customItems.push(item);
			this.contextMenu = _menu;
		}
		
		private function onMenuSelect(event:ContextMenuEvent):void {
			if(event.mouseTarget == this) {
				dispatchEvent(new HotspotEvent(HotspotEvent.REMOVE));
			}	
		}
		
		
		public function update(hotspot:Hotspot):void {
			_hotspot = hotspot;
			x = _hotspot.x;
			y = _hotspot.y;
			width = _hotspot.width;
			height = _hotspot.height;
		}
		
		public function updateHotspotPosition():void {
			var rect:Rectangle = getRect(this.parent);
			_hotspot.x = Math.round(rect.x);
			_hotspot.y = Math.round(rect.y);
			_hotspot.width = Math.round(rect.width);
			_hotspot.height = Math.round(rect.height);
		}
		
		public function highlight():void {
			if(_highlight !== null) {
				downlight();
			}
			_highlight = new Sprite();
			_highlight.graphics.lineStyle(HIGHLIGHT_LINE_THICKNESS, COLOUR, 2, false, LineScaleMode.NONE);
			_highlight.graphics.beginFill(0xffffff, 0);
			_highlight.graphics.drawRect(0,0, getRect(this).width, getRect(this).height);
			_highlight.graphics.endFill();
			addChild(_highlight);
		}
		
		public function downlight():void {
			if(_highlight) {
				_highlight.graphics.clear();
				if(contains(_highlight)) {
					removeChild(_highlight);
				}
				_highlight == null;
			}
		}
		
		public function getHotspot():Hotspot {
			return(_hotspot);
		}
		
		public function setOriginPoint(point:Point):void {
			_originPoint = point;
		}
		
		public function getOriginPoint():Point {
			return(_originPoint);
		}
		
	}
}
