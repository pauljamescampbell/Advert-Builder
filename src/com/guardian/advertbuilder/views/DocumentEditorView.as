package com.guardian.advertbuilder.views 
{
	import com.guardian.advertbuilder.events.LayerEvent;
	import com.guardian.advertbuilder.utils.StageResizer;
	import com.guardian.advertbuilder.errors.AdvertError;
	import com.guardian.advertbuilder.advert.Advert;
	import com.guardian.advertbuilder.events.DocumentEvent;
	import com.guardian.advertbuilder.advert.AdvertConfig;
	import com.guardian.advertbuilder.advert.Layer;
	import com.guardian.advertbuilder.Config;
	import com.guardian.advertbuilder.events.AdvertEvent;
	import com.guardian.advertbuilder.events.CanvasEvent;
	import com.guardian.advertbuilder.events.ViewEvent;
	import com.guardian.advertbuilder.io.ImageImport;
	import com.guardian.advertbuilder.views.canvas.Canvas;
	import com.guardian.advertbuilder.views.palettes.HotspotPalette;
	import com.guardian.advertbuilder.views.palettes.LayerPalette;
	import com.guardian.advertbuilder.views.palettes.LayerPaletteBox;
	import com.guardian.advertbuilder.views.palettes.MenuBar;
	import com.guardian.advertbuilder.views.palettes.ToolBar;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.LabelButton;
	import fl.data.DataProvider;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author plcampbell
	 */
	public class DocumentEditorView extends Sprite implements IResizeable {
		
		private var _canvas:Canvas;
		private var _menuBar:MenuBar;
		private var _layerPalette:LayerPalette;
		private var _hotspotPalette:HotspotPalette;
		private var _toolBar:ToolBar;
		private var _toolMode:String = ToolBar.TOOL_MODE_SELECT;
		private var _typeConfig:AdvertConfig;
		
		function DocumentEditorView() {
			StageResizer.attach(this);
			//
			_canvas = new Canvas();
			_canvas.addEventListener(CanvasEvent.HOTSPOT_SELECTED, onHotspotSelected);
			_canvas.addEventListener(CanvasEvent.HOTSPOT_UNSELECTED, onHotspotUnselected);
			_canvas.addEventListener(CanvasEvent.REMOVE_HOTSPOT, onHotspotRemove);
			_canvas.addEventListener(CanvasEvent.ADD_HOTSPOT, onHotspotAdded);
			addChild(_canvas);
			//
			//_menuBar = new MenuBar();
			//addChild(_menuBar);
			//
			_layerPalette = new LayerPalette();
			addChild(_layerPalette);
			//
			_hotspotPalette = new HotspotPalette();
			_hotspotPalette.disable();
			addChild(_hotspotPalette);
			//
			_toolBar = new ToolBar();
			_toolMode = ToolBar.TOOL_MODE_SELECT;
			_toolBar.addEventListener(ViewEvent.TOOL_HOTSPOT, onToolModeSelect);
			_toolBar.addEventListener(ViewEvent.TOOL_SELECT, onToolModeSelect);
			_toolBar.addEventListener(ViewEvent.TOOL_ZOOM, onToolModeSelect);
			_toolBar.toggleToolButtonState(_toolMode);
			_canvas.setToolMode(_toolMode);
			addChild(_toolBar);
		}
		
		public function configureForType(config:AdvertConfig):void {
			_typeConfig = config;
		}
		
		
		
		public function addLayer( layer:Layer ):void {
			var layerBox:LayerPaletteBox = new LayerPaletteBox(layer);
			layer.addEventListener(AdvertEvent.IMAGE_CHANGE, onUpdateLayer);
			//layerBox.addEventListener(ViewEvent.SHOW_LAYER, onShowLayer);
			layerBox.addEventListener(LayerEvent.SHOW, onShowLayer);
			//
			_layerPalette.addLayerBox(layerBox);
			layerBox.show();
			if(_typeConfig.canTargetLayers()) {
				_hotspotPalette.addOptionForLayer(layerBox);
			}
			_hotspotPalette.disable();
			//
			showLayer(layerBox);
		}
		
		public function verifyEditorState(advert:Advert):void {
			var numOfLayers:int = advert.getLayers().length;
			if(numOfLayers > _typeConfig.maxLayers()) {
				_layerPalette.preventAddLayer();
				throw new AdvertError("Oops. You have too many layers in your advert", AdvertError.TOO_MANY_LAYERS);
			} else if(numOfLayers == _typeConfig.maxLayers()) {
				_layerPalette.preventAddLayer(); 
			} else {
				_layerPalette.enableAddLayer();
			}
			
			if(numOfLayers < _typeConfig.minLayers()) {
				//_menuBar.disablePreview();
				//_menuBar.disableExport();
			} else {
				//_menuBar.enablePreview();
				//_menuBar.enableExport();
			}
		}
		
		public function reorderLayers(layers:Array):void {
			_layerPalette.reorderLayers(layers);
		}
		
		public function removeLayer(layer:Layer):void {
			if( _layerPalette.getLayerBox(layer.getID()).isVisible() ) {
				// Only clear the canvas if you're removing the layer we can see
				_canvas.clear();
			}
			_layerPalette.removeLayerBox(layer.getID());
			if(_typeConfig.canTargetLayers()) {
				_hotspotPalette.removeLayer(layer.getID()); 
			}
		}
		
		public function showLayer(layerBox:LayerPaletteBox):void {
			_layerPalette.showLayer(layerBox);
			_canvas.showLayer(layerBox.getLayer());
			_hotspotPalette.disable();
		}
		
		public function getVisibleLayer():Layer {
			return(
				_canvas.getDisplayedLayer()
			);
		}
		
		
		public function onStageResize(event:Event):void {
			positionUI(stage.stageWidth, stage.stageHeight);
		}
		
		public function positionUI( width:Number, height:Number ):void {
			/*
			_menuBar.y = 0;
			_menuBar.x = 0;
			_menuBar.width = stage.stageWidth;
			//
			_toolBar.x = width - _toolBar.width;
			_toolBar.y = _menuBar.height;	
			//
			_layerPalette.y  = _menuBar.height + 20;
			_layerPalette.x  = 0;
			//
			_hotspotPalette.x = Math.round((width / 2) - (_hotspotPalette.width/2));
			_hotspotPalette.y = height -_hotspotPalette.height;    
			//
			_canvas.x = Math.round((width / 2) - (_canvas.width / 2));
			_canvas.y = Math.round((height/ 2) - (_canvas.height/ 2));
			 */
			 
			_toolBar.x = width - _toolBar.width;
			_toolBar.y = 0;	
			//
			_layerPalette.y  = 20;
			_layerPalette.x  = 0;
			//
			_hotspotPalette.x = Math.round((width / 2) - (_hotspotPalette.width/2));
			_hotspotPalette.y = height -_hotspotPalette.height;    
			//
			_canvas.x = Math.round((width / 2) - (_canvas.width / 2));
			_canvas.y = Math.round((height/ 2) - (_canvas.height/ 2));
		}
		
		public function setCanvasSize( width:Number, height:Number ):void {
			_canvas.setWidth(width);
			_canvas.setHeight(height);
		}
		
		public function destroy():void {
			// Null
		}
		
		private function onHotspotRemove(event:CanvasEvent):void {
			var layer:Layer = getVisibleLayer();
			layer.removeHotspot(event.hotspot);
			_hotspotPalette.disable();
		}
		
		private function onHotspotSelected(event:CanvasEvent):void {
			_hotspotPalette.enable(event.hotspot);
		}
		
		private function onHotspotUnselected(event:CanvasEvent):void {
			_hotspotPalette.disable();
		}
		
		private function onHotspotAdded(event:CanvasEvent):void {
			getVisibleLayer().setHotspot(event.hotspot);
			_hotspotPalette.enable(event.hotspot);
		}
		
		public function getToolMode():String {
			return(_toolMode);
		}
		
		private function onToolModeSelect(event:ViewEvent):void {
			switch(event.type) {
				case ViewEvent.TOOL_HOTSPOT:
					_toolMode = ToolBar.TOOL_MODE_HOTSPOT;
					break;
				case ViewEvent.TOOL_SELECT:
					_toolMode = ToolBar.TOOL_MODE_SELECT;
					break;
				case ViewEvent.TOOL_ZOOM:
					_toolMode = ToolBar.TOOL_MODE_ZOOM;
					break;
			}
			_toolBar.toggleToolButtonState(_toolMode);
			_canvas.setToolMode(_toolMode);
			_hotspotPalette.disable(); // As clearly the user isnt in a phase of selecting a hotspot
		}
		
		private function onShowLayer(event:LayerEvent):void {
			showLayer( event.target as LayerPaletteBox );
		}
		
		private function onUpdateLayer(event:AdvertEvent):void {
			switch(event.type) {
				case AdvertEvent.IMAGE_CHANGE :
					var layerBox:LayerPaletteBox = _layerPalette.getLayerBox((event.target as Layer).getID());
					if(layerBox) {
						showLayer( layerBox );
					}
					break;
			}
		}
		
	}
}
