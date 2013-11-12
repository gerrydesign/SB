package com
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Typewriter extends Sprite 
	/**
	 * ...
	 * @author Gerry Yumul
	 */
	{
		public var txtTimer:Timer;
		private var textArray:Array = new Array();
		private var t1:String;
		private var counter:Number = 0;
		private var textPath:Object
		private var ready:Boolean = true;
		
		public function Typewriter() 
		{
			
		}
		
		public function writeIt(_inputTxt:String, _textPath:Object, _appendInt:Number) {
			if(ready == true) {
			textPath = _textPath;
			var inputTxt:String = _inputTxt;
			var appendInt:Number = _appendInt;
			textArray = [];
			textArray.length = 0;
			t1 = inputTxt;
			textArray = t1.split("");
			counter = 0;
			textPath.text = "";
			txtTimer = new Timer(appendInt, textArray.length);
			txtTimer.addEventListener(TimerEvent.TIMER, appendText);
			txtTimer.addEventListener(TimerEvent.TIMER_COMPLETE, txtTimerStop);
			txtTimer.start();
			ready = false;
			}
		}
		
		
		private function appendText(event:TimerEvent):void {
			textPath.appendText(textArray[counter]);
			counter++;
			
			trace("Typewriter working:      " + t1)
			}
			
		public function txtTimerStop(e:TimerEvent) {
			ready = true;
			}
		
	}

}

