package com.apps 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Gerry Yumul
	 */
	public class boxUI extends Sprite 
	{	
		private var _w:int = w
		
		public function boxUI() 
		{
			init();
		}
		
		private function init():void{
			
			
		}
		
		private function createSquare(w:int, h:int, c:Number = 0xFFFFFF, curb:Boolean, stroke:Boolean = false, strokeColor = 0x000000, ):Sprite{
			var square:Sprite = new Sprite();
			addChild(square);
			square.graphics.lineStyle(3,0x00ff00);
			square.graphics.beginFill(0x0000FF);
			square.graphics.drawRect(0,0,100,100);
			square.graphics.endFill();
			square.x = stage.stageWidth/2-square.width/2;
			square.y = stage.stageHeight / 2 - square.height / 2;
			return square;
		}
		
	}

}