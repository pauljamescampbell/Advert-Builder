package com.guardian.advertbuilder.views.palettes {
	import com.guardian.advertbuilder.events.DocumentEvent;
	import flash.events.MouseEvent;
	
	/**
	 * @author plcampbell
	 */
	public class MenuBar extends UIMenuBar {
		
		public function MenuBar() {
			disablePreview();
			disableExport();
			buttonSave.addEventListener(MouseEvent.CLICK, onSave);
			buttonNew.addEventListener(MouseEvent.CLICK, onNew); 
		}
		
		public function enablePreview():void {
			buttonPreview.enabled = true;
			buttonPreview.addEventListener(MouseEvent.CLICK, onPreview);
		}
		
		public function disablePreview():void {
			buttonPreview.enabled = false;
			buttonPreview.removeEventListener(MouseEvent.CLICK, onPreview);
		}
		
		public function enableExport():void {
			buttonExport.enabled = true;
			buttonExport.addEventListener(MouseEvent.CLICK, onExport);	
		}
		
		public function disableExport():void {
			buttonExport.enabled = false;
			buttonExport.removeEventListener(MouseEvent.CLICK, onExport);	
		}
		
		private function onNew(event:MouseEvent):void {
			dispatchEvent(new DocumentEvent(DocumentEvent.NEW));
		}
		
		private function onPreview(event:MouseEvent):void {
			dispatchEvent(new DocumentEvent(DocumentEvent.PREVIEW));
		}
		
		private function onSave(event:MouseEvent):void {
			dispatchEvent(new DocumentEvent(DocumentEvent.SAVE));
		}
		
		private function onExport(event:MouseEvent):void {
			dispatchEvent(new DocumentEvent(DocumentEvent.EXPORT));
		}
	}
}
