// ActionScript file
package com.mxplay.analytics.dashboard.events
{
import com.mxplay.analytics.dashboard.view.YahooMapXMLItemMarker;

import flash.events.Event;

public class YahooMapXMLItemEvent extends Event
{	
	public static const FINISHED:String = "finished";	
	
	public var _xmlItemMarker:YahooMapXMLItemMarker;
	
	public function YahooMapXMLItemEvent(type:String, xmlItem:YahooMapXMLItemMarker)
	{
		super(type, true, true);
		this._xmlItemMarker = xmlItem;
	}
}
}