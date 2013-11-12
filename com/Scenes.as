package com
{
	import com.greensock.loading.display.ContentDisplay;
	import flash.display.Sprite;
	import com.greensock.*;
	import flash.events.MouseEvent;
	import com.NavItems;
	import com.IntroVideoPayer;
 
	
	/**
	 * ...
	 * @author Gerry Yumul
	 */
	public class Scenes extends Sprite 
	{
		public var _scenesContainter:Sprite;
		public var _scenesContainterBlocker:Sprite = new Sprite;
		private var _centerWidth:Number = 732;
		private var sq:Sprite = new Sprite;
		private var current:Sprite;
		private var _currentSceneName:String;
		private var sectionArrs:Array;
		private var s:Sprite;
		private var mousemove:Boolean;
		public static var _instance:Scenes;
		public static function get instance():Scenes { return _instance; }
		private var _navItemy = 560;
		//private var _navItemy = 100;
		private var currXML:XMLList;
		
		private var playedVideoArrs:Array = new Array;
		
		public function Scenes(scenesContainter:Sprite) 
		{
			_instance = this;
			
			_scenesContainter = scenesContainter;
			_scenesContainterBlocker.name = "cover";
			this.addChild(_scenesContainter);
			init();
		}
		
		private function init():void {
			
		}
		
		public function showScene(scene:XMLList):void {
			
			currXML = scene;
			var navArrs:Array = new Array;
			var navArrs_x:Array = new Array;
			var navArrs_y:Array = new Array;
			
			var itemDetailArrs:Array = new Array;
			
			
			mousemove = false;
			
			_scenesContainter.visible = true;
			var currentScene:String =  currXML.attribute("title");
			current = _scenesContainter.getChildByName(currXML.attribute("title")) as Sprite;
			//////CURRENT SCENE Y LOCATION
			current.y = -10;
			
			current.visible = true;
			Main.instance.Assets.recenterBackground();
			
			
			/////////////////SECTION HOT SPOTS//////////////////////////////
			for (var i:int = 0; i < currXML.sections.item.length(); i++) 
			{
				var sect:String = currXML.sections.item[i].attribute("name");
				var xspot:String = currXML.sections.item[i].attribute("x_hotspot");
				var yspot:String = currXML.sections.item[i].attribute("y_hotspot");
				//var detailArrs:XMLList = currXML.sections.item[i];
				
				navArrs.push(sect)
				navArrs_x.push(xspot)
				navArrs_y.push(yspot)
				
			}
			
			var nav_items:NavItems = new NavItems(navArrs, currentScene);
			nav_items.name = "navItems"
			//_scenesContainter.addChild(nav_items);
			_scenesContainter.addChild(nav_items);
			nav_items.x = _scenesContainter.width / 2 - nav_items.width / 2;
			nav_items.y = _navItemy;/**/
			
			//var hs:HotSpots = new HotSpots(navArrs, navArrs_x, navArrs_y);
			var hs:HotSpots = new HotSpots(currXML);
			hs.y = current.y;
			hs.name = "hotspots"
			hs.visible = false;/**/
			
			
			_scenesContainter.addChild(_scenesContainterBlocker);
			_scenesContainterBlocker.visible = false;
			createSquareBlocker();
			_scenesContainter.addChild(hs);
			
			
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,activateMouse)
			//
			DisplayScene()

		}
		
	
		
		
		
		private function DisplayScene():void
		{
			TweenLite.to(current, 1, {alpha:1, onComplete:showIntroVideo});
		}
		
		
		private function showIntroVideo():void {
			trace("indexOF:::::" + playedVideoArrs.indexOf(String(currXML.attribute("title"))))
			trace("indexOF:::::" + currXML.attribute("title"))
			
			
					///////PLAY VIDEO ONCE WHENEVER WE START A SCENE///////
			/*if(playedVideoArrs.indexOf(String(currXML.attribute("title"))) == -1){
				trace("SHOW INTOR:::    " + currXML.attribute("title"))
				IntroVideoPayer.instance.showIntroVid(currXML.attribute("title"));
				playedVideoArrs.push(String(currXML.attribute("title")));
				
				for (var i:int = 0; i < playedVideoArrs.length; i++) 
				{
					trace("playedVideoArrs array::::: " + playedVideoArrs[i])
				}
			}else {
				showHotSpots();
			}*/
			
				///////PLAY VIDEO WHENEVER WE START A SCENE///////
				IntroVideoPayer.instance.showIntroVid(currXML.attribute("title"));	
		}
		
		public function showHotSpots():void {
			if(_scenesContainter.getChildByName("hotspots"))_scenesContainter.getChildByName("hotspots").visible = true;
			
		}
		
		
		/////////////////////////////////////FUNCTION/////////////////////////////////////
		
		public function reCenter():void {
			
			_scenesContainterBlocker.width = stage.stageWidth;
			//_scenesContainter.x = _scenesContainterBlocker.width / 2 - _scenesContainter.width / 2;
			
		}
		
		public function revealSection(sec:String):void {
			
			//trace("Reveal Section:  " + sec )
			
			if (sec != "default")
			{
			
			for (var i:int = 1; i < current.numChildren; i++) 
			{
				//trace("Current child:  " + current.numChildren)
				if(current.getChildAt(i).name == sec){
				current.getChildAt(i).visible = true;
				current.getChildAt(i).alpha = 1;
				}else {
				//current.getChildAt(i).visible = false;
				current.getChildAt(i).alpha = 0;
					
				}
				//current.x = i * 100;
				
			}
			
			current.getChildAt(0).alpha = .4
			
			TweenMax.to(current.getChildAt(0), .25, { alpha: .4, blurFilter: { blurX:2, blurY:2 }} );
			
			
			
			}else {
				
				
			
			
			
			for (var i:int = 1; i < current.numChildren; i++) 
			{
				//trace("Current child:  " + current.numChildren)
				
				//current.getChildAt(i).visible = false;
				current.getChildAt(i).alpha = 0;
					
				
				//current.x = i * 100;
				
			}
			
			//current.getChildAt(0).alpha = 1
			TweenMax.to(current.getChildAt(0), .25, {alpha: 1, blurFilter:{blurX:0, blurY:0}});
			
			}
			
		}
		
		/////////////////MOUSE-EVENT///////////////////////////
		
		
		private function activateMouse(e:MouseEvent):void {
			
			mousemove = true;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,activateMouse)

		}
		
		private function sectionHover(e:MouseEvent):void {
			
			if(mousemove) revealSection(e.target.name);
			//trace("revealSection::::::::::::" + e.target.name)
		}
		
		private function sectionOut(e:MouseEvent):void {
			if(mousemove) revealSection("default");
		}
		
		

		private function createSquareBlocker():void {
			var a:Sprite = new Sprite();
			
			//a.graphics.lineStyle(3,0x00ff00);
			a.graphics.beginFill(0xFFFFFF);
			a.graphics.drawRect(0,0,this.width,1200);
			a.graphics.endFill();
			//a.y = 200;
			a.name = "blocker"
			a.alpha = .5;
			_scenesContainterBlocker.addChild(a)/**/	
		}

		public function returnToDefault():void {
			TweenLite.to(current, .2, {alpha:0, visible:false, onComplete: setDefault});
		}
		
		private function setDefault():void {
			Main.instance.coverflow.resetToDefault();
			current = null;
			_scenesContainter.visible = false;
			_scenesContainter.removeEventListener(MouseEvent.CLICK, returnToDefault)
			_scenesContainter.removeChild(_scenesContainter.getChildByName("navItems"));
			_scenesContainter.removeChild(_scenesContainter.getChildByName("hotspots"));

		}

		
		////////////////////////FOCUS IS ON//////////////////////////
		public function detailsActive():void {
			TweenMax.to(_scenesContainter.getChildByName("navItems"), .5, { alpha: .8, blurFilter: { blurX:5, blurY:5 }} );
			_scenesContainterBlocker.visible = true;
			
		}
		
		public function sceneDefault():void {
			TweenMax.to(_scenesContainter.getChildByName("navItems"), 0, { alpha:1, blurFilter: { blurX:0, blurY:0, remove:true }} );
			HotSpots.instance.hideLabel();
			HotSpots.instance.addEvents();
			_scenesContainterBlocker.visible = false;
			NavItems.instance.deselectNavSprite()
			NavItems.instance.addEvents()
		}
	}

}