﻿package com.apps.map {	import flash.display.Sprite;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.MouseEvent;	import com.greensock.*;	import com.greensock.easing.*;	import com.greensock.loading.*;	import com.greensock.loading.display.*;	import com.greensock.events.LoaderEvent;	import flash.text.TextField;	import flash.text.TextField;    import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;	import flash.text.AntiAliasType;	import flash.text.Font;	import flash.text.FontStyle;	import flash.display.*		/**	 * ...	 * @author Gerry Yumul	 */	public class LocationGrid extends Sprite 	{		private var _region:String;		private var myfont1 = new Font1;		private var myfont2 = new Font2;		Font.registerFont(Font1);		Font.registerFont(Font2);		private var format1:TextFormat = new TextFormat;		private var format2:TextFormat = new TextFormat;		private var _xmlList:XMLList;		private var headSpriteHolder:Sprite = new Sprite;		private var dataSpriteHolder:Sprite = new Sprite;		private var btnArrs:Array = new Array;		private var labelHolderArrs:Array = new Array;		private var pointArrs:Array = new Array;		private var headPrograms:TextField;		public static var _instance:LocationGrid;		public static function get instance():LocationGrid { return _instance; }						public function LocationGrid(region:String) 		{			_instance = this;			_region = region			init();		}				private function init():void {			createbgSquare();						this.addChild(headSpriteHolder);			headSpriteHolder.y = -40;						var headState:TextField = createTextField("STATE", 13, "0x873348")			headState.x = 0;			headSpriteHolder.addChild(headState)						var headSchool:TextField = createTextField("SCHOOL", 13,"0x873348")			headSchool.x = 100 			headSpriteHolder.addChild(headSchool);						headPrograms = createTextField("CONTACT INFORMATION", 13, "0x873348")			headPrograms.x = 322;			headPrograms.visible = false;			headSpriteHolder.addChild(headPrograms)			_xmlList = MapDetails.instance._currXML.details.region.(@name == _region);									headSpriteHolder.addChild(dataSpriteHolder)			dataSpriteHolder.y = headSpriteHolder.height;						showData();								}				private function showData():void {						for (var i:int = 0; i < _xmlList.state.length(); i++) 			{				var stateName:String = _xmlList.state[i].attribute("name");				var state:TextField = createTextField(stateName, 11, "0x000000")				var stateHolder:Sprite = new Sprite();								state.name = stateName;				state.y = dataSpriteHolder.height;				dataSpriteHolder.addChild(stateHolder);				//if (i != 0) stateHolder.y = stateHolder.height;				stateHolder.addChild(state);								var schoolContainer:Sprite = new Sprite;				schoolContainer.y = state.y;				dataSpriteHolder.addChild(schoolContainer);/**/								var schoolList:XMLList = _xmlList.state[i].school;				trace("state::::::::  " + stateName);				for (var j:int = 0; j < schoolList.length(); j++) 				{										var schoolName:String =  _xmlList.state[i].school[j].attribute("name");					var schoolLabel:TextField = createTextField(schoolName, 11, "0x666666");										trace("schoolName::::::::  " + schoolName);					var schoolHolder:Sprite = new Sprite;					var labelHolder:Sprite = new Sprite;					labelHolder.name = schoolName;					labelHolderArrs.push(labelHolder);					var schoolHolderBg:Sprite = createSquareBg(schoolLabel.width + 2, schoolLabel.height + 1)					schoolHolderBg.visible = false;					schoolHolderBg.name = schoolName + "btn";					var schoolHolderBtn:Sprite = createSquareBg(schoolLabel.width + 2, schoolLabel.height + 1)					schoolHolderBtn.name = schoolName;					schoolHolderBtn.alpha = 0;					schoolHolderBtn.buttonMode = true;										btnArrs.push(schoolHolderBtn);					addButtonEvents();										schoolHolder.x = 100;					schoolHolder.y = schoolContainer.height;										schoolContainer.addChild(schoolHolder);					var pointer:Sprite = new orange_bullet_on;					pointer.name = "pointer" + schoolName;					pointer.visible = false;					pointer.y = 4;					pointer.x = -8					pointArrs.push(pointer)					schoolHolder.addChild(pointer);															schoolHolder.addChild(schoolHolderBg)					schoolHolder.addChild(labelHolder);					labelHolder.addChild(schoolLabel);					schoolHolder.addChild(schoolHolderBtn)														}								var schoolHolderSpacer:Sprite = createSquareBg(schoolLabel.width + 2, (schoolLabel.height / 2) + 1)				schoolHolderSpacer.y = dataSpriteHolder.height + 5				schoolHolderSpacer.visible = false;				dataSpriteHolder.addChild(schoolHolderSpacer);							}						createBackButton();		}				private function getPrograms(e:MouseEvent):void {			trace("location name:::: " + e.target.name)			//removeButtonEvents();						for (var i:int = 0; i < labelHolderArrs.length; i++) 			{				if (labelHolderArrs[i].name == e.target.name) {					TweenLite.to(labelHolderArrs[i], .1, { tint:0x873348 } )					pointArrs[i].visible = true;					headPrograms.visible = true;					programs(e.target.name)									}else {					TweenLite.to(labelHolderArrs[i], .1, { tint:null } )					pointArrs[i].visible = false;					}			}		}				////SHOW PROGRAMS FILTERED BY SCHOOL NAME		private function programs(select:String) {			trace("Selected Program:::::" + select)			trace("Master XML:::::" + _xmlList)			trace("Filtered programs:       " + _xmlList.state.school.(@name == select));			if(dataSpriteHolder.getChildByName("plist")) dataSpriteHolder.removeChild(dataSpriteHolder.getChildByName("plist"))						var sName:String = select;			var addr:String = _xmlList.state.school.(@name == select).@address;			var city:String = _xmlList.state.school.(@name == select).@city;			var state:String = _xmlList.state.school.(@name == select).@state;			var zip:String = _xmlList.state.school.(@name == select).@zip;			var phone:String = _xmlList.state.school.(@name == select).@phone;			var email:String = _xmlList.state.school.(@name == select).@email;									var contactInfo:Sprite = new Sprite;			contactInfo.x = 322			dataSpriteHolder.addChild(contactInfo);						contactInfo.name = "plist"									var sn:TextField = createTextField(sName, 11, "0x000000");			sn.y = contactInfo.height;			contactInfo.addChild(sn);						var address:TextField = createTextField(addr, 11, "0x000000");			address.y = contactInfo.height;			contactInfo.addChild(address);						var ct:TextField = createTextField(city + " " + state + " " + zip, 11, "0x000000");			ct.y = contactInfo.height;			contactInfo.addChild(ct);						var phoneN:TextField = createTextField(phone, 11, "0x000000");			phoneN.y = contactInfo.height;			contactInfo.addChild(phoneN);						var emailAdd:TextField = createTextField(email, 11, "0x000000");			emailAdd.y = contactInfo.height;			contactInfo.addChild(emailAdd);						var programHeader:TextField = createTextField("PROGRAMS", 12, "0x873348");									contactInfo.addChild(programHeader);			programHeader.y = contactInfo.height + 20;						var programList:ShowProgramsBySchool = new ShowProgramsBySchool(_xmlList.state.school.(@name == select));			//programList.x = 332;			programList.y = contactInfo.height;						contactInfo.addChild(programList);						var my_shape:Shape = new Shape;						contactInfo.addChild(my_shape);			my_shape.graphics.lineStyle(1,0xC4C4C4, 1);			my_shape.graphics.moveTo(-10, -16); 			my_shape.graphics.lineTo(-10, 300);		}						private function addButtonEvents():void {			for (var i:int = 0; i < btnArrs.length; i++) 			{				btnArrs[i].addEventListener(MouseEvent.CLICK, getPrograms)				btnArrs[i].addEventListener(MouseEvent.MOUSE_OVER, getHoverPrograms)				btnArrs[i].addEventListener(MouseEvent.MOUSE_OUT, getOutPrograms)			}		}				private function removeButtonEvents():void {			for (var i:int = 0; i < btnArrs.length; i++) 			{				btnArrs[i].removeEventListener(MouseEvent.CLICK, getPrograms)				btnArrs[i].removeEventListener(MouseEvent.MOUSE_OVER, getHoverPrograms)				btnArrs[i].removeEventListener(MouseEvent.MOUSE_OUT, getOutPrograms)			}		}				//RETURN BUTTON		private function createBackButton():void {			var closeLbl:TextField = createTextField(" << BACK TO MAP", 11, "0x873348");			var closeBtnHolder:Sprite = new Sprite;						var closesq:Sprite = createSquareBg(closeLbl.width + 2, closeLbl.height + 1)			var closesqBtn:Sprite = createSquareBg(closeLbl.width + 2, closeLbl.height + 1)			closesqBtn.alpha = 0;			closesqBtn.buttonMode = true;			closesqBtn.addEventListener(MouseEvent.CLICK, BackToMap)							dataSpriteHolder.addChild(closeBtnHolder);			closeBtnHolder.y = 290;			closeBtnHolder.addChild(closesq);			closeBtnHolder.addChild(closeLbl);			closeBtnHolder.addChild(closesqBtn);			}				private function BackToMap(e:MouseEvent):void {			MapDetails.instance.removeLocationGrid();		}				private function getHoverPrograms(e:MouseEvent):void {			var n:String = e.target.name			var par:Sprite = Sprite(e.currentTarget.parent);			par.getChildByName(n+"btn").visible = true					}				private function getOutPrograms(e:MouseEvent):void {			var n:String = e.target.name			var par:Sprite = Sprite(e.currentTarget.parent);			par.getChildByName(n+"btn").visible = false		}				private function createbgSquare():void {			var bg:Sprite = createSquare(552, 365)			//bg.alpha = .7			this.addChild(bg);			trace("error")		}				private function createSquare(w:int, h:int):Sprite		{			var square:Sprite = new detail_ui;				//square.x = -8				//square.y = -8			square.width = w;			square.height = h;			return square;		}				public function createSquareBg(w:int, h:int):Sprite		{			var square:Sprite = new Sprite;			square.graphics.beginFill(0xFFFFFF);			square.graphics.drawRoundRect(0,0,w,h,5);			square.graphics.endFill();/**/			//square.alpha = 1;						return square;		}					public function createTextField(t:String, s:int, color:String = "0xFFFFFF"):TextField		{			//trace("This is trace create text" + t)						format1.size = s;			format1.letterSpacing = .5;			format1.font = myfont1.fontName;			format1.align = TextFormatAlign.CENTER;			format1.color = Number(color) /*0x873348;*/						format2.size = s;			format2.letterSpacing = .5;			format2.font = myfont2.fontName;			format2.align = TextFormatAlign.CENTER;			format2.color = Number(color) /* 0x666666;*/												var tf:TextField = new TextField;			tf.text = t;			if(s == 11) tf.setTextFormat(format2) else tf.setTextFormat(format1) ;			//tf.border = true;			tf.embedFonts = true;			tf.antiAliasType = AntiAliasType.ADVANCED;			tf.condenseWhite = true;			//tf.wordWrap = true;			//tf.multiline = true;			tf.autoSize = TextFieldAutoSize.LEFT;							return tf;		}							}}