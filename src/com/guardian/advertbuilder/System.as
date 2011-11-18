package com.guardian.advertbuilder {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.display.NativeMenuItem;
	import flash.display.NativeMenu;
	import flash.display.Bitmap;
	import flash.desktop.NativeApplication;
	/**
	 * @author plcampbell
	 */
	public class System extends EventDispatcher {
		
		private static var SYSTEM:System;
		private var proxyListener:Function;
		
		/*
		[Embed(source="../assets/icon_016.png")];
		public static const ICON_16:Class;
		
		[Embed(source="../assets/icon_032.png")];
		public static const ICON_32:Class;
		
		[Embed(source="../assets/icon_048.png")];
		public static const ICON_48:Class;
		
		[Embed(source="../assets/icon_128.png")];
		public static const ICON_128:Class;
		
		[Embed(source="../assets/icon_256.png")];
		public static const ICON_256:Class;
		
		[Embed(source="../assets/icon_512.png")];
		public static const ICON_512:Class;
		 */
		 
		public static function init():void {
			SYSTEM = new System();
		}
		
		public static function buildDock():void {
			if(NativeApplication.supportsDockIcon) {
				//NativeApplication.nativeApplication.icon.bitmaps = [ICON_16 as Bitmap, ICON_32 as Bitmap, ICON_48 as Bitmap];	
			}
		}
		
		public static function buildSystemMenu(eventListener:Function):void {
			SYSTEM.proxyListener = eventListener;
			NativeApplication.nativeApplication.menu.addSubmenu(SYSTEM.buildFileMenu(), "File");
			NativeApplication.nativeApplication.menu.addSubmenu(SYSTEM.buildEditMenu(), "Edit");
			NativeApplication.nativeApplication.menu.addSubmenu(SYSTEM.buildHelpMenu(), "Help");
		}
		
		private function buildRootMenu():NativeMenu {
			var menu:NativeMenu = new NativeMenu();
			menu.addItem(new NativeMenuItem("About Advert Builder"));
			//
			addCommandEventListener(menu);
			//
			return(menu);
		}
		
		private function buildFileMenu():NativeMenu {
			var menu:NativeMenu = new NativeMenu();
			var item:NativeMenuItem;
			item = menu.addItem(new NativeMenuItem("New"));
   			item.keyEquivalent = "n";
			item.keyEquivalentModifiers = [Keyboard.COMMAND];
			menu.addItem(new NativeMenuItem("Open File"));
			menu.addItem(new NativeMenuItem("", true));
			item = menu.addItem(new NativeMenuItem("Close"));
			item.keyEquivalent = "C";
			item.keyEquivalentModifiers = [Keyboard.COMMAND];
			menu.addItem(new NativeMenuItem("", true));
			item = menu.addItem(new NativeMenuItem("Save"));
			item.keyEquivalent = "s";
			item.keyEquivalentModifiers = [Keyboard.COMMAND];
			menu.addItem(new NativeMenuItem("", true));
			menu.addItem(new NativeMenuItem("Import"));
			item = menu.addItem(new NativeMenuItem("Export"));
			item.keyEquivalent = "E";
			item.keyEquivalentModifiers = [Keyboard.COMMAND];
			//
			addCommandEventListener(menu);
			//
			return(menu);
		}
		
		private function addCommandEventListener(menu:NativeMenu):void{
			var item:NativeMenuItem;
			for(var i:int = 0; i<menu.items.length; i++) {
				menu.items[i].addEventListener(Event.SELECT, SYSTEM.proxyListener);
			}
		}
		
		private function buildHelpMenu():NativeMenu {
			var menu:NativeMenu = new NativeMenu();
			menu.addItem(new NativeMenuItem("Support"));
			menu.addItem(new NativeMenuItem("Tips and tricks"));
			//
			addCommandEventListener(menu);
			//
			return(menu);
		}
		
		private function buildEditMenu():NativeMenu {
			var menu:NativeMenu = new NativeMenu();
			//
			addCommandEventListener(menu);
			//
			return(menu);
		}
		
	}
	
	
}
