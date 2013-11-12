package com.apps.map 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.greensock.events.LoaderEvent;
	import flash.text.TextField;
	import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.display.*
	
	/**
	 * ...
	 * @author Gerry Yumul
	 */
	public class MapDetails extends Sprite 
	{
		private var map:_usmap = new _usmap;
		private var nw:MovieClip;
		private var sw:MovieClip;
		private var mw:MovieClip;
		private var ne:MovieClip;
		private var se:MovieClip;
		private var mapArrs:Array = new Array;
		private var mapArrsLabel:Array = new Array;
		private var mapArrsLabelLoc:Array = new Array;
		private var mapArrsLabelHolder:Array = new Array;
		private var mapArrsLoc:Array = new Array;
		private var mapArrsLocLine:Array = new Array;
		private var tl:TimelineLite;
		private var format1:TextFormat = new TextFormat;
		private var format2:TextFormat = new TextFormat;
		private var lineArrs:Array = new Array;
		private var drawArrs:Array = new Array;
		private var currentRegion:String;
		private var myfont2 = new Font2;
		public var _currXML:XMLList;
		public static var _instance:MapDetails;
		public static function get instance():MapDetails{ return _instance; }
		Font.registerFont(Font2);
		
		public function MapDetails(currXML:XMLList) 
		{
			_currXML = currXML;
			_instance = this;
			init()
		}
		
		private function init():void {

		/*nw = map.nwest;
		sw = map.nwest;
		mw = map.nwest;
		ne = map.nwest;
		se = map.nwest;*/
		
		mapArrsLabel.push("SB - NORTHWEST");
		mapArrsLabel.push("SB - SOUTHWEST");
		mapArrsLabel.push("SB - MIDWEST");
		mapArrsLabel.push("SB - NORTHEAST");
		mapArrsLabel.push("SB - SOUTHEAST");
		
		mapArrs.push(map.nwest);
		mapArrs.push(map.swest);
		mapArrs.push(map.mwest);
		mapArrs.push(map.neast);
		mapArrs.push(map.seast);
		
		mapArrsLoc.push({x:-70, y:-40, alpha: 1});
		mapArrsLoc.push({x:-90, y:100, alpha: 1});
		mapArrsLoc.push({x:40, y:-80, alpha: 1});
		mapArrsLoc.push({x:100, y:-20, alpha: 1});
		mapArrsLoc.push( { x:100, y:100, alpha: 1 } );

		mapArrsLocLine.push({x:-20, y:-20, alpha: 1, ease:Linear.easeNone , onUpdate:drawLine, onUpdateParams:[0]});
		mapArrsLocLine.push({x:0, y:100, alpha: 1, ease:Linear.easeNone , onUpdate:drawLine, onUpdateParams:[1]});
		mapArrsLocLine.push({x:60, y:-60, alpha: 1, ease:Linear.easeNone , onUpdate:drawLine, onUpdateParams:[2]});
		mapArrsLocLine.push({x:105, y:-10, alpha: 1, ease:Linear.easeNone , onUpdate:drawLine, onUpdateParams:[3]});
		mapArrsLocLine.push({x:105, y:105, alpha: 1, ease:Linear.easeNone , onUpdate:drawLine, onUpdateParams:[4]});
		
		this.addChild(map);
		
		tl = new TimelineLite({onComplete: addEvents});
		
		for (var i:int = 0; i < mapArrs.length; i++) 
			{
				mapArrs[i].alpha = 0;
				mapArrs[i].buttonMode = true;
				
				var spot:Sprite = createGreenSpots(6);
				spot.alpha = 0;
				spot.x = mapArrs[i].width / 2 - spot.width / 2;
				spot.y = mapArrs[i].height / 2 - spot.height / 2;
				TweenMax.to(spot, 0, {dropShadowFilter:{color:0x000000, alpha:.7, blurX:10, blurY:10, distance:3}} )
				mapArrs[i].addChild(spot);
				tl.append(TweenLite.to(mapArrs[i],.1,{alpha: 1}))
				tl.append(TweenLite.to(spot, .1, { alpha: 1 } ))
				
				var sp:Sprite = new Sprite;
				sp.alpha = 0;
				mapArrsLabelLoc.push(sp);
				
				
				
				var tf:TextField = createTextField(mapArrsLabel[i], 12);
				tf.x = 6;
				tf.y = 1;
				var sq:Sprite = createSquare(tf.width + 20, tf.height + 14);
				sq.alpha = .5;
				
				var line:Shape = new Shape;
				lineArrs.push(line);
				mapArrs[i].addChild(line);
				line.graphics.lineStyle(1, 0x666666, 1)
				line.graphics.moveTo(spot.x, spot.y)
				//line.graphics.lineTo(sq.x, sq.y)
				
				
				sp.addChild(sq);
				sp.addChild(tf);
				mapArrs[i].addChild(sp);
				/*line = new Shape();
				line.graphics.lineStyle(1, 0xFFFFFF);
				line.graphics.moveTo(int(currX + 9), int(currY + 9));
				mapArrs[i].addChild(line);
				this.setChildIndex(line,0)*/

				var drawer:Sprite = new Sprite; 
				drawArrs.push(drawer);
				drawer.x = spot.x;
				drawer.y = spot.y; 
				mapArrs[i].addChild(drawer);
			}
			
			for (var i:int = 0; i < mapArrs.length; i++) 
			{
				tl.append(TweenLite.to(mapArrsLabelLoc[i], .1, mapArrsLoc[i] ))
				tl.append(TweenLite.to(drawArrs[i], .1, mapArrsLocLine[i]));
			}
			
			tl.stop();
			
		}
		
		private function drawLine(id:int):void {
		   lineArrs[id].graphics.lineTo(int(drawArrs[id].x), int(drawArrs[id].y));
		}
		
		private function mapClick(e:MouseEvent):void {
			
			switch(e.currentTarget.name){
			
				case "nwest":
				currentRegion = "Northwest";
				break;
				
				case "swest":
				currentRegion = "Southwest";
				break;
				
				case "neast":
				currentRegion = "Northeast";
				break;
				
				case "seast":
				currentRegion = "Southeast";
				break;
				
				case "mwest":
				currentRegion = "Midwest";
				break;
			}
			removeEvents();	
		}
		
		private function mapOver(e:MouseEvent):void {
		
			for (var i:int = 0; i < mapArrs.length; i++) 
			{
				mapArrs[i].alpha = .2
			}
			
			e.currentTarget.alpha = 1;
			
			
		}
		
		private function mapOut(e:MouseEvent):void {
			
			for (var i:int = 0; i < mapArrs.length; i++) 
			{
				mapArrs[i].alpha = 1;
			}
			
		}
		
		public function showSpots():void {
			tl.play()	
		}
		/**/
		private function createGreenSpots(radius:int):Sprite {
			var spot:Sprite = new Sprite;
			
			spot.graphics.beginFill(0xd2e27a);
			spot.graphics.lineStyle(1,0xFFFFFF)
			spot.graphics.drawCircle(0, 0, radius)
			spot.graphics.endFill();
			return spot;
		}
		
		private function createSquare(w:int, h:int):Sprite
		{
			var square:Sprite = new detail_ui;
				//square.x = -8
				//square.y = -8
			square.width = w;
			square.height = h;
			return square;
		}
			
		private function createTextField(t:String, s:int):TextField
		{
			//trace("This is trace create text" + t)
			
			format1.size = s;
			format1.letterSpacing = .5;
			format1.font = myfont2.fontName;
			format1.align = TextFormatAlign.CENTER;
			format1.color = 0x666666;
			
			format2.size = s;
			format2.letterSpacing = .5;
			format2.font = myfont2.fontName;
			format2.align = TextFormatAlign.CENTER;
			format2.color = 0x666666;
			
			
			
			var tf:TextField = new TextField;
			tf.text = t;
			if(s == 11) tf.setTextFormat(format2) else tf.setTextFormat(format1) ;
			//tf.border = true;
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.condenseWhite = true;
			//tf.wordWrap = true;
			//tf.multiline = true;
			tf.autoSize = TextFieldAutoSize.LEFT;	
			
			return tf;
		}
		
		//////////////////ADD MAP LISTENER//////////////////////
		private function addEvents():void {
				trace("EVENTS ADDED")	
			for (var i:int = 0; i < mapArrs.length ; i++) 
			{
				mapArrs[i].addEventListener(MouseEvent.CLICK, mapClick)
				mapArrs[i].addEventListener(MouseEvent.MOUSE_OVER, mapOver)
				mapArrs[i].addEventListener(MouseEvent.MOUSE_OUT, mapOut)
				
				trace("EVENT LOOPS")
			}
		}
		
		
		//////////////////REMOVE LISTENER///////////////////////
		private function removeEvents():void {
	
			for (var i:int = 0; i < mapArrs[i] ; i++) 
			{
				mapArrs[i].removeEventListener(MouseEvent.CLICK, mapClick)
				mapArrs[i].removeEventListener(MouseEvent.MOUSE_OVER, mapOver)
				mapArrs[i].removeEventListener(MouseEvent.MOUSE_OUT, mapOut)
			}
			
			fadeMap();
		}
		
		private function fadeMap():void {
			
			TweenLite.to(map, .1, { alpha: .5, visible:false, x: -100, onComplete:showGridItems } )
		}
		
		//SHOW MAP AGAIN
		public function removeLocationGrid():void {
			map.visible = true
			TweenLite.to(map, .1, { alpha: 1, x:0 } )
			this.removeChild(this.getChildByName("locGrid"))
		}
		
		private function showGridItems():void {
			var locGrid:LocationGrid = new LocationGrid(currentRegion);
			locGrid.name = "locGrid";
			locGrid.x = 0;
			locGrid.y = -7;
			locGrid.alpha = 0;
			this.addChild(locGrid);
			TweenLite.to(locGrid, .2, {x:-107, alpha: 1});
		}
	}
	

}