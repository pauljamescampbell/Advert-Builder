package com.guardian.advertbuilder.views.palettes {
	import com.guardian.advertbuilder.views.IDraggable;
	import com.guardian.advertbuilder.advert.Layer;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import com.guardian.advertbuilder.events.LayerEvent;
	import com.guardian.advertbuilder.events.ViewEvent;
	import fl.controls.ComboBox;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author plcampbell
	 */
	public class LayerPalette extends UILayerPalette implements IDraggable {
		
		private static const LAYER_POSITION_X:Number = 3;
		private static const LAYER_POSITION_Y:Number = 25;
		private static const LAYER_MARGIN:Number = 1;
		
		private var _layerSprite:Sprite;
		
		public function LayerPalette() {
			_layerSprite = new Sprite();
			_layerSprite.x = LAYER_POSITION_X;
			_layerSprite.y = LAYER_POSITION_Y;
			addChild(_layerSprite);
			enableAddLayer();
			//_menu = new LayerContextMenu(this);
		}
		
		public function addLayerBox(layer:LayerPaletteBox):void {
			//layer.addEventListener(LayerEvent.MOVE_UP, onMoveLayerUp);
			//layer.addEventListener(LayerEvent.MOVE_DOWN, onMoveLayerDown);
			_layerSprite.addChild( layer ); 
			resetLayerSprite();
		}
		
		public function preventAddLayer():void {
			buttonLayerAdd.enabled = false;
			buttonLayerAdd.removeEventListener(MouseEvent.CLICK, onAddLayer);
		}
		
		public function enableAddLayer():void {
			buttonLayerAdd.enabled = true;
			buttonLayerAdd.addEventListener(MouseEvent.CLICK, onAddLayer);
		}
		
		public function numberOfLayers():Number {
			return(_layerSprite.numChildren);
		}
		
		public function showLayer(layerBox:LayerPaletteBox):void { 
			for(var i:Number = 0; i<_layerSprite.numChildren; i++) {
				(_layerSprite.getChildAt(i) as LayerPaletteBox).hide();
			}
			layerBox.show();
		}
		
		public function getLayerBox(layerId:Number):LayerPaletteBox {
			var layer:LayerPaletteBox;
			for(var i:Number = 0; i<_layerSprite.numChildren; i++) {
				layer = _layerSprite.getChildAt(i) as LayerPaletteBox;
				if( layer.getLayer().getID() == layerId) {
					return(layer);
				}
			}
			return(null);
		}
		
		public function removeLayerBox(layerId:Number):void {
			var layer:LayerPaletteBox;
			for(var i:Number = 0; i<_layerSprite.numChildren; i++) {
				layer = _layerSprite.getChildAt(i) as LayerPaletteBox;
				if( layer.getLayer().getID() == layerId) {
					_layerSprite.removeChild(layer);
					layer = null;
				}
			}
			resetLayerSprite();
		}
		
		public function reorderLayers(newLayers:Array):void {
			var layer:Layer;
			var layerPalette:LayerPaletteBox;
			for(var i:int = 0; i<newLayers.length; i++) {
				layer = newLayers[i];
				for(var e:int = 0; e<_layerSprite.numChildren; e++) {
					layerPalette = _layerSprite.getChildAt(e) as LayerPaletteBox;
					if(layerPalette.getLayer() !== layer) {
						_layerSprite.swapChildrenAt(i, e);
					}
				}
			}
			resetLayerSprite();
		}
		
		private function resetLayerSprite():void {
			var disp:DisplayObject;
			for(var i:Number = 0; i<_layerSprite.numChildren;i++) {
				disp = _layerSprite.getChildAt(i);
				disp.y = (disp.height * i) + (LAYER_MARGIN * i);
				(disp as LayerPaletteBox).bg.alpha = (i % 2);
			}
		}
		
	
		/*
		private function onMoveLayerDown(event:LayerEvent):void {
			var layer:LayerPaletteBox = event.target as LayerPaletteBox;
			if(_layers.contains(layer)) {
				var index:int = _layers.getChildIndex(layer);
				if(index+1 < _layers.numChildren) {
					_layers.swapChildrenAt(index, index+1);	
				}
			}
			reorderLayers();
		}
		
		private function onMoveLayerUp(event:LayerEvent):void {
			var layer:LayerPaletteBox = event.target as LayerPaletteBox;
			if(_layers.contains(layer)) {
				var index:int = _layers.getChildIndex(layer);
				if(index-1 >= 0) {
					_layers.swapChildrenAt(index, index-1);	
				}
			}
			reorderLayers();
		}
		*/
		
		private function onAddLayer(event:Event) : void {
			dispatchEvent(new ViewEvent( ViewEvent.ADD_LAYER ));
		}
		
	}
}
