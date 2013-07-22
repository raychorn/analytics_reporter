package com.mxplay.analytics.util
{
	import com.yahoo.maps.api.core.location.LatLon;
	import com.yahoo.maps.api.markers.Marker;
	import com.yahoo.maps.webservices.local.LocalSearchItem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class CustomMarker extends Marker
	{
		// background color of the marker
		private var _markerColor:uint;
		// drop shadow filter
		private var _dropShadow:DropShadowFilter;
		// title object
		private var _titleText:TextField;
		// address object
		private var _addressText:TextField;
		// website text object
		private var _urlText:TextField;
		// web site address
		private var _web:String;
		// formats
		private var _titleFormat:TextFormat;
		private var _addressFormat:TextFormat;
		private var _urlFormat:TextFormat;
		// marker shape
		private var _customBigMarkerShape:Sprite;
		// local search item
		private var _localSearchItem:LocalSearchItem;
		
		// constructor
		public function CustomMarker(color:uint, centerLatLon:LatLon, 
			localSearchItem:LocalSearchItem, web:String = null)
		{
			super();
			// setting its position
			latlon = centerLatLon;
			// setting color
			_markerColor = color;
			// setting local search item
			_localSearchItem = localSearchItem;
			// setting web site address
			_web = web;
			// creating drop shadow filter
			_dropShadow = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);
			
			// setting format for the title 
			_titleFormat = new TextFormat();
			_titleFormat.size = 11;
			_titleFormat.color = 0x7bbee3;
			_titleFormat.bold = true;
			_titleFormat.font = "Arial";
			
			// setting format for the address 
			_addressFormat = new TextFormat();
			_addressFormat.size = 10;
			_addressFormat.bold = false;
			_addressFormat.color = 0xdddddd;
			_addressFormat.font = "Arial";
			
			// setting format for the website 
			_urlFormat = new TextFormat();
			_urlFormat.size = 11;
			_urlFormat.color = 0x7bbee3;
			_urlFormat.font = "Arial";
			
			// add title object
			_titleText = new TextField();
			_titleText.width = 1;
			_titleText.height = 1;
			_titleText.autoSize = TextFieldAutoSize.LEFT;
			_titleText.text = _localSearchItem.title;
			_titleText.setTextFormat(_titleFormat);
			
			// add address object
			_addressText = new TextField();
			_addressText.width = 0;
			_addressText.height = 0;
			_addressText.autoSize = TextFieldAutoSize.LEFT;
			// concat what we need
			_addressText.text = _localSearchItem.addr+"\n" + _localSearchItem.city + 
				(_localSearchItem.state.length > 0 ? (", judetul " + _localSearchItem.state) : "");
			_addressText.setTextFormat(_addressFormat);
			
			// calculate max widths & heights
			var widthW:Number = Math.round(_titleText.textWidth + 20);
			var heightH:Number = _titleText.textHeight + _addressText.textHeight;
			var radius:Number = 8;
			var padding:Number = 8;
			if(_addressText.textWidth > _titleText.textWidth)
			{
				widthW = _addressText.textWidth;
			}
			
			// add website object if it is specified
			if(_web && _web.length > 0)
			{
				_urlText = new TextField();
				_urlText.htmlText = "<A HREF='event:" + _web + "' target='_blank'>website</A>";
				_urlText.x = widthW / 2 - _urlText.textWidth + 5;
				_urlText.y = -_urlText.textHeight - padding - 3;
				_urlText.setTextFormat(_urlFormat);
				_urlText.addEventListener(TextEvent.LINK, goToMarkerURL);
				_urlText.addEventListener(MouseEvent.MOUSE_OVER, handleLinkOver);
				_urlText.addEventListener(MouseEvent.MOUSE_OUT, handleLinkOut);
				heightH += Math.round(_urlText.textHeight);
			} else {
				heightH += 7;
			}
		
			// setting position based on the above calculations
			_titleText.x = Math.round(-widthW / 2 - padding);
			_titleText.y = Math.round(-heightH - padding / 1.5);
			_addressText.x = _titleText.x;
			_addressText.y = _titleText.y + _titleText.textHeight;
			
			// draw custom marker shape
			_customBigMarkerShape = new Sprite();
			// create the bubble
			_customBigMarkerShape = createBubble(widthW, heightH, padding, radius);
			// add bubble object
			addChild(_customBigMarkerShape);
			
			// add object
			_customBigMarkerShape.addChild(_titleText);
			_customBigMarkerShape.addChild(_addressText);
			if(_web && _web.length > 0){
				_customBigMarkerShape.addChild(_urlText);
			}
		}
		
		// method to create the bubble object
		private function createBubble(w:uint = 20, 
			h:uint = 20, padding:uint = 1, radius:uint = 4):Sprite
		{
			var tmpSprite:Sprite = new Sprite();
			// shape coords
			var tipShape:Array;
			tipShape = [
				[0, 0], 
				[7, -7], 
				[w / 2, -7], 
				[w / 2 + radius + padding, -7, 
					w / 2 + radius + padding, -7 - radius], 
				[w / 2 + radius + padding, -h], 
				[w / 2 + padding + radius, 
					-radius-h, w / 2, -radius-h], 
				[-w / 2 - padding , -radius-h], 
				[-w / 2 -padding -radius, -radius-h, 
					-w / 2 -padding -radius, -h],
				[-w/2 -padding -radius, -7-radius],
				[-w / 2 - padding -radius, -7, -w /2 - padding, -7], 
				[-7, -7], 
				[0,0]];
			// setting line style
			tmpSprite.graphics.lineStyle(2,0xFFFFFF);
			// setting fill
			tmpSprite.graphics.beginFill(_markerColor,0.6);
			// drawing the shape
			var len:uint = tipShape.length;
			for (var i:int = 0; i < len; i++) 
			{
				if (i == 0) 
				{
					// if is the first entry we move to that point
					tmpSprite.graphics.moveTo(tipShape[i][0], tipShape[i][1]);
				}
				else if (tipShape[i].length == 2) 
				{
					// if there are 2 coords for this entry we draw a line
					tmpSprite.graphics.lineTo(tipShape[i][0], tipShape[i][1]);
				}
				else if (tipShape[i].length == 4) 
				{
					// if there are 4 coords we draw a curve
					tmpSprite.graphics.curveTo(tipShape[i][0], 
						tipShape[i][1], tipShape[i][2], tipShape[i][3]);
				}
			}
			tmpSprite.graphics.endFill();
			// setting drop shadow filter 
			tmpSprite.filters = [_dropShadow];
			tmpSprite.useHandCursor = false;
			
			return tmpSprite;
		}
		
		// mouse over for website link
		private function handleLinkOver(event:MouseEvent):void
		{
			_urlFormat.underline = true;
			_urlText.setTextFormat(_urlFormat);
		}
		
		// mouse out for website link
		private function handleLinkOut(event:MouseEvent):void
		{
			_urlFormat.underline = false;
			_urlText.setTextFormat(_urlFormat);
		}
		
		// go to the website link
		private function goToMarkerURL(event:TextEvent):void
		{
			var urlRequest:URLRequest = new URLRequest(event.text);
			navigateToURL(urlRequest, "_blank");
		}
		
	}
}
