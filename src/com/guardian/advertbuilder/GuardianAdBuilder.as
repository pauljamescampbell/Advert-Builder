
package com.guardian.advertbuilder {
	import flash.ui.Keyboard;
	import flash.globalization.NationalDigitsType;
	import flash.display.NativeMenuItem;
	import flash.display.NativeMenu;
	import com.guardian.advertbuilder.views.palettes.LayerPaletteBox;
	import com.guardian.advertbuilder.events.LayerEvent;
	import com.guardian.advertbuilder.events.NewLayerEvent;
	import com.guardian.advertbuilder.views.notifications.NewLayerPane;
	import mx.core.Window;
	import com.guardian.advertbuilder.views.preview.Preview;
	import com.guardian.advertbuilder.views.preview.PreviewWindow;
	import flash.filesystem.File;
	import flash.desktop.InvokeEventReason;
	import flash.events.InvokeEvent;
	import maja.air.LogApp;
	import com.guardian.advertbuilder.io.ExportForSaving;
	import com.guardian.advertbuilder.io.ExportForDelivery;
	import com.guardian.advertbuilder.views.ApplicationOpeningView;
	import flash.desktop.NativeApplication;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osmf.events.TimeEvent;
	import com.guardian.advertbuilder.events.ImportEvent;
	import com.guardian.advertbuilder.io.Import;
	import com.guardian.advertbuilder.events.ExportEvent;
	import com.guardian.advertbuilder.events.AlertEvent;
	import com.guardian.advertbuilder.advert.Advert;
	import com.guardian.advertbuilder.advert.Layer;
	import com.guardian.advertbuilder.errors.AdvertError;
	import com.guardian.advertbuilder.events.AdvertEvent;
	import com.guardian.advertbuilder.events.DocumentEvent;
	import com.guardian.advertbuilder.events.ViewEvent;
	import com.guardian.advertbuilder.io.Export;
	import com.guardian.advertbuilder.io.ImageImport;
	import com.guardian.advertbuilder.views.DocumentEditorView;
	import com.guardian.advertbuilder.views.notifications.AlertPane;
	import com.guardian.advertbuilder.views.OpenDocumentView;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class GuardianAdBuilder extends Sprite {
		
		public static const FRAMEWORK_VERSION:Number = 1;
		public static const APPLICATION_ID:String = "com.guardian.advertbuilder";
		public static const APPLICATION_RELEASE:Number = 0.1; 
		public static var ADVERT_COUNT:Number = 0; 
		
		private var _newLayerName:String;
		private var _loadingView:ApplicationOpeningView;
		private var _openView:OpenDocumentView;
		private var _documentView:DocumentEditorView;
		private var _imageImport:ImageImport;
		private var _advert:Advert;
		private var _preview:PreviewWindow;
		private var _export:Export;

		public function GuardianAdBuilder() {
			LogApp.log("initiating application");
			
			// Application confx§ig
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Kick off
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onApplicationInvoked);
			System.init();
			System.buildDock();
			System.buildSystemMenu(onMenuEvent);
			//
			AlertPane.parent(this);
			NewLayerPane.parent(this);
			//
			showLoadingScreen();
			//
			LogApp.log("application started");
		}
		
		private function onApplicationInvoked(event:InvokeEvent):void {
			// http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/InvokeEvent.html#arguments
			if(event.reason == InvokeEventReason.STANDARD) {
				// Argument param contains selected files
				if(event.arguments.length && event.arguments[0] is File) {
					// File has been opened via icon double-click
					AlertPane.show(event.type, event.reason	);
					var file:File = event.arguments[0];
					openSavedDocument(file);
				}
			}
		}
		
		private function onMenuEvent(event:Event):void {
			trace(event.target.label);
			switch(event.target.label) {
				case "New" :
					onNewAdvert();
					break;
				case "Open File" :
				case "Import" :
					onOpenAdvert();
					break;
				case "Save" :
					onSaveAdvert();
					break;
				case "Export" :
					onExportAdvert();
					break;
			}
		}
		
		private function showLoadingScreen():void {
			_loadingView = new ApplicationOpeningView();
			//
			addChild(_loadingView);
			//
			var timer:Timer = new Timer(4000, 1);
			timer.addEventListener(TimerEvent.TIMER, onRemoveLoadingScreen);
			timer.start();
		}
		
		private function onRemoveLoadingScreen(event:TimerEvent):void {
			(event.target as Timer).removeEventListener(TimerEvent.TIMER, onRemoveLoadingScreen);
			removeChild(_loadingView);
			_loadingView = null;
		}
		
		private function showOpenDialog():void {
			_openView = new OpenDocumentView();
			_openView.setSizeData(Config.getSizesAsDataProvider());
			_openView.setTypeData(Config.getTypesAsDataProvider());
			_openView.addEventListener(DocumentEvent.NEW, onOpenNewDocument);
			//
			addChild(_openView);
		}
		
		private function removeOpenDialog():void {
			_openView.removeEventListener(DocumentEvent.NEW, onOpenNewDocument);
			removeChild(_openView);
			_openView = null;
		}
		
		private function onOpenNewDocument(event:DocumentEvent):void {
			LogApp.log("created new document");
			_advert = new Advert(
				event.adSize,
				event.adType
			);
			ADVERT_COUNT++;
			removeOpenDialog();
			showDocumentEditor();
		}
		
		private function onOpenAdvert():void {
			openSavedDocument();
		}
		
		private function openSavedDocument(file:File = null):void {
			LogApp.log("open saved/export document");
			//
			var importer:Import = new Import();
			importer.addEventListener(ImportEvent.DONE, onOpenSuccessful);
			importer.addEventListener(ImportEvent.FAILED, onOpenFailed);
			importer.addEventListener(ImportEvent.INVALID_FILETYPE, onOpenFailed);
			if(file !== null) {
				// Open an invoked file
				importer.openInvokedFile(file, [ExportForDelivery.EXTENSION, ExportForSaving.EXTENSION]);
			} else {
				// Open a normal file
				importer.openFileDialog(ExportForSaving.EXTENSION);
			}
		}
		
		private function showDocumentEditor(openFromArchive:Boolean = false) : void {
			_documentView = new DocumentEditorView();
			_documentView.configureForType( Config.getConfigurationForAdvertType(_advert.getType()) );
			var rect:Rectangle = Config.getSizeForAdvertAsRectangle(_advert.getSize());
			_documentView.setCanvasSize(rect.width, rect.height);
			//
			if(openFromArchive) {
				var layers:Array = _advert.getLayers();
				for(var i:int =0; i<layers.length; i++) {
					_documentView.addLayer(layers[i] as Layer);
				}
				_documentView.verifyEditorState(_advert);
			}
			//
			//_documentView.addEventListener(ViewEvent.ADD_IMAGE, onAddImage); // dep. 21/10
			_documentView.addEventListener(ViewEvent.ADD_LAYER, onAddLayer);
			_documentView.addEventListener(LayerEvent.MOVE_DOWN, onMoveLayer);
			_documentView.addEventListener(LayerEvent.MOVE_UP, onMoveLayer);
			_documentView.addEventListener(ViewEvent.REMOVE_LAYER, onRemoveLayer);
			_documentView.addEventListener(DocumentEvent.EXPORT, onExportAdvert);
			_documentView.addEventListener(DocumentEvent.SAVE, onSaveAdvert);
			_documentView.addEventListener(DocumentEvent.NEW, onNewAdvert);
			_documentView.addEventListener(DocumentEvent.PREVIEW, onPreviewAdvert);
			_documentView.addEventListener(DocumentEvent.UPDATE, onUpdateEditorState);
			//
			addChild(_documentView);
		}
		
		private function removeDocumentEditor() : void {
			//_documentView.removeEventListener(ViewEvent.ADD_IMAGE, onAddImage);
			_documentView.removeEventListener(ViewEvent.ADD_LAYER, onAddLayer);
			_documentView.removeEventListener(ViewEvent.REMOVE_LAYER, onRemoveLayer);
			_documentView.removeEventListener(DocumentEvent.EXPORT, onExportAdvert);
			_documentView.removeEventListener(DocumentEvent.SAVE, onSaveAdvert);
			_documentView.removeEventListener(DocumentEvent.NEW, onNewAdvert);
			_documentView.removeEventListener(DocumentEvent.PREVIEW, onPreviewAdvert);
			_documentView.removeEventListener(DocumentEvent.UPDATE, onUpdateEditorState);
			//
			_documentView.destroy();
			removeChild(_documentView);
			_documentView = null;
		}
		
		private function onUpdateEditorState(event:DocumentEvent):void {
			_documentView.verifyEditorState(_advert);
		}
		
		private function onOpenFailed(event:ImportEvent):void {
			LogApp.log("failed opening document");
			AlertPane.show(event.type);
		}
		
		private function onOpenSuccessful(event:ImportEvent):void {
			LogApp.log("successfully opened document");
			var open:Import = event.target as Import;
			_advert = open.getAdvert();
			ADVERT_COUNT++;
			showDocumentEditor(true);
		}
		
		private function onNewAdvert():void {
			if(!_loadingView && !_openView) {
				if(_advert) {
					AlertPane.show("Close current file?").addEventListener(AlertEvent.OK, onInitNewAdvert);
				} else {
					createNewAdvert();
				}
			}
		}
		
		private function onInitNewAdvert(event:AlertEvent):void {
			(event.target as AlertPane).removeEventListener(AlertEvent.OK, onInitNewAdvert);
			createNewAdvert();
			removeDocumentEditor();
			_advert.destroy();
			_advert = null;
		}
		
		private function createNewAdvert():void {
			LogApp.log("created new document");
			showOpenDialog();
		}
		
		private function onPreviewAdvert(event:DocumentEvent):void {
			LogApp.log("previewing advert");
			_preview = new PreviewWindow();
			_preview.init(_advert);
			var rect:Rectangle = Config.getSizeForAdvertAsRectangle(_advert.getSize());
			_preview.width += rect.width;
			_preview.height += rect.height;
		}
		
		private function onSaveAdvert():void {
			if(_documentView && _advert) {
				LogApp.log("saving advert");
				try {
					_export = new ExportForSaving(_advert);
					_export.addEventListener(ExportEvent.FAILED, onExportFailed);
					_export.addEventListener(ExportEvent.ERROR, onExportError);
					_export.addEventListener(ExportEvent.SAVED, onSaveSuccess);
					(_export as ExportForSaving).save();
				} catch(error:Error) {
					trace(error);
					return;
				}
			}
		}
		
		
		private function onExportAdvert():void {
			LogApp.log("exporting advert");
			try {
				// Confirm if the advert is correctly formed
				var ok:Boolean = _advert.isExportReady();
			} catch(error:AdvertError) {
				trace(error.message);
			}
			if(ok) {
				try {
					_export = new ExportForDelivery(_advert);
					_export.addEventListener(ExportEvent.FAILED, onExportFailed);
					_export.addEventListener(ExportEvent.ERROR, onExportError);
					_export.addEventListener(ExportEvent.SAVED, onExportSuccess);
					(_export as ExportForDelivery).save();
				} catch(error:Error) {
					removeExportListeners();
				}
			}
		}
		
		private function removeSaveListeners():void {
			_export.removeEventListener(ExportEvent.FAILED, onExportFailed);
			_export.removeEventListener(ExportEvent.ERROR, onExportError);
			_export.removeEventListener(ExportEvent.SAVED, onSaveSuccess);
			_export = null;
		}
		
		private function removeExportListeners():void {
			_export.removeEventListener(ExportEvent.FAILED, onExportFailed);
			_export.removeEventListener(ExportEvent.ERROR, onExportError);
			_export.removeEventListener(ExportEvent.SAVED, onExportSuccess);
			_export = null;
		}
		
		private function onExportFailed(event:ExportEvent):void {
			AlertPane.show(event.type);
			removeExportListeners();
			_export = null;
		}
		
		private function onSaveSuccess(event:ExportEvent):void {
			LogApp.log("advert saved successfully");
			AlertPane.show("Advert saved successfully");
			removeSaveListeners();
			_export = null;
		}
		
		private function onExportSuccess(event:ExportEvent):void {
			LogApp.log("advert exported successfully");
			AlertPane.show("Advert exported successfully");
			removeExportListeners();
			_export = null;
		}
		
		private function onExportError(event:ExportEvent):void {
			LogApp.log("error exporting advert");
			AlertPane.show(event.type);
			removeExportListeners();
			_export = null;
		}
		
		private function onAddLayer(event:ViewEvent):void {
			var pane:NewLayerPane = NewLayerPane.show();
			pane.addEventListener(AlertEvent.OK, onAddLayerName);
		}
		
		private function onAddLayerName(event:NewLayerEvent):void {
			var name:String = event.text.split("/r").join("");
			if(_advert.isLayerNameAvailable( name )) {
				_newLayerName = name;
				var rect:Rectangle = Config.getSizeForAdvertAsRectangle(_advert.getSize());
				var size:Number = Config.getFileSizeLimitForAdvertSize(_advert.getSize()) - _advert.getTotalFilesize();
				var pane:AlertPane = AlertPane.show("Select an image " + rect.width + "px by " + rect.height + "px and less than " + size + "kb");
				pane.addEventListener(AlertEvent.OK, onAddLayerImage);
		 	} else {
				// Name already taken, choose again
				NewLayerPane.show().addEventListener(AlertEvent.OK, onAddLayerName);
			}
		}
		
		private function onAddLayerImage(event:AlertEvent):void {
			_imageImport = new ImageImport(
				Config.getSizeForAdvertAsRectangle(_advert.getSize()),
				Config.getFileSizeLimitForAdvertSize(_advert.getSize()) - _advert.getTotalFilesize()
			);
			
			_imageImport.addEventListener(Event.COMPLETE, onImageUploadSuccess);
			_imageImport.addEventListener(Event.CANCEL, onImageIsWrongDimension);
			_imageImport.addEventListener(AdvertEvent.FILESIZE_LIMIT_EXCEEDED, onImageExceedsFilesize);
			_imageImport.x = stage.stageWidth; // shove it off stage so the user can't see it when we check dimensions.
			_imageImport.y = stage.stageHeight;
			addChild(_imageImport);
			try {
				_imageImport.selectFile();
			} catch(error:Error) {
				trace(error);
			}
		}
		
		private function removeUploader():void {
			removeChild(_imageImport);
			_imageImport.flush(); // Could cause issues?! IS FLUSHING BITMAPDATA
		}
		
		private function onImageExceedsFilesize(event:AdvertEvent):void {
			LogApp.log("wrong image filesize");
			removeUploader();
			AlertPane.show("Image exceeds file allowance which is " + (Config.getFileSizeLimitForAdvertSize(_advert.getSize()) - _advert.getTotalFilesize()) + " of " + Config.getFileSizeLimitForAdvertSize(_advert.getSize()));
		}
		
		private function onImageIsWrongDimension(event:Event):void {
			LogApp.log("wrong image dimension");
			removeUploader();
			var dimensions:Rectangle = Config.getSizeForAdvertAsRectangle(_advert.getSize());
			AlertPane.show("Image should be " + dimensions.width + "px by "+ dimensions.height + "px");
		}
		
		private function onImageUploadSuccess(event:Event):void {
			LogApp.log("image imported sucessfully");
			var layer:Layer = _advert.addLayer( new Layer() );
			layer.setName(_newLayerName);
			_documentView.addLayer(layer);
			_documentView.verifyEditorState(_advert);
			_documentView.getVisibleLayer().setLayerImage(
				_imageImport.getImage()
			);
			removeUploader();
			_newLayerName = null;
		}
		
		private function onMoveLayer(event:LayerEvent):void {
			var layer:Layer = (event.target as LayerPaletteBox).getLayer();
			var amount:int = event.type == LayerEvent.MOVE_UP ? 1 : -1;  
			if( _advert.moveLayer(layer, amount) ) {
				_documentView.reorderLayers(_advert.getLayers());
			}
		}
		
		private function onRemoveLayer(event:ViewEvent):void {
			_documentView.removeLayer(event.layer);
			_advert.removeLayer(event.layer);
			_documentView.verifyEditorState(_advert);
		}
	}
}
