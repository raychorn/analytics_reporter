// ActionScript file
package com.mxplay.analytics.dashboard.events
{
import flash.events.Event;
import com.yahoo.maps.webservices.geocoder.events.GeocoderEvent;

public class CustomGeocoderEvent extends GeocoderEvent
{		
	var _locationToFind:Address;
	public function CustomGeocoderEvent(type:String, _location:Address;)
	{
		super(type, true, true);
		this._locationToFind = location;
	}
}
}