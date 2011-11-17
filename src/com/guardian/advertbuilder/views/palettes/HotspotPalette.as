package com.guardian.advertbuilder.views.palettes {
	import com.guardian.advertbuilder.advert.Hotspot;
	import com.guardian.advertbuilder.advert.Layer;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;
	import flash.events.Event;
	/**
	 * @author plcampbell
	 */
	public class HotspotPalette extends UIHotspotPalette {
		
		public static const OPTION_NONE_SELECTED:String = "None selected";
		
		private var _selectedHotspot:Hotspot;
		
		public function HotspotPalette() {
			disable();
			//
			var data:DataProvider = comboLayers.dataProvider;
			data.addItem({ label: OPTION_NONE_SELECTED } );
			comboLayers.dataProvider = data;
		}
		
		public function disable():void {
			inputUrl.text = "";
			inputUrl.enabled = false;
			inputUrl.editable = false;
			comboLayers.selectedIndex = 0;
			comboLayers.enabled = false;
			comboLayers.editable = false;
			comboLayers.selectedIndex = 0;
			//
			inputUrl.removeEventListener(Event.CHANGE, onUrlChange);
			comboLayers.removeEventListener(Event.CHANGE, onLayerChange);
		}
		
		public function enable(hotspot:Hotspot):void {
			disable();
			_selectedHotspot = hotspot;
			if(hotspot.getTargetUrl().length > 0) {
				inputUrl.text = hotspot.getTargetUrl();
			} 
			if(hotspot.getTargetLayerName().length) {
				var index:int = comboLayers.dataProvider.getItemIndex({ label: hotspot.getTargetLayerName()} );
				comboLayers.selectedIndex = index;
			}
			//
			calibrateInputStates();
			inputUrl.addEventListener(Event.CHANGE, onUrlChange);
			comboLayers.addEventListener(Event.CHANGE, onLayerChange);
		}
		
		public function addOptionForLayer(layerBox:LayerPaletteBox):void {
			var data:DataProvider = comboLayers.dataProvider;
			data.addItem({ label: layerBox.getName(), data: layerBox.getLayer().getID() });
			comboLayers.dataProvider = data;
			comboLayers.editable = false;
		}
		
		public function removeLayer(layerId:Number):void {
			var data:DataProvider = comboLayers.dataProvider;
			for(var i:Number= 0; i<data.length; i++) {
				if(data.getItemAt(i).data == layerId) {
					data.removeItemAt(i);
				}
				break;
			}
			comboLayers.dataProvider = data;
		}
		
		private function calibrateInputStates():void {
			comboLayers.enabled = true;
			inputUrl.enabled = true;
			inputUrl.editable = true;
			/*
			if(inputUrl.text.length == 0 && comboLayers.dataProvider.length > 2) {
				comboLayers.enabled = true;
			} else {
				comboLayers.enabled = false; 
				comboLayers.editable = false;
			}
			if(comboLayers.selectedIndex == 0) {
				inputUrl.enabled = true;
				inputUrl.editable = true;
			} else {
				inputUrl.enabled = false;
				inputUrl.editable = false; 
			}
			 */
		}
		
		private function onUrlChange(event:Event):void {
			_selectedHotspot.setTargetUrl( inputUrl.text );
			_selectedHotspot.setTargetLayerName(""); // Nullify
			calibrateInputStates();
		}
		
		private function onLayerChange(event:Event):void {
			if( comboLayers.selectedIndex > 0 ) {
				_selectedHotspot.setTargetLayerName( comboLayers.selectedLabel as String );
				_selectedHotspot.setTargetUrl(""); // Nullify
			}
			calibrateInputStates();
		}
		
	}
}
