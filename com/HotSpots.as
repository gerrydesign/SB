package com
{
	import com.greensock.loading.display.ContentDisplay;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.*
	import flash.events.MouseEvent;
	import com.NavItems;
	import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.FontType;
	import com.greensock.*;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.TypewriterPlugin;
	import com.greensock.plugins.DecoderTextPlugin;
	import com.greensock.*;
	import com.greensock.easing.*;
 
	TweenPlugin.activate([TypewriterPlugin]);
	TweenPlugin.activate([DecoderTextPlugin]); 
	
	/**
	 * ...
	 * @author Gerry Yumul
	 */
	public class HotSpots extends Sprite 
	{
		private var format1:TextFormat = new TextFormat;
		private var myfont2 = new Font2;
		Font.registerFont(Font2);/**/
		
		private var textSection:TextField = new TextField;
		private var currXML:XMLList;
		private var _sectArrs:Array = new Array;
		private var _xArrs:Array = new Array;
		private var _yArrs:Array = new Array;
		private var _detailArrs:Array = new Array;
		private var tbArrs:Array = new Array;
		private var _current:String;
		private var currentSprite:Sprite;
		private var spotsContainer:Sprite = new Sprite;
		public static var _instance:HotSpots;
		private var currX;
		private var currY;
		private var line:Shape;
		private var drawer:Sprite;
		private var detailMedia:MediaDetails;
		//private var newTypewriter:Typewriter = new Typewriter;
		public static function get instance():HotSpots { return _instance; }
		
		//public function HotSpots(sectArrs:Array,xArrs:Array,yArrs:Array) 
		public function HotSpots(xml:XMLList) 
		{
			currXML = xml;
			_instance = this;
			
			
			for (var i:int = 0; i < currXML.sections.item.length(); i++) 
			{
				var sect:String = currXML.sections.item[i].attribute("name");
				var xspot:String = currXML.sections.item[i].attribute("x_hotspot");
				var yspot:String = currXML.sections.item[i].attribute("y_hotspot");
				//var detailArrs:XMLList = currXML.sections.item[i];
				
				_sectArrs.push(sect)
				_xArrs.push(xspot)
				_yArrs.push(yspot)
				
				
			}
			
			
			
			
			
			spotsContainer.name = "spotscontainer"
			this.addChild(spotsContainer);
			
			
			
			
			
			init();
		}
		
		private function init():void {
			
			format1.align = TextFormatAlign.CENTER;
			format1.size = 12;
			format1.letterSpacing = .5;
			format1.font = myfont2.fontName;
			format1.color = 0x5E5E5E;
			//trace("Font name: " + myfont1.fontName)
			textSection.defaultTextFormat = format1
			
			
			//textSection.setTextFormat(format1);
			
			
			//textSection.border = true;
			textSection.embedFonts = true;
			textSection.antiAliasType = AntiAliasType.ADVANCED;
			textSection.condenseWhite = true;
			//tf.wordWrap = true;
			//tf.multiline = true;
			textSection.selectable = false;
			textSection.autoSize = TextFieldAutoSize.LEFT;	

			
			//this.addChild(textSection);
			
			for (var i:int = 0; i < _sectArrs.length; i++) 
			{
				var hotspotHolder:Sprite = new Sprite;
				hotspotHolder.name = _sectArrs[i]
				spotsContainer.addChild(hotspotHolder);
				var hs:MovieClip = new hotspot;
				hs.buttonMode = true;
				hs.name = _sectArrs[i]
				
				/*hs.txt_bg.alpha = 0;
				hs.txt_bg.visble = false;
				
				var tf:TextField = hs.txt_bg.txt
				tf.text = _sectArrs[i].toUpperCase();
				tf.autoSize = TextFieldAutoSize.LEFT;
				
				var tw:int = tf.width;
				
				hs.txt_bg.bg.width = tw + 40;
				hs.active.width = tw + 40;*/
				
				
				hs.x = _xArrs[i]
				hs.y = _yArrs[i]
				
				dropShadow(hs)
				//tbArrs.push(tf); 
				
				
				
				hotspotHolder.addChild(hs);
				
				
				
				
				
				hotspotHolder.addEventListener(MouseEvent.CLICK, hs_CLICK);
				hotspotHolder.addEventListener(MouseEvent.MOUSE_OVER, hs_MOUSE_OVER);
				hotspotHolder.addEventListener(MouseEvent.MOUSE_OUT, MOUSE_OUT);
				
				
				
				
				trace("sect Array:::::::: " + _sectArrs[i] )
				trace("sect X Array:::::::: " + _xArrs[i] )
				trace("sect Y Array:::::::: " + _yArrs[i] )
			}
			

		}
		
		//////////////FUNCTIONS/////////////////////
		
		public function activateNavItems(s:String):void {
			trace("THIS IS " + s);
				trace("ACTIVATE NAV ITEMS");
			var sName:String = s;
			Scenes.instance.revealSection(sName)
			NavItems.instance.selectNavSprite(sName)
			_current = sName;
			//activateItem(_current)
			detailMedia.showDetails()
			
			
		}
		
		public function addEvents():void {
			
				for (var i:int = 0; i < _sectArrs.length; i++) 
				{
					var sp:Sprite = spotsContainer.getChildAt(i) as Sprite;
					sp.addEventListener(MouseEvent.CLICK, hs_CLICK);
					sp.addEventListener(MouseEvent.MOUSE_OVER, hs_MOUSE_OVER);
					sp.addEventListener(MouseEvent.MOUSE_OUT, MOUSE_OUT);	
					Sprite(sp.getChildAt(0)).buttonMode = true;
				}
			
		}
		
		public function removeEvents():void {
			
			
			
			trace("REMOVE EVENTS");
			for (var i:int = 0; i < _sectArrs.length; i++) 
				{
					var sp:Sprite = spotsContainer.getChildAt(i) as Sprite;
					trace("GET number of children name" + spotsContainer.getChildAt(i).name)
					sp.removeEventListener(MouseEvent.CLICK, hs_CLICK);
					sp.removeEventListener(MouseEvent.MOUSE_OVER, hs_MOUSE_OVER);
					sp.removeEventListener(MouseEvent.MOUSE_OUT, MOUSE_OUT);
					Sprite(sp.getChildAt(0)).buttonMode = false;

				}
				
			NavItems.instance.removeEvents();
		}
		
		public function activateItem(n:String):void {
			for (var i:int = 0; i < _sectArrs.length; i++) 
			{
				spotsContainer.getChildAt(i).alpha = .3
			}
			
			var currSpot:Sprite = spotsContainer.getChildByName(n) as Sprite;

			currSpot.alpha = 1

			var details:XMLList = currXML.sections.item.(@name == n);
			
			trace("THESE IS MEDIA DETAILS XML LIST:::::::::::   :: BEGIN ")
			trace("THESE IS MEDIA DETAILS XML LIST:::::::::::   :: " + details)
			trace("THESE IS MEDIA DETAILS XML LIST:::::::::::   :: END ")

			detailMedia = new MediaDetails(details);
			detailMedia.visible = false;
			detailMedia.alpha = 0;
			currX = currSpot.getChildByName(n).x;
			currY = currSpot.getChildByName(n).y;

			line = new Shape();
			line.graphics.lineStyle(1, 0xFFFFFF);
			line.graphics.moveTo(int(currX + 9), int(currY + 9));
			this.addChild(line);
			this.setChildIndex(line,0)

			drawer = new Sprite; 
			drawer.x = currX + 9; 
			drawer.y = currY + 9;
			this.addChild(drawer);
			
			var orient:String;
			
			if (this.parent.width / 2 > currX) {
				detailMedia.x = currX + 100;
				detailMedia.y = currY - 50;
				TweenLite.to(drawer, .1, { x: detailMedia.x + 10, y: detailMedia.y + 14, ease:Linear.easeNone , onUpdate:drawLine, onComplete:showDetailUI});
				detailMedia._orient = "left"
				trace("trace spot x" + currX)
			} else {
				trace("trace spot x" + currX)
				detailMedia.x = currX - (100 + detailMedia.width/2);
				detailMedia.y = currY - 50;
				TweenLite.to(drawer, .1, { x: detailMedia.x + detailMedia.sp.width - 20 ,  y: detailMedia.y + 14, ease:Linear.easeNone , onUpdate:drawLine, onComplete:showDetailUI } );
				detailMedia._orient  = "right"
			}
			
			this.addChild(detailMedia);		
		}
		
		private function drawLine():void {
		   line.graphics.lineTo(int(drawer.x), int(drawer.y));
		}
		
		private function showDetailUI():void {
			detailMedia.visible = true;
			TweenLite.to(detailMedia, .2, {alpha:1});	
		}
		
		
		
		private function typerEffect(s:String):void {
			textSection.text = "";
			this.addChild(textSection);
			textSection.text = s;
			var whiteBG:Sprite = createSquare(Math.round(textSection.width) + 30, 20)
			whiteBG.x = textSection.x - 21;
			whiteBG.y = textSection.y - 1;
			whiteBG.name = "bg";
			this.addChild(whiteBG);
			this.setChildIndex(whiteBG, 0)
			var copy:String = s;
			/*var newTypewriter:Typewriter = new Typewriter;
			newTypewriter.writeIt(copy, textSection, 15);*/
			
			 TweenLite.to(textSection, 0.5, { typewriter:s } );
			 //TweenLite.to(textSection, 0.5, {decoder:s});

		}/**/
		
		public function showLabel(n:String):void {
			//var t:Sprite = spotsContainer.getChildByName(n) as Sprite
			Scenes.instance.revealSection(n)
			//textSection.x = t.getChildAt(0).x + 20;
			//textSection.y = t.getChildAt(0).y;
			
			activateItem(n);
			
			//typerEffect(n.toUpperCase());
			//NavItems.instance.selectNavSprite(n);
			
		}
		
		public function hideLabel():void {
			//textSection.text = "";
			Scenes.instance.revealSection("default")
			//this.removeChild(this.getChildByName("bg"))
			//this.removeChild(textSection);
			//NavItems.instance.currentDeSelectItem();
			//TweenLite.to(this,.1,{delay:.1, onComplete:removeMouseOver})	
			this.removeChild(detailMedia);
			this.removeChild(line);
			this.removeChild(drawer);
			
			for (var i:int = 0; i < _sectArrs.length; i++) 
			{
				spotsContainer.getChildAt(i).alpha = 1;
			}

		}
		

		
		///////////////////MOUSE-EVENTS/////////////////
		private function hs_CLICK(e:MouseEvent):void {
			
			var sectName:String = e.target.name;

			if (_current != sectName) {	
				NavItems.instance.currentDeSelectItem();
				//activateNavItems(sectName)
				
				trace("Active Scene is :" + sectName)
			} else {
				trace("SELECTING" + _current)
				//activateNavItems(sectName)
				
			}
			
			removeEvents();	
			activateNavItems(sectName)
			/**/
		}
		
		private function hs_MOUSE_OVER(e:MouseEvent):void {
			var n:String = e.target.parent.name;
			showLabel(n);
			
			trace(e.target.parent.parent.name);
		}
		
		private function MOUSE_OUT(e:MouseEvent):void {
			hideLabel()					
		}
		
		private function removeMouseOver():void {	
			this.removeChild(this.getChildByName("bg"))
			this.removeChild(textSection);
			trace("removeMouseOver()")
		}
		
		private function createSquare(w:int, h:int):Sprite
		{
			var square:Sprite = new Sprite();
			
			square.graphics.beginFill(0xFFFFFF);
			square.graphics.drawRoundRect(0,0,w,h,20);
			square.graphics.endFill();

			
			return square;
		}
		
		private function dropShadow(mc:Sprite):void {
			TweenMax.to(mc, 1, {dropShadowFilter:{color:0x000000, alpha:0.7, blurX:6, blurY:6, distance:0}});
		}
		
		
	}

}