package com.mxplay.analytics.dashboard.view
{
	import com.mxplay.analytics.dashboard.events.YahooMapXMLItemEvent;
	import com.mxplay.analytics.util.CustomIconMarker2;
	import com.yahoo.maps.api.core.location.Address;
	import com.yahoo.maps.api.core.location.LatLon;
	import com.yahoo.maps.api.overlays.CircleOverlay;
	import com.yahoo.maps.api.utils.Distance;
	import com.yahoo.maps.webservices.geocoder.GeocoderResult;
	import com.yahoo.maps.webservices.geocoder.events.GeocoderEvent;
	import com.yahoo.maps.webservices.local.LocalSearchItem;
	
	import flash.events.EventDispatcher;
	
	
	
	public class YahooMapXMLItemMarker extends EventDispatcher
	{
		private const CONTEXT_URL:String = Settings.SiteUrl;
		
		public var _data:XML;
		public var _location:Address;
		public var _latlon:LatLon;
		public var _circleOverlay:CircleOverlay;
		public var _yahooMarker:CustomIconMarker2;
		public var _localSearchItem:LocalSearchItem;
		public var _searchMarkersArray:Array = new Array();
		
		public function YahooMapXMLItemMarker(data:XML=null,location:Address=null)
		{
			this._data = data;
			this._location = location;
			if (location != null) {
				geocode(location);
			}
		}
		
		public function geocode(location:Address): void {
			location.addEventListener(GeocoderEvent.GEOCODER_SUCCESS, handleGeocodeSuccess);
			location.geocode();
        }
        
        private function handleGeocodeSuccess(event:GeocoderEvent):void {
        	var result:GeocoderResult = Address(event.target).geocoderResultSet.firstResult;
        	this._latlon = result.latlon;
        	createCircleOverlay();
        	//dispatchEvent( new Event(Event.COMPLETE, true));
        }
		
		private function createCircleOverlay():void {
			var radius:Number = _data.count*20;
			if (radius > 100)
				radius = 100;
			_circleOverlay = new CircleOverlay(this._latlon, Distance.milesToMeters(radius));
            _circleOverlay.fillColor = 0xFF0000;
            _circleOverlay.fillAlpha = .5;
            _circleOverlay.lineColor = 0x000080;
            _circleOverlay.lineAlpha = 0.75;
            _circleOverlay.lineThickness = 2;
            _circleOverlay.mouseEnabled = false;
            createLocalMarker();
            //dispatchEvent( new YahooMapXMLItemEvent(YahooMapXMLItemEvent.FINISHED, this));
		}
		
		private function createLocalMarker():void {
			var IconUrl:String = CONTEXT_URL + "/bin/com/mxplay/analytics/assets/wireless/grey-icon.png";
			var title:String;
            var summary:String;
            var bgColor:uint = 0x26333b;;
            
            // summary
        	summary = "Count: "+ _data.count;
        	// creating xmlItem for local search item
        	var str:String = "<listing><title>"+_data.handset+"</title><area>"+_data.area+"</area><city>"+_data.city+"</city><state>"+_data.state+"</state></listing>";
        	var xmlItem:XML = new XML(str);
            // creating a new local search item
            var myLocalSearchItem:LocalSearchItem = new LocalSearchItem(xmlItem);
            _yahooMarker = new CustomIconMarker2(_latlon, myLocalSearchItem, bgColor, 0xFFFFFF, 0x000000, summary, IconUrl);
            dispatchEvent( new YahooMapXMLItemEvent(YahooMapXMLItemEvent.FINISHED, this));
		}

	}
}