package com.mxplay.analytics.dashboard.events
{
	import flash.events.Event;

	public class SlidingPanelEvent extends Event
	{
		public static const ANIMATE:String = "animate";
				
		public function SlidingPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}