package com.guardian.advertbuilder.views {
	import com.guardian.advertbuilder.utils.StageResizer;
	import com.guardian.advertbuilder.Config;
	import com.guardian.advertbuilder.events.DocumentEvent;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author plcampbell
	 */
	public class OpenDocumentView extends UIOpener implements IResizeable {
		
		public function OpenDocumentView() {
			StageResizer.attach(this);
			//
			buttonCreate.addEventListener(MouseEvent.CLICK, onCreateNewDocument);
		}
		
		public function onStageResize(event:Event):void {
			x = Math.round((stage.stageWidth / 2) - (width/2));
			y = Math.round((stage.stageHeight / 2) - (height/2));
		}
		
		public function setSizeData(data:DataProvider):void {
			comboSize.dataProvider = data;
			comboType.selectedIndex = 0;
		}
		
		public function setTypeData(data:DataProvider):void {
			comboType.dataProvider = data;
			comboType.selectedIndex = 0;
		}
		
		private function onCreateNewDocument(event:MouseEvent):void {
			var docEvent:DocumentEvent = new DocumentEvent(DocumentEvent.NEW);
			docEvent.adSize = comboSize.selectedLabel;
			docEvent.adType= comboType.selectedLabel;
			dispatchEvent(docEvent);
		}

		
	}
}
