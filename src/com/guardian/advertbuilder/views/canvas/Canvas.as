package com.guardian.advertbuilder.views.canvas {
	import com.guardian.advertbuilder.events.HotspotEvent;
	import flash.events.ContextMenuEvent;
	import org.bytearray.gif.player.GIFPlayer;
	import com.guardian.advertbuilder.advert.Hotspot;
	import com.guardian.advertbuilder.advert.Layer;
	import com.guardian.advertbuilder.events.AdvertEvent;
	import com.guardian.advertbuilder.events.CanvasEvent;
	import com.guardian.advertbuilder.events.ViewEvent;
	import com.guardian.advertbuilder.views.palettes.ToolBar;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * @author plcampbell
	 */
	public class Canvas extends Sprite {

		public static const MIN_HOTSPOT_SIZE:int = 2;

		private var _layer:Layer;
		private var _canvas:UICanvas;
		private var _sprite:Sprite;
		private var _selectedHotspot:CanvasHotspot;
		private var _hotspotsArray:Array;
		private var _hotspotsSprite:Sprite;
		private var _toolMode:String;
		private var _newHotspot:CanvasHotspot;
		
		public function Canvas() {
			_canvas = new UICanvas();
			addChild(_canvas);
			addEventListener(HotspotEvent.REMOVE, onDeleteHotspot); // global event catcher
		}
		
		/*
		 * Getters
		 * 
		 * 
		 */
		public function getDisplayedLayer():Layer {
			return(_layer);
		}
		
		/*
		 * Setters
		 * 
		 * 
		 */
		public function setHeight(height:Number):void {
			_canvas.height = height + 1;
		}

		public function setWidth(width:Number) : void {
			_canvas.width = width + 1;
		}
		
		public function setToolMode(mode:String):void {
			_toolMode = mode;
			setMouseCursorForToolMode();
		}
		
		private function setMouseCursorForToolMode():void {
			switch(_toolMode) {
				case ToolBar.TOOL_MODE_SELECT :
					//Mouse.cursor = MouseCursor.HAND;
					break;
				default :
					//Mouse.cursor = MouseCursor.ARROW;
					break;
			}
		}
		 
		private function addNewHotspot(x:Number, y:Number):void {
			_newHotspot = new CanvasHotspot();
			_newHotspot.update(new Hotspot(x, y));
			_newHotspot.setOriginPoint(new Point(x,y));
			_newHotspot.width = _newHotspot.height = 0;
			_newHotspot.x = x;
			_newHotspot.y = y;
			_hotspotsSprite.addChild(_newHotspot);
			//
			_sprite.addEventListener(Event.ENTER_FRAME, onDrawNewHotspot);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpOrOut);
		}
		
		private function addImage():void {
			if(_layer.getImage().isAnimated()) {
				var gif:GIFPlayer = _layer.getImage().getAnimation();
				gif.play();
				_sprite.addChildAt( gif, 0 );
				gif.x = gif.y = 1;
			} else {
				_sprite.addChildAt( _layer.getImage().getBitmap(), 0 );
				_layer.getImage().getBitmap().x = _layer.getImage().getBitmap().y = 1;
			}
		}
		
		private function addHotspots():void {
			removeHotspots();
			//
			_hotspotsSprite = new Sprite();
			_sprite.addChild(_hotspotsSprite);
			//
			var canvasHotspot:CanvasHotspot;
			var hotspots:Array = _layer.getHotspots();
			//
			for(var a:Number = 0; a<hotspots.length;a++) {
				canvasHotspot = new CanvasHotspot();
				canvasHotspot.update(hotspots[a] as Hotspot);
				_hotspotsSprite.addChild(canvasHotspot);
			}
		}
		 
		/*
		 * Modifiers
		 * 
		 * 
		 */
		public function showLayer(newLayer:Layer):void {
			// Clear remenants of old layer if there
			if(_sprite !== null) {
				clear();
			}
			_layer = newLayer;
			if(_layer.hasImage()) {
				_sprite = new Sprite();
				_sprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				addChild(_sprite);
				addImage();
				addHotspots();
			}
		}
		
		public function clear():void {
			// Has the layer got an image yet? If not, dont worry bout other stuff
			if(_layer.hasImage()) {
				// Trash all the ad display elements
				_sprite.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				//_sprite.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUpOrOut);
				_sprite.removeChild(_hotspotsSprite);
				if(_layer.getImage().isAnimated()) {
					_sprite.removeChild(_layer.getImage().getAnimation());
				} else {
					_sprite.removeChild(_layer.getImage().getBitmap());	
				}
				removeChild(_sprite);
				//
				_hotspotsSprite = null;
				_hotspotsArray = null;
				_sprite = null;
				_layer = null;
			}
		}
		
		private function selectHotspot(hotspot:CanvasHotspot):void {
			if(_selectedHotspot !== null) {
				unselectHotspot();
			}

			_selectedHotspot = hotspot;
			var rect:Rectangle = _canvas.getRect(this).clone();
			rect.width -= _selectedHotspot.width;
			rect.height -= _selectedHotspot.height;
			//
			_selectedHotspot.startDrag(false, rect);
			_selectedHotspot.highlight();
			//
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpOrOut);
		}
		
		private function onDeleteHotspot(event:HotspotEvent):void {
			if(event.target is CanvasHotspot) {
				selectHotspot(event.target as CanvasHotspot);
				removeSelectedHotspot();
			}
		}
		
		private function removeSelectedHotspot():void {
			var hotspot:CanvasHotspot = _selectedHotspot;
			var event:CanvasEvent = new CanvasEvent(CanvasEvent.REMOVE_HOTSPOT);
			event.hotspot = _selectedHotspot.getHotspot();
			dispatchEvent(event);
			unselectHotspot();
			_hotspotsSprite.removeChild(hotspot);
		}
		
		private function stopDraggingSelectedHotspot():void {
			if(_selectedHotspot) {
				_selectedHotspot.stopDrag();
				_selectedHotspot.updateHotspotPosition();
			}
		}
		
		private function unselectHotspot():void {
			if(_selectedHotspot) {
				_selectedHotspot.downlight();
				_selectedHotspot.removeEventListener(HotspotEvent.REMOVE, onDeleteHotspot);
				_selectedHotspot = null;
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpOrOut);	
			}
		}
		
		private function finishNewHotspot():void {
			if(_newHotspot !== null) {
				_sprite.removeEventListener(Event.ENTER_FRAME, onDrawNewHotspot);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpOrOut);
				//
				if(_newHotspot.width > MIN_HOTSPOT_SIZE && _newHotspot.width > MIN_HOTSPOT_SIZE) {
					var event:CanvasEvent = new CanvasEvent(CanvasEvent.ADD_HOTSPOT);
					_newHotspot.updateHotspotPosition();
					event.hotspot = _newHotspot.getHotspot();
					dispatchEvent(event);	
				}
				_newHotspot = null;
			}
		}
		
		private function removeHotspots():void {
			if(_hotspotsSprite !== null) {
				for(var i:Number = 0; i<_hotspotsSprite.numChildren; i++) {
					_hotspotsSprite.removeChildAt(i);
				}
				_sprite.removeChild(_hotspotsSprite);
			}
		}
		
		private function onMouseDown(event:MouseEvent):void {
			switch(_toolMode) {
				case ToolBar.TOOL_MODE_SELECT :
					if(event.target is CanvasHotspot && _hotspotsSprite.contains(event.target as CanvasHotspot)) {
						var ce:CanvasEvent = new CanvasEvent(CanvasEvent.HOTSPOT_SELECTED); 
						ce.hotspot = (event.target as CanvasHotspot).getHotspot();
						dispatchEvent(ce);
						selectHotspot(event.target as CanvasHotspot);
					} else {
						// Clicked elsewhere on the canvas
						dispatchEvent(new CanvasEvent(CanvasEvent.HOTSPOT_UNSELECTED));
						unselectHotspot();
					}
				 	break;
					
				case ToolBar.TOOL_MODE_HOTSPOT :
					addNewHotspot(event.localX, event.localY);
					break;
			}
		}
		
		private function onMouseUpOrOut(event:MouseEvent):void {
			switch(_toolMode) {
				case ToolBar.TOOL_MODE_HOTSPOT :
					finishNewHotspot();
					break;
				
				case ToolBar.TOOL_MODE_SELECT :
					stopDraggingSelectedHotspot();
			}
		}
		
		private function onDrawNewHotspot(event:Event):void {
			trace(_newHotspot.getOriginPoint().x);
			
			var relX:Number = Math.max(0, Math.min(_canvas.width, _sprite.mouseX));
			var relY:Number = Math.max(0, Math.min(_canvas.height, _sprite.mouseY));
			var nX:Number = Math.floor(relX - _newHotspot.getOriginPoint().x);
			var nY:Number = Math.floor(relY - _newHotspot.getOriginPoint().y);
			
			if(nX < 0) {
				_newHotspot.x = relX;
				_newHotspot.width = Math.abs(nX);
			} else {
				_newHotspot.width = nX;
			}
			
			if( nY < 0) {
				_newHotspot.y = relY;
				_newHotspot.height = Math.abs(nY); 
			} else {
				_newHotspot.height = nY;
			}
			
		}
		
	}
}
