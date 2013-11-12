package com
{
	import com.greensock.TimelineLite;
	import flash.display.Sprite;
	import flash.geom.Matrix;
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

	
	/**
	 * ...
	 * @author Gerry Yumul
	 */
	public class SimilarInterest extends Sprite 
	{
		private var UI:Sprite = new similar_interface;
		

		private var format1:TextFormat = new TextFormat;
		private var format2:TextFormat = new TextFormat;
		private var format3:TextFormat = new TextFormat;
		private var listHolder:Sprite = new Sprite;
		private var showListTrans:TimelineLite = new TimelineLite({onComplete:closeCloseButton});
		
		private var myfont2 = new Font2;
		Font.registerFont(Font2);
		
		private var myfont3 = new Font3;
		private var _simlist:XMLList;
		Font.registerFont(Font3);
		
		public function SimilarInterest() 
		{
			init();
			this.addChild(listHolder)
			showListTrans.stop()
		}
		
		private function init():void {
			
			var header:TextField = createTextField("RELATED FIELDS THAT YOU MIGHT BE INTERESTED IN:", 11)
			header.x = 33
			//header.y = 3
			this.addChild(UI)
			this.addChild(header);
		}
		
		public function getItems(similar:XMLList):void {
			
			_simlist = similar;
			trace("This is the SIMLIST::::::::::" + _simlist)
		}
		
		public function showItems():void {

			var listXMLLIst:XMLList = _simlist.interest;
			trace("This is the XML list::::::" + listXMLLIst)
			listHolder.y = 38;
			for (var i:int = 0; i < _simlist.interest.length(); i++) 
			{
				trace("ITEMS" + _simlist.interest[i]);
				var list:TextField = createTextField(_simlist.interest[i], 11, 211)
				list.x = 8;
				
				//var list:TextField = createTextField("asdadasdadadad", 0)
				var bg:Sprite = createSquareBg(227, list.height)
				bg.x = 34;
				bg.alpha = 0;
				bg.addChild(list);
				bg.y = listHolder.height + 2;
				listHolder.addChild(bg);
				showListTrans.append(TweenLite.to(bg, 0.1, { alpha:.5} ));
			}
			
			showListTrans.prepend(TweenLite.to(UI, 0.1, { height: UI.height + listHolder.height + 2} ));
			showList();
		}
		
		public function showList():void {
			showListTrans.play()
		}
		
		private function closeCloseButton():void {
			

			MediaDetails.instance.showCloseButton();
		}
		
		//////////////////////FUNCTION TO CREATE DISPLAY OBJECTS////////////////////
		private function createTextField(t:String, s:int, w:int = 180):TextField
		{
			//trace("This is trace create text" + t)
			
			format1.size = s;
			format1.letterSpacing = .5;
			format1.font = myfont2.fontName;
			format1.align = TextFormatAlign.LEFT;
			format1.color = 0x000000;
			
			format2.size = s;
			format2.letterSpacing = .5;
			format2.font = myfont2.fontName;
			format2.align = TextFormatAlign.LEFT;
			format2.color = 0x333333;
			
			format3.size = s;
			format3.letterSpacing = .5;
			format3.font = myfont3.fontName;
			format3.align = TextFormatAlign.LEFT;
			format3.color = 0x333333;
			
			
			
			var tf:TextField = new TextField;
			tf.text = t;
			if(s == 11) tf.setTextFormat(format2) else tf.setTextFormat(format1) ;
			//tf.border = true;			
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.autoSize = TextFieldAutoSize.LEFT;	
			tf.embedFonts = true;
			tf.wordWrap = true;
			tf.multiline = true;
			if (w != 0) tf.width = w;

			tf.condenseWhite = true;
			
		
			
			
			
			
			return tf;
		}
		
		private function createSquareBg(w:int, h:int):Sprite
		{
			var square:Sprite = new Sprite;
			
			
			square.graphics.beginFill(0xFFFFFF);
			square.graphics.drawRoundRect(0,0,w,h,10);
			square.graphics.endFill();/**/
			
			return square;
		}
		
	}

}