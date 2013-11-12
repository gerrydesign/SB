﻿////////////////////////////////////////////
// Project: Flash 10 Coverflow
// Date: 10/3/09
// Author: Stephen Weber
////////////////////////////////////////////
package com.coverflow {
	
	////////////////////////////////////////////
	// IMPORTS
	////////////////////////////////////////////
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.Stage;

	//TweenLite - Tweening Engine - SOURCE: http://blog.greensock.com/tweenliteas3/
	import com.greensock.*;
	import com.greensock.easing.*;

	public class Scrollbar extends Sprite {
		
		////////////////////////////////////////////
		// VARIABLES
		////////////////////////////////////////////
		private var _value:int;

		private var _maxValue:int;

		private var _stage:Stage;

		private var _ratio:Number;
		
		////////////////////////////////////////////
		// CONSTRUCTOR - INITIAL ACTIONS
		////////////////////////////////////////////
		public function Scrollbar(__maxValue:Number, __stage:Stage):void {

			_maxValue=(__maxValue - 1);
			
			_ratio=((track.width) - (scrubber.width))/_maxValue;

			_stage=__stage;

			left.buttonMode=true;
			left.addEventListener(MouseEvent.CLICK, left_Click);
			
			left.addEventListener(MouseEvent.MOUSE_OVER, hover);
			left.addEventListener(MouseEvent.MOUSE_OUT, hoverOut);

			right.buttonMode=true;
			right.addEventListener(MouseEvent.CLICK, right_Click);
			right.addEventListener(MouseEvent.MOUSE_OVER, hover);
			right.addEventListener(MouseEvent.MOUSE_OUT, hoverOut);
			

			scrubber.buttonMode=true;
			scrubber.addEventListener(MouseEvent.MOUSE_DOWN, scrubber_Down);
			/*scrubber.addEventListener(MouseEvent.MOUSE_OVER, hover);
			scrubber.addEventListener(MouseEvent.MOUSE_OUT, hoverOut);*/

		}
		////////////////////////////////////////////
		// GETTERS/SETTERS
		////////////////////////////////////////////
		public function get value():int {

			return _value;

		}
		public function set value(_input:int):void {

			_value=_input;

			update();

		}
		
		////////////////////////////////////////////
		// FUNCTIONS
		////////////////////////////////////////////
		private function update():void {

			TweenLite.to(scrubber, 0.25, {x:(_value*_ratio)});

		}
		private function scrubber_Down(e:MouseEvent):void {

			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			scrubber.removeEventListener(MouseEvent.MOUSE_DOWN, scrubber_Down);
			TweenMax.to(scrubber, 0, {dropShadowFilter:{color:0x000000, alpha:1, blurX:10, blurY:10, distance:0}});
			

		}
		private function mouseMove(e:MouseEvent):void {

			var _mouseX:Number=this.mouseX;

			var _availableTrackLength:Number=track.width-scrubber.width;

			if ((_mouseX<track.width) && (0 < _mouseX)) {

				var _xPos:int = (_mouseX/_ratio);

				if (_mouseX<_availableTrackLength) {

					_value=_xPos;
					scrubber.x = _xPos * _ratio;
				
					
				} else {
					
					_value = (_maxValue);
					scrubber.x = _availableTrackLength;
				

				}

				//trace("SETTING TO VALUE: "+ _value);
				
				update();

				dispatchEvent(new Event("UPDATE"));
				
			}

		}
		private function mouseUp(e:MouseEvent):void {

			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			scrubber.addEventListener(MouseEvent.MOUSE_DOWN, scrubber_Down);
		
			TweenMax.to(scrubber, 0, {dropShadowFilter:{color:0x000000, alpha:0, blurX:10, blurY:10, distance:0, remove: true}});

		}
		private function left_Click(e:MouseEvent):void {

			if (_value!=0) {
				_value--;
			}
			update();

			dispatchEvent(new Event("PREVIOUS"));

		}
		private function right_Click(e:MouseEvent):void {

			if (_value!=(_maxValue-1)) {
				_value++;
			}
			update();

			dispatchEvent(new Event("NEXT"));

		}
		
		private function hover(e:MouseEvent):void {
			var mc:MovieClip = e.currentTarget as MovieClip
			TweenMax.to(mc, 0, {dropShadowFilter:{color:0x000000, alpha:1, blurX:20, blurY:20, distance:0}});
			
		}
		
		private function hoverOut(e:MouseEvent):void {
			var mc:MovieClip = e.currentTarget as MovieClip
			TweenMax.to(mc, 0, {dropShadowFilter:{color:0x000000, alpha:0, blurX:10, blurY:10, distance:0, remove:true}});
			
		}
	}
}