﻿package com{	import com.greensock.TimelineLite;	import flash.display.Sprite;	import flash.events.MouseEvent;	import com.apps.AppUI;	import com.greensock.*;	import com.greensock.easing.*;	import com.apps.whysb.WhySB;	import com.apps.map.MapDetails;	import com.apps.program.ProgramGrid;			/**	 * ...	 * @author Gerry Yumul	 */	public class Application extends Sprite 	{		private var appui:AppUI;		private var appsImg:Array;		public var appsXML:XMLList;		private var appbox_holder:Sprite = new Sprite;			//	private var map:MapDetails = new MapDetails		public static var _instance:Application;		private var appToggle:Boolean;		public static function get instance():Application { return _instance; }				public function Application():void		{			init();		}				private function init():void {			/*createappui();			createfindloc();			createfindprog();*/			this.addChild(appbox_holder);		}				public function loadArrs(arrs:Array, xml:XMLList):void {			appsImg = arrs;									for (var i:int = 0; i < appsImg.length; i++) 			{				var appCont:sqBottomApps = new sqBottomApps;				appbox_holder.addChild(appCont)								appsImg[i].visible = true;				appsImg[i].alpha = 1;				appCont.img.addChild(appsImg[i]);				appCont.x = i * 258;				//appCont.visible = true;				//appCont.alpha = 1;				appCont.addEventListener(MouseEvent.CLICK, appClick)				appCont.addEventListener(MouseEvent.MOUSE_OVER, appOver)				appCont.addEventListener(MouseEvent.MOUSE_OUT, appOut)				appCont.buttonMode = true;			}											appsXML = xml;		}						/////////////////////////MOUSE EVENTS///////////////////////////////				private function appClick(e:MouseEvent):void {			createSquareBlocker();			appLaunch(e.target.name);			appbox_holder.removeChild(appbox_holder.getChildAt(e.currentTarget.parent.getChildIndex(e.currentTarget as Sprite)))			Main.instance.cfHolder.alpha = .2;			reCenterBottom()					}				private function appOver(e:MouseEvent):void {		trace("Launch Over")		}				private function appOut(e:MouseEvent):void {		trace("Launch Out")		}										/////////////////////////FUNCTIONS///////////////////////////////				private function appLaunch(app_id:String):void {						var n:XMLList = appsXML.app.(id == app_id);						appui = new AppUI(n.name, n.sub)			appui.x = stage.stageWidth / 2 - (appui.width / 2 );			appui.y = (stage.stageHeight / 2 - appui.height / 2);			appui.name = "bottomApps"						//CLOSE BUTTON INSTANCE			//appui.ui.close_button.alpha = .5;			appui.ui.close_btn.addEventListener(MouseEvent.CLICK, closeWinUI);			Main.instance.addChild(appui);						switch(app_id) {				case "1":				var whysb:WhySB = new WhySB;				whysb.x = 38;				whysb.y = 90;				appui.addChild(whysb);				break;								case "2":				var map = new MapDetails(n)				map.x = appui.width / 2 - map.width / 2;				map.y = (appui.height / 2 - map.height / 2) ;				appui.addChild(map);				map.showSpots();				break;								case "3":				var program:ProgramGrid = new ProgramGrid;				program.x = 40;				program.y = 130;				appui.addChild(program);												break;							}						trace("Number of app ui kids:: " + appui.numChildren)						//	trace("APPLICATION APP LAUCH" + appsXML)								}				private function reCenterBottom():void {						var tl:TimelineLite = new TimelineLite({onComplete:centerBottomArea, onCompleteParams:[.3]})						for (var i:int = 0; i < appbox_holder.numChildren; i++) 			{				tl.append(TweenLite.to(appbox_holder.getChildAt(i), .12, { x:i * 258} ));							}							tl.play();		}				private function centerBottomArea(a:Number):void {				TweenLite.to(this, .12, { x:stage.stageWidth / 2 - appbox_holder.width / 2 , alpha: a} )					}				private function closeWinUI(e:MouseEvent):void {							var i:int = appbox_holder.numChildren;					while( i -- )					{												appbox_holder.removeChildAt( i );					} 			reCreateAppAccess()			Main.instance.removeChild(Main.instance.getChildByName("cover"))			Main.instance.cfHolder.alpha = 1;			//appui.removeChildAt(0);			Main.instance.removeChild(appui);		}				public function reCreateAppAccess():void {									for (var i:int = 0; i < appsImg.length; i++) 			{				var appCont:sqBottomApps = new sqBottomApps;								appbox_holder.addChild(appCont)				appCont.img.addChild(appsImg[i]);				appCont.x = i * 258;				//appCont.alpha = .5;				appCont.addEventListener(MouseEvent.CLICK, appClick)				appCont.addEventListener(MouseEvent.MOUSE_OVER, appOver)				appCont.addEventListener(MouseEvent.MOUSE_OUT, appOut)				appCont.buttonMode = true;			}						centerBottomArea(1);		}						public function createSquareBlocker():void {			var a:Sprite = new Sprite();						//a.graphics.lineStyle(3,0x00ff00);			a.graphics.beginFill(0xFFFFFF);			a.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);			a.graphics.endFill();			//a.y = 200;			a.name = "cover"			a.alpha = .5;			Main.instance.addChild(a)/**/					}				public function lowerAppsGroup():void {						if (!appToggle) {				TweenLite.to(appbox_holder, .25, {y:160})					appToggle = true;			}else {				TweenLite.to(appbox_holder, .25, {y:0})					appToggle = false;			}												trace("app box height" + appbox_holder.y)		}				}}