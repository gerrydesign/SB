package com
{
	
	import com.greensock.loading.data.VideoLoaderVars;
	import flash.display.Sprite;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.VideoLoader;
	import flash.events.MouseEvent;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontStyle;
	import com.coverflow.Coverflow;
	
	/**
	 * ...
	 * @author Gerry Yumul
	 */
	public class IntroVideoPayer extends Sprite 
	{
		private var _vidLoc:String;
		private var vidLoaderArrs:Array = new Array;
		private var _vids:Sprite;
		private var currentSprite:Object;
		private var playedVidTitle:Array = new Array()
		private var hidebutton:Sprite = new Sprite;
		public static var _instance:IntroVideoPayer;
		public var a:Sprite = new Sprite();
		
		private var myfont1 = new Font1;
		private var myfont2 = new Font2;
		private var format1:TextFormat = new TextFormat;
		private var format2:TextFormat = new TextFormat;
		private var currentVid:VideoLoader;
		Font.registerFont(Font1);
		Font.registerFont(Font2);
		
		
		public static function get instance():IntroVideoPayer { return _instance; }
		
		
		public function IntroVideoPayer() 
		{
			_instance = this;
			init();
		}
		
		private function init():void {
			//a.graphics.lineStyle(3,0x00ff00);

		}
		
		public function loadVideo(vid:Sprite):void {
			this.parent.addChild(a)
			a.graphics.beginFill(0xFFFFFF);
			a.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			a.graphics.endFill();
			//a.y = 200;
			a.name = "cover"
			//a.alpha = .5;
			/**/
			a.visible = true;
			
			//BLOCKER ALPHA;
			a.alpha = .2;
			
			_vids = vid;
			this.addChild(_vids);
		}
		
		//Hide Button
		private function createHideVideo(v:VideoLoader):void {
			_vids.addChild(hidebutton)
			
			var closeLbl:TextField = createTextLabel("SKIP ME", 11, "0x873348");
			
			var bg:Sprite = new Sprite;
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRoundRect(0,0,closeLbl.width,closeLbl.height,5);
			bg.graphics.endFill();
			
			var btn:Sprite = new Sprite;
			btn.graphics.beginFill(0xFFFFFF);
			btn.graphics.drawRoundRect(0,0,closeLbl.width,closeLbl.height,5);
			btn.graphics.endFill();
			btn.alpha = 0;
			
			currentVid = v;
			
			//hidebutton.alpha = 0;
			hidebutton.addChild(bg);
			hidebutton.addChild(closeLbl);
			hidebutton.addChild(btn);
			hidebutton.buttonMode = true;
			
			hidebutton.addEventListener(MouseEvent.CLICK, skipMovieIntro)	
		}
		
		public function showIntroVid(title:String):void {		
		
			
			
			this.parent.addChild(a);

			if (!_vids.visible) _vids.visible = true; _vids.alpha = 1
				for (var i:int = 0; i < _vids.numChildren; i++) 
				{
					if(_vids.getChildAt(i).name == title){
						currentSprite = _vids.getChildAt(i)
						currentSprite.visible = true;
						
						var cd:VideoLoader = LoaderMax.getLoader(_vids.getChildAt(i).name);
							cd.playVideo();
							
							if (_vids.getChildAt(i).name == "introVideo") {
								
								trace("I AM AN INTRO VIDEO")
								///////////////////////SHOW UI ELEMENTS////////////////////////
								cd.addASCuePoint(33, "showCoverFlow"); 
								cd.addASCuePoint(34, "scene0"); 
								cd.addASCuePoint(35, "scene1"); 
								cd.addASCuePoint(36, "scene2"); 
								cd.addASCuePoint(37, "scene3"); 
								cd.addASCuePoint(38, "scene4"); 
								cd.addASCuePoint(39, "scene5"); 
								cd.addASCuePoint(40, "showNavs"); 
								cd.addASCuePoint(84, "bottomApps"); 								
								cd.addEventListener(VideoLoader.VIDEO_CUE_POINT, cuePointHandlerA); 								
							}							
							cd.addEventListener(VideoLoader.VIDEO_COMPLETE, hideVideo);
							hidebutton.x =  currentSprite.x;
							hidebutton.y =  currentSprite.y;
							//playedVidTitle.push(title);
					}
				}
				
				createHideVideo(cd);
				
				LoadAssets.instance.demoteCover();
		}
		
		
		///////////////////////////INTRO CUE POINTS////////////////////////////////
		function cuePointHandlerA(event:LoaderEvent):void { 
			
			switch(event.data.name) {
				
				case "showCoverFlow":
				var albumCovers:Sprite = Main.instance.cfHolder
				albumCovers.visible = true;
				TweenLite.to(albumCovers, .5, { alpha: 1} );
				break;
				
				case "scene0":
				Coverflow.instance.gotoCoverflowItem(1); 
				break;
				
				case "scene1":
				Coverflow.instance.gotoCoverflowItem(2); 
				break;
				
				case "scene2":
				Coverflow.instance.gotoCoverflowItem(3); 
				break;
				
				case "scene3":
				Coverflow.instance.gotoCoverflowItem(4); 
				break;
				
				case "scene4":
				Coverflow.instance.gotoCoverflowItem(5); 
				break;
				
				case "scene5":
				Coverflow.instance.gotoCoverflowItem(2); 
				break;
				
				
				case "showNavs":
				var albumSliders:Sprite = Main.instance.coverflow.coverSlider;
				albumSliders.visible = true;
				TweenLite.to(albumSliders, .5, { alpha: 1 } );
				break;
				
				case "bottomApps":
				var apps:Sprite = Main.instance.Assets.apps;
				apps.visible = true;
				TweenLite.to(apps, .5, { alpha: 1 } );
				
				break;
				
			}
		}
		
		
		

		
		///////////////////////////INTRO CUE POINTS////////////////////////////////
		
		
		
		private function skipMovieIntro(e:MouseEvent):void {
			TweenLite.to(_vids, .5, { alpha: 0, visible:false, onComplete:function() { currentVid.gotoVideoTime(0); currentVid.pauseVideo();  removeSquareBlocker() }} )
			Scenes.instance.showHotSpots();
			removeSquareBlocker();
		}
		
		
		private function hideVideo(e:LoaderEvent):void {	
			TweenLite.to(_vids, .5, { alpha: 0, visible:false, onComplete:function() { e.target.gotoVideoTime(0); removeSquareBlocker() }} )
			Scenes.instance.showHotSpots();
		}
		
		public function removeSquareBlocker():void {
			currentSprite.visible = false
			if(this.parent.getChildByName("cover")){
			
				//var coverSprite:Sprite = this.parent.getChildByName("cover");
			this.parent.removeChild(this.parent.getChildByName("cover"))
			//TweenLite.to(this.parent.getChildByName("cover"),.5,{alpha:0,visible:false})
			}
			
			var bottoApps:Sprite = Main.instance.Assets.apps;
			var covers:Sprite = Main.instance.cfHolder;
			var albumSliders:Sprite = Main.instance.coverflow.coverSlider;
			
			if (bottoApps.alpha != 1) {
				bottoApps.visible = true;
				TweenLite.to(bottoApps, .5, { alpha: 1 } );
				
				albumSliders.visible = true;
				TweenLite.to(albumSliders, .5, { alpha: 1, delay:1 } );
				
				covers.visible = true;
				TweenLite.to(covers,.5,{alpha: 1, delay:.5});
			}
			
		}
		
		public function createTextLabel(t:String, s:int, color:String = "0xFFFFFF"):TextField
		{
			//trace("This is trace create text" + t)
			format1.size = s;
			format1.letterSpacing = .5;
			format1.font = myfont1.fontName;
			format1.align = TextFormatAlign.CENTER;
			format1.color = Number(color);/*0x873348;*/

			format2.size = s;
			format2.letterSpacing = .5;
			format2.font = myfont2.fontName;
			format2.align = TextFormatAlign.CENTER;
			format2.color = Number(color);/* 0x666666;*/



			var tf:TextField = new TextField  ;
			tf.text = t;
			if (s == 11)
			{
				tf.setTextFormat(format2);
			}
			else
			{
				tf.setTextFormat(format1);
			}//tf.border = true;
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.condenseWhite = true;
			//tf.wordWrap = true;
			//tf.multiline = true;
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;

			return tf;
		}
		
	}

}