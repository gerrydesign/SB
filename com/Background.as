package  
{
	import flash.display.Sprite;
	import com.greensock.easing.*;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.greensock.events.LoaderEvent;
	
	/**
	 * ...
	 * @author Gerry Yumul
	 */
	public class Background extends Sprite 
	{
		
		public function Background() 
		{
			var xml:XMLLoader = new XMLLoader("xml/config.xml", {name:"xmlDoc", onComplete:completeHandler});
		}
		
		private function completeHandler(e:LoaderEvent):void {
			trace(e.target);
		}
		
	}

}