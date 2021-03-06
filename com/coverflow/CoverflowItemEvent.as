﻿////////////////////////////////////////////
// Project: Flash 10 Coverflow
// Date: 10/3/09
// Author: Stephen Weber
////////////////////////////////////////////
package com.coverflow {	

	import flash.events.Event;
	
	public class CoverflowItemEvent extends Event{
				
		public static const COVERFLOWITEM_SELECTED:String = "coverflowitem_selected";
		
		public var data:Object;
		
		public function CoverflowItemEvent(type:String, _data:Object) {
			// You have to call the super class constructor (Event)  before doing anything else.
			super(type);
			data = _data;
		}
		
		public override function clone():Event {
			return new CoverflowItemEvent(type, this.data);
		}
		
		public override function toString():String {
			return "[ CoverflowItemEvent ]";
		}
	}
	
}