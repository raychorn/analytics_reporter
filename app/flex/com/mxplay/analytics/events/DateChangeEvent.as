// ActionScript file
package com.mxplay.analytics.events {
	import flash.events.Event;
	
	public class DateChangeEvent extends Event {
		public static const DATECHANGE:String = "datechange";
		
		public var startdate:Date;
		public var enddate:Date;
		
		public function DateChangeEvent(startdate:Date, enddate:Date) {
			super(DATECHANGE, true);
			this.startdate = startdate;
			this.enddate = enddate;
		}
	}
}