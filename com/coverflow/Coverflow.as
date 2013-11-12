////////////////////////////////////////////
// Project: Flash 10 Coverflow
// Date: 10/3/09
// Author: Stephen Weber
////////////////////////////////////////////
package com.coverflow {

	////////////////////////////////////////////
	// IMPORTS
	////////////////////////////////////////////

	import com.Scenes;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;
	import flash.display.Stage;
	import flash.utils.setTimeout;
	import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	import com.Application;


		
	//TweenLite - Tweening Engine - SOURCE: http://blog.greensock.com/tweenliteas3/
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	

	public class Coverflow extends Sprite {

		////////////////////////////////////////////
		// VARIABLES
		////////////////////////////////////////////

		// size of the stage
		private var sw:Number;
		private var sh:Number;
		
		private var background:Background;

		// padding between each cover, can be customed via xml
		private var coverflowSpacing:Number=30;

		// transition time for movement
		private var transitionTime:Number=0.75;

		// the center of the stage
		private var centerX:Number;
		private var centerY:Number;

		// store each image cover's instance
		private var coverArray:Array=new Array();

		// title of each image
		private var coverLabel:CoverflowTitle = new CoverflowTitle();

		// the slider under the image cover
		public var coverSlider:Scrollbar;
		
		// how many image covers
		private var coverflowItemsTotal:Number;

		// how to open the link
		private var _target:String;

		// size of the image cover
		private var coverflowImageWidth:Number;
		
		private var coverflowImageHeight:Number;

		//Holds the objects in the data array
		private var _data:Array = new Array();
		
		// the y position of the item's title
		private var coverLabelPositionY:Number;
		
		//Z Position of Current CoverflowItem
		private var centerCoverflowZPosition:Number=0;

		// display the middle of the cover or not
		private var startIndexInCenter:Boolean=true;

		// which cover to display in the beginning
		private var startIndex:Number=0;

		// the slide's Y position
		private var coverSlidePositionY:Number;

		//Holder for current CoverflowItem
		private var _currentCover:Number;
		
		//CoverflowItem Container
		private var coverflowItemContainer:Sprite = new Sprite();

		//XML Loading
		private var coverflowXMLLoader:URLLoader;
		
		//XML
		private var coverflowXML:XML;

		// the image cover's white border padding
		private var padding:Number=4;
		
		// stage reference
		private var _stage:Stage;
		
		//reflection
		private var reflection:Reflect;

		//Reflection Properties
		private var reflectionAlpha:Number;

		private var reflectionRatio:Number;

		private var reflectionDistance:Number;

		private var reflectionUpdateTime:Number;

		private var reflectionDropoff:Number;
		
		//Navigation container
		private var navContainer:Sprite = new Sprite;
		
		private var subnav:sub_nav_bg = new sub_nav_bg;
		private var _hide:Boolean = false;
		private var leftX:int;
		private var rightX:int;
		
		public static var _instance:Coverflow;
		public static function get instance():Coverflow { return _instance; }
		
		
		
		//square
		//private var sq:Sprite = new Sprite;

		////////////////////////////////////////////
		// CONSTRUCTOR - INITIAL ACTIONS
		////////////////////////////////////////////
		public function Coverflow(_width:Number, _height:Number, __stage:Stage = null):void {
			
			_instance = this;
			_stage=__stage;
			sw=_width;
			sh=_height;
			centerX=_width>>1;
			//centerY=(_height>>1) - 20;
			centerY = 200;
			loadXML();
			
			//Grabs Background color passed in through FlashVars
			var backgColor:String = _stage.loaderInfo.parameters["backgroundColor"];
			
			if(backgColor == null) {
				//Black
				backgColor = "0x000000";
				
				//White
				//backgColor = "0xFFFFFF";
			}
			
			//Creates Background MovieClip
			background = new Background();
			
			//Set Background To Provided Width/Height
			background.width = _width;
			background.height = _height;
			
			//Adds background MovieClip to DisplayList
			addChild(background);
			
			//Tints Background MovieClip with provided tint
			TweenPlugin.activate([TintPlugin]);
			TweenLite.to(background, 0, {tint:backgColor});
			
			//Grabs Background color passed in through FlashVars
			var labelColor:String = _stage.loaderInfo.parameters["labelColor"];
			
			//Check for value and then default
			if(labelColor == null) {
				//Black
				//labelColor = "0x000000";
				
				//White
				labelColor = "0xFF9900";
			}
			
			//Tint Coverflow label to color provided
			//TweenLite.to(coverLabel, 0, {tint:labelColor});
			
			if (_stage) {
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}	
			/*this.addChild(sq);
			sq.graphics.beginFill(0x0000FF);
			sq.graphics.drawRect(0,0,100,100);
			sq.graphics.endFill();*/
			
			this.addChild(coverflowItemContainer);
			coverflowItemContainer.name = "coverParent"	
		}
		////////////////////////////////////////////
		// FUNCTIONS
		////////////////////////////////////////////
		
		private function keyDownHandler(e:KeyboardEvent):void {
			if (e.keyCode==37||e.keyCode==74) {
				clickPre();
			}
			if (e.keyCode==39||e.keyCode==75) {
				clickNext();
			}
			// 72 stand for "H" key, 191 stand for "?" key
			if (e.keyCode==72||e.keyCode==191) {

			}
		}

		// display the previous image
		private function clickPre(e:Event=null):void {
			_currentCover--;
			if (_currentCover<0) {
				_currentCover=coverflowItemsTotal-1;
			}
			coverSlider.value=_currentCover;
			gotoCoverflowItem(_currentCover);
		}

		// display the next image
		private function clickNext(e:Event=null):void {
			_currentCover++;
			if (_currentCover>coverflowItemsTotal-1) {
				_currentCover=0;
			}
			coverSlider.value=_currentCover;
			gotoCoverflowItem(_currentCover);
		}

		// loading the XML
		private function loadXML():void {
			
			//Loads XML passed through FlashVars
			var xml_source:String = _stage.loaderInfo.parameters["xmlPath"];
			
			//If XML not found through FlashVars then defaults to xml path below
			if(xml_source == null) {
				xml_source = 'xml/data.xml';
			}
			
			// loading the cover xml here
			coverflowXMLLoader = new URLLoader();
			coverflowXMLLoader.load(new URLRequest("xml/config.xml"));
			coverflowXMLLoader.addEventListener(Event.COMPLETE, coverflowXMLLoader_Complete);
			coverflowXMLLoader.addEventListener(IOErrorEvent.IO_ERROR, coverflowXMLLoader_IOError);

		}

		// parse the XML
		private function coverflowXMLLoader_Complete(e:Event):void {
			coverflowXML=new XML(e.target.data);
			coverflowItemsTotal=coverflowXML.coverflow.cover.length();
			coverflowSpacing=Number(coverflowXML.coverflow.@coverflowSpacing);
			coverflowImageWidth=Number(coverflowXML.coverflow.@imageWidth);
			coverflowImageHeight=Number(coverflowXML.coverflow.@imageHeight);
			coverLabelPositionY=Number(coverflowXML.coverflow.@coverLabelPositionY);
			coverSlidePositionY=Number(coverflowXML.coverflow.@coverSlidePositionY);
			transitionTime=Number(coverflowXML.coverflow.@transitionTime);
			centerCoverflowZPosition=Number(coverflowXML.coverflow.@centerCoverflowZPosition);

			//Image Border
			padding = Number(coverflowXML.coverflow.@imagePadding)
			
			//Reflection Attributes
			reflectionAlpha=Number(coverflowXML.coverflow.@reflectionAlpha);
			reflectionRatio=Number(coverflowXML.coverflow.@reflectionRatio);
			reflectionDistance=Number(coverflowXML.coverflow.@reflectionDistance);
			reflectionUpdateTime=Number(coverflowXML.coverflow.@reflectionUpdateTime);
			reflectionDropoff=Number(coverflowXML.overflow.@reflectionDropoff);

			startIndex=Number(coverflowXML.coverflow.@startIndex);
			startIndexInCenter = (coverflowXML.coverflow.@startIndexInCenter.toLowerCase().toString()=="yes");
			_target=coverflowXML.coverflow.@target.toString();
			
			for (var i=0; i<coverflowItemsTotal; i++) {
				
				//Make An Object To Hold Values
				var _obj:Object = new Object();
				
				//Set Values To Object from XML for each CoverflowItem
				_obj.image = (coverflowXML.coverflow.cover[i].@img.toString());
				_obj.title = (coverflowXML.coverflow.cover[i].@title.toString());
				_obj.link = (coverflowXML.coverflow.cover[i].@link.toString());
				_obj.desc = (coverflowXML.coverflow.cover[i].@desc.toString());
				_data[i] = _obj;
				
			}
			loadCover();
		}

		private function coverflowXMLLoader_IOError(event:IOErrorEvent):void {
			trace("Coverflow XML Load Error: "+ event);
		}

		// load the image cover when xml is loaded
		private function loadCover():void {
			
			this.addChild(navContainer);
			
			for (var i:int = 0; i < coverflowItemsTotal; i++) {
				var cover:Sprite=createCover(i,_data[i].image);
				coverArray[i]=cover;
				cover.y=centerY;
				cover.z = 0;
				coverflowItemContainer.addChild(cover);
				
				/*var nav:Labeler = new Labeler;
				navContainer.addChild(nav);
				nav.txt.text = _data[i].title;
				nav.name = "Thisnva" + i
				nav.y = 555;
				
				nav.txt. height = 18;
				nav.txt.autoSize = TextFieldAutoSize.LEFT;
				nav.btn.width = nav.txt.width
				nav.bg.width = nav.txt.width
				//nav.x = navContainer.width;
				nav.x = nav.width * i;
				
				nav.buttonMode = true;
				
				nav.addEventListener(MouseEvent.CLICK, navClick)
				nav.addEventListener(MouseEvent.MOUSE_OVER, navOver)
				nav.addEventListener(MouseEvent.MOUSE_OUT, navOut)*/
				
			//	nav.btn.height = nav.txt.height
			//	nav.bg.height = nav.txt.height
					
			}

			if (startIndexInCenter) {
				startIndex=coverArray.length>>1;
				gotoCoverflowItem(startIndex);

			} else {

				gotoCoverflowItem(startIndex);

			}
			
			subnav.y = 545 - 38;
			subnav.visible = false;
			subnav.bg.mask = subnav.masker;
			this.addChild(subnav)/**/
			
			
			_currentCover=startIndex;
			coverSlider = new Scrollbar(coverflowItemsTotal, _stage);
			leftX = coverSlider.left.x;
			rightX = coverSlider.right.x;
			coverSlider.value=startIndex;
			//coverSlider.x = ((_stage.stageWidth/2) - (coverSlider.width/2)) - 157;
			coverSlider.x = 97
			coverSlider.y = 545;
			coverSlider.visible = false;
			coverSlider.alpha = 0;
			//coverSlider.sub_bg.visible = false;
			coverSlider.addEventListener("UPDATE", coverSlider_Update);
			coverSlider.addEventListener("PREVIOUS", coverSlider_Previous);
			coverSlider.addEventListener("NEXT", coverSlider_Next);
			addChild(coverSlider);

			//coverLabel.x = (sw - coverLabel.width)>>1;
			coverLabel.x = (coverSlider.width/2)  - ((coverLabel.width/2 + 21));
			coverLabel.y=coverLabelPositionY;
			//addChild(coverLabel);

			addChild(coverSlider);
			addChild(coverLabel);
			//navContainer.x = 1024 / 2 - navContainer.width / 2;
			setChildIndex(navContainer, numChildren - 1)

		}

		private function coverSlider_Update(e:Event):void {
			var value:Number=(coverSlider.value);
			gotoCoverflowItem(value);
			e.stopPropagation();
		}

		private function coverSlider_Previous(e:Event):void {
			clickPre();
		}

		private function coverSlider_Next(e:Event):void {
			clickNext();
		}

		// move to a certain cover via number
		public function gotoCoverflowItem(n:int):void {
			_currentCover=n;
			reOrderCover(n);
			if (coverSlider) {
				coverSlider.value=n;
			}
		}

		private function cover_Selected(event:CoverflowItemEvent):void {
			
			
			
			trace("TARGET:::::" + event.target.parent.name)
			
			//trace("TARGET:::::" + event.target.parent.name)

			var currentCover:uint=event.data.id;

			if (coverArray[currentCover].rotationY==0) {
				try {
					// open the link if user click the cover in the middle again
					/*if (_data[currentCover].link!="") {
						navigateToURL(new URLRequest(_data[currentCover].link), _target);
					}*/
						hideSliderSelect(_data[currentCover].title);
						
					
				} catch (e:Error) {
					//
				}

			} else {
				gotoCoverflowItem(currentCover);

			}
			
			trace("event.data.id:::::::::::::::" + _data[currentCover].title);
			
			//
		
			
			

		}

		// change each cover's position and rotation
		private function reOrderCover(currentCover:uint):void {
			for (var i:uint = 0, len:uint = coverArray.length; i < len; i++) {
				var cover:Sprite=coverArray[i];
			
				if (i<currentCover) {
					//Left Side
					TweenLite.to(cover, transitionTime, {x:(centerX - (currentCover - i) * coverflowSpacing - coverflowImageWidth/2), z:(coverflowImageWidth/2), rotationY:-65, alpha: .4});
				} else if (i > currentCover) {
					//Right Side
					TweenLite.to(cover, transitionTime, {x:(centerX + (i - currentCover) * coverflowSpacing + coverflowImageWidth/2), z:(coverflowImageWidth/2), rotationY:65, alpha: .4});
				} else {
					//Center Coverflow
					TweenLite.to(cover, transitionTime, {x:centerX, z:centerCoverflowZPosition, rotationY:0, alpha: 1, onComplete:currentSelect, onCompleteParams:[_data[i].title]});

					//Label Handling
					coverLabel._text.text = _data[i].title;
					coverLabel._desc.text=_data[i].desc;
					coverLabel.alpha=0;
					TweenLite.to(coverLabel, 0.75, {alpha:1,delay:0.2});

				}
			}
			for (i = 0; i < currentCover; i++) {
				addChild(coverArray[i]);
				//coverArray[i].x = 300
			}
			for (i = coverArray.length - 1; i > currentCover; i--) {
				addChild(coverArray[i]);
				//coverArray[i].x = 300
			}

			addChild(coverArray[currentCover]);
			if (coverSlider) {
				addChild(coverLabel);
				addChild(coverSlider);
			}
			
			setChildIndex(navContainer, numChildren - 1)
			
			
		}

		//Create CoverflowItem and Set Data To It
		private function createCover(num:uint, url:String):Sprite {

			//Setup Data
			var _data:Object = new Object();
			_data.id=num;

			//Create CoverflowItem
			var cover:CoverflowItem=new CoverflowItem(_data);

			//Listen for Click
			cover.addEventListener(CoverflowItemEvent.COVERFLOWITEM_SELECTED, cover_Selected);

			//Set Some Values
			cover.name=num.toString();
			cover.image=url;
			cover.padding=padding;
			cover.imageWidth=coverflowImageWidth;
			cover.imageHeight=coverflowImageHeight;
			cover.setReflection(reflectionAlpha, reflectionRatio, reflectionDistance, reflectionUpdateTime, reflectionDropoff);

			//Put CoverflowItem in Sprite Container
			var coverItem:Sprite = new Sprite();
			cover.x=- coverflowImageWidth/2-padding;
			cover.y=- coverflowImageHeight/2-padding;
			coverItem.addChild(cover);
			coverItem.name=num.toString();

			return coverItem;
		}
		
		public function centerCF():void {
			coverflowItemContainer.x = -800;
			trace("CENTER CF")
		}
		
		private function currentSelect(current:String):void {
			trace("THIS IS CURRENT" + current)
		}
		
		private function navClick(e:MouseEvent):void {
		var curr:int = e.target.parent.parent.getChildIndex(e.target.parent);
		reOrderCover(curr);
		gotoCoverflowItem(curr)
			
			
		
		}
		
		private function navOut(e:MouseEvent):void {
			
		}
		
		private function navOver(e:MouseEvent):void {
			
		}
		
		private function hideSliderSelect(curr:String):void {
			
			
			
			if (!_hide) 
				{
					
					var sceneXML:XMLList = coverflowXML.coverflow.cover;
				
					TweenLite.to(coverSlider, .25, { y: 688 } );
					TweenLite.to(coverSlider.scrubber, .01, { visible:false } );
					TweenLite.to(subnav.masker, .25, { y: 118 } );
					TweenLite.to(coverSlider.left, .25, { x: coverSlider.left.x - 100, alpha: 0, delay:.35} );
					TweenLite.to(coverSlider.right, .25, { x: coverSlider.right.x + 100, alpha: 0, delay:.35 } );
					
					/////SHOW SCENE/////
					Main.instance.Assets.sceneClass.showScene(sceneXML.(@title == curr));
					
					subnav.visible = true;
					navContainer.visible = false;
					_hide = true;
					Main.instance.Assets.apps.lowerAppsGroup()
					//this.getChildByName("instance8").alpha = .1
					
					_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
					
					
					
					for (var i:int = 0; i < coverArray.length; i++) 
					{
						coverArray[i].visible = false;
						//coverArray[i].parent.parent.parent.removeEventListener(CoverflowItemEvent.COVERFLOWITEM_SELECTED, cover_Selected);
						trace(coverArray[i])
					}/**/
				
					coverLabel.visible = false;
				}
			else
				{
					TweenLite.to(coverSlider, .25, { y: 545} );
					TweenLite.to(subnav.masker, .25, { y: -1 ,  onComplete:function() {  navContainer.visible = true; }} );
					
					TweenLite.to(subnav.masker, .25, { y: -1 ,  onComplete:function(){  subnav.visible = false; }} );
					
					TweenLite.to(coverSlider.left, .25, { x: leftX, alpha: 1} );
					TweenLite.to(coverSlider.right, .25, { x: rightX, alpha: 1 } );
					TweenLite.to(coverSlider.scrubber, .25, { visible:true } );
					//;
					_hide = false;
						Main.instance.Assets.apps.lowerAppsGroup()
						
					_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
					
					for (var j:int = 0; j < coverArray.length; j++) 
					{
						coverArray[j].visible = true;
						//coverArray[j].parent.addEventListener(CoverflowItemEvent.COVERFLOWITEM_SELECTED, cover_Selected);
					}/**/
					
					coverLabel.visible = true;
				}
				
			trace("THISI IS THE CURRENT COVER" + _currentCover);
				
		}
		
		public function resetToDefault():void {
			hideSliderSelect(String(_currentCover));
			
		}
		
		

	}
}