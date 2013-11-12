package com
{
	import adobe.utils.CustomActions;
	//import fl.controls.TextArea;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.FontType;
	
	/**
	 * ...
	 * @author Gerry Yumul
	 */
	public class NavItems extends Sprite 
	{
		private var _navarrs:Array;
		//private var format1:TextFormat = new TextFormat;
		private var myfont1 = new Font1;
		private var navHolder:Sprite = new Sprite;
		private var _sceneName;
		private var currentSelect:Sprite;
		Font.registerFont(Font1);
		private var navBlocker:Sprite;
		public static var _instance:NavItems;
		private var navArrs:Array = new Array;
		public static function get instance():NavItems { return _instance; }
		
		
		
		public function NavItems(navarrs, sceneName) 
		{
			_instance = this;
			_navarrs = navarrs;
			_sceneName = sceneName;
			init();
		}
		
		private function init():void {
			//trace("This is the nav arrs: " + _navarrs)
			
			
			
			this.addChild(navHolder);
			navHolder.y = 100;
			
			createNavItem();
			
		}
		
		private function createNavItem():void {
			
			for (var i:int = 0; i < _navarrs.length; i++) 
			{	
				///CREATE SUBNAV///
				var navItem:Sprite = new Sprite;
				navItem.addEventListener(MouseEvent.CLICK, activateSection)
				navItem.addEventListener(MouseEvent.MOUSE_OVER, activateHoverSection)
				navItem.addEventListener(MouseEvent.MOUSE_OUT, activateHoverOutSection)
				navItem.buttonMode = true;
				navItem.name = _navarrs[i];
				navHolder.addChild(navItem)
				
				
				var label:TextField = createTextField(_navarrs[i]);
				
				navItem.x = navHolder.width;
					
				var tw:int = label.width + 8;
				var th:int = label.height + 3
				
				var navTopItem:Sprite = createSquare(tw, th);
				navTopItem.alpha = 0;
				
				var navBottomItem:Sprite = createSquare(tw, th);
				navBottomItem.visible = false;
				
				var spacer:Sprite = createSquare(tw + 20, th);
				spacer.visible = false;
				
				label.x = 3;
				label.y = 2;
				
				navItem.addChild(spacer);
				navItem.addChild(navBottomItem);
				navItem.addChild(label);
				navItem.addChild(navTopItem);	
				
				navArrs.push(navArrs);
			}
			
			var sectionLabel:TextField = createTextField(_sceneName + "   |")
			sectionLabel.y = 37;
			sectionLabel.x = 3
			
			var rBottomItem:Sprite = createSquare(sectionLabel.width - 10, sectionLabel.height + 3);
			rBottomItem.visible = true;	
			rBottomItem.y = 35
			navHolder.addChild(rBottomItem);
			navHolder.addChild(sectionLabel);
			
		//	var goBackToSectionExplorer:TextField = createTextField("Return to Scene Explorer", 0xFF9000)
			
			var Item:Sprite = new Sprite;
				Item.addEventListener(MouseEvent.CLICK, returnToSceneSection);
				Item.addEventListener(MouseEvent.MOUSE_OVER, returnToSceneSectionHover);
				Item.addEventListener(MouseEvent.MOUSE_OUT, returnToSceneSectionOut);
				Item.buttonMode = true;
				Item.name = "returnToDefault";
				navHolder.addChild(Item)
				
				
			var returnLabel:TextField = createTextField("RETURN TO SCENE SELECTOR");
				
				Item.x = sectionLabel.width + 5;
				Item.y = 35;
					
				var rtw:int = returnLabel.width + 8;
				var rth:int = returnLabel.height + 3
				
				var TopItem:Sprite = createSquare(rtw, rth);
				TopItem.alpha = 0;
				
				var BottomItem:Sprite = createSquare(rtw, rth);
				BottomItem.visible = false;
				var rspacer:Sprite = createSquare(rtw + 20, rth);
				rspacer.visible = false;
				returnLabel.x = 3;
				returnLabel.y = 2;
				Item.addChild(rspacer);
				Item.addChild(BottomItem);
				Item.addChild(returnLabel);
				Item.addChild(TopItem);	
			
			//	navBlocker = createSquare(stage.stageWidth, stage.stageHeight)
				//this.addChild(navBlocker)

		}
		
		//////////////////////FUNCTION WHEN SCENE SECTION IS SELECTED////////////////////
		private function activateSection(e:MouseEvent):void {
			//trace("Activate this section" + e.target.parent.name)
			currentDeSelectItem();
			currentSelectItem(e.target.parent);
			trace("" + e.target.parent.name);
			Scenes.instance.revealSection(e.target.parent.name)

		}
		
		
	/////////////////////RETURN TO SCENE BUTTON EVENTS////////////////////
		private function returnToSceneSection(e:MouseEvent):void {
			Scenes.instance.returnToDefault();


		}
		
		private function returnToSceneSectionHover(e:MouseEvent):void {
			var t:Sprite = e.target.parent as Sprite
			t.getChildAt(1).alpha = .4;
			t.getChildAt(1).visible = true;

		}
		
		private function returnToSceneSectionOut(e:MouseEvent):void {
			var t:Sprite = e.target.parent as Sprite
			t.getChildAt(1).alpha = .4;
			t.getChildAt(1).visible = false;

		}
		
		
		/////////////////////NAV BUTTON EVENTS////////////////////
		private function activateHoverSection(e:MouseEvent):void {
			//trace("Activate this section" + e.target.parent.name)
			var t:Sprite = e.target.parent as Sprite
			t.getChildAt(1).alpha = .8;
			t.getChildAt(1).visible = true;
			HotSpots.instance.showLabel(e.target.parent.name)
			
			//Scenes.instance.revealSection(e.target.parent.name)
		}
		
		private function activateHoverOutSection(e:MouseEvent):void {
			//trace("Activate this section" + e.target.parent.name)
			var t:Sprite = e.target.parent as Sprite
			t.getChildAt(1).alpha = .4;
			t.getChildAt(1).visible = false;
			HotSpots.instance.hideLabel()
			//Scenes.instance.revealSection("default")
		}
		
		public function currentDeSelectItem():void {
			if(currentSelect != null){
				currentSelect.buttonMode = true;
				currentSelect.getChildAt(1).alpha = 0;
				currentSelect.getChildAt(1).visible = false;
				currentSelect.addEventListener(MouseEvent.CLICK, activateSection)
				currentSelect.addEventListener(MouseEvent.MOUSE_OVER, activateHoverSection)
				currentSelect.addEventListener(MouseEvent.MOUSE_OUT, activateHoverOutSection)
				currentSelect = null
			}
		}
		
		public function currentSelectItem(s:Sprite):void {	
			currentSelect = s;
			currentSelect.buttonMode = false;
			currentSelect.getChildAt(1).alpha = 1;
			currentSelect.getChildAt(1).visible = true;
			currentSelect.removeEventListener(MouseEvent.CLICK, activateSection)
			currentSelect.removeEventListener(MouseEvent.MOUSE_OVER, activateHoverSection)
			currentSelect.removeEventListener(MouseEvent.MOUSE_OUT, activateHoverOutSection)
			HotSpots.instance.activateNavItems(currentSelect.name)
			HotSpots.instance.removeEvents();
		}
		
		public function currentSelectItemToggle(s:Sprite):void {	
			currentSelect = s;
			currentSelect.buttonMode = false;
			currentSelect.getChildAt(1).alpha = 1;
			currentSelect.getChildAt(1).visible = true;
			currentSelect.removeEventListener(MouseEvent.CLICK, activateSection)
			currentSelect.removeEventListener(MouseEvent.MOUSE_OVER, activateHoverSection)
			currentSelect.removeEventListener(MouseEvent.MOUSE_OUT, activateHoverOutSection)

		}
		
		public function removeEvents():void {
			
				for (var i:int = 0; i < navArrs.numChildren; i++) 
				{
					
					navArrs.removeEventListener(MouseEvent.CLICK, activateSection)
					navArrs.getChildAt(i).removeEventListener(MouseEvent.MOUSE_OVER, activateHoverSection)
					navArrs.getChildAt(i).removeEventListener(MouseEvent.MOUSE_OUT, activateHoverOutSection)
				}
			
		}
		
		public function addEvents():void {
			
				for (var i:int = 0; i < navArrs.numChildren; i++) 
				{
					
					navArrs.addEventListener(MouseEvent.CLICK, activateSection)
					navArrs.addEventListener(MouseEvent.MOUSE_OVER, activateHoverSection)
					navArrs.addEventListener(MouseEvent.MOUSE_OUT, activateHoverOutSection)
				}
			
		}
		
		public function selectNavSprite(str:String) {
			
			currentSelectItemToggle(navHolder.getChildByName(str) as Sprite);
		}
		
		public function deselectNavSprite() {
			
			currentDeSelectItem()
		}
		
		//////////////////////FUNCTION TO CREATE DISPLAY OBJECTS////////////////////
		private function createTextField(t:String, c:Number = 0x383838):TextField
		{
			//trace("This is trace create text" + t)
			var format1:TextFormat = new TextFormat
			
			format1.size = 12;
			format1.letterSpacing = .5;
			format1.font = myfont1.fontName;
			//format1.color = c;
			
			//trace("Font name: " + myfont1.fontName)
			
			format1.align = TextFormatAlign.CENTER;
			
			var tf:TextField = new TextField;
			tf.text = t;
			tf.textColor = c;
			
			trace("color" + c)
			tf.setTextFormat(format1);
			//tf.border = true;
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.condenseWhite = true;
			//tf.wordWrap = true;
			//tf.multiline = true;
			tf.autoSize = TextFieldAutoSize.LEFT;	
			
			return tf;
		}
		
		private function createSquare(w:int, h:int):Sprite
		{
			var square:Sprite = new nav_round_sq;
			
			square.width = w;
			square.height = h;
			
			/*var square:Sprite = new Sprite;
			
			
			square.graphics.beginFill(0xFFFFFF);
			square.graphics.drawRoundRect(0,0,w,h,10);
			square.graphics.endFill();*/
			
			return square;
		}
		
		
	}

}