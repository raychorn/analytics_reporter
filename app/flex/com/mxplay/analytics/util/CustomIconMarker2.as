package com.mxplay.analytics.util
{
	import com.yahoo.maps.api.core.location.LatLon;
	import com.yahoo.maps.api.markers.Marker;
	import com.yahoo.maps.webservices.local.LocalSearchItem;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.controls.Alert;

	public class CustomIconMarker2 extends Marker
	{
		public static const smallState:String = "small";
		public static const summaryState:String = "summary";
		public static const detailState:String = "detail";
		public var summary:String;
		public var details:String;
		public var currentState:String;
		
		// title object
		private var _titleText:TextField;
		// address object
		private var _addressText:TextField;
		private var summaryText:TextField;
		private var detailText:TextField;
		private var viewDetailsText:TextField;
		private var backgroundColor:uint;
		private var borderColor:uint;
		private var textColor:uint;
		private var smallMarkerShape:Sprite;
		private var summaryMarkerShape:Sprite;
		private var detailMarkerShape:Sprite = new Sprite();
		private var increaseSprite:Sprite;
		// formats
		private var _titleFormat:TextFormat;
		private var _addressFormat:TextFormat;
		private var summaryFormat:TextFormat;
		private var detailFormat:TextFormat;
		private var viewDetailsFormat:TextFormat;
		private var _ds:DropShadowFilter;
		private var increaseLoader:Loader;
		private var increaseHoverLoader:Loader;
		private var closeButton:Sprite;
		private var loader:Loader;
		// local search item
		private var _localSearchItem:LocalSearchItem;
		
		public function CustomIconMarker2(centerLatLon:LatLon, localSearchItem:LocalSearchItem, bgColor:uint = 0xFF0000, brdrColor:uint = 0xFFFFFF, tColor:uint = 0x000000, summaryMsg:String = "Just a small Summary", imageUrl:String = "")
		{
			super();
			// setting its position
			latlon = centerLatLon;
			
			// setting local search item
			_localSearchItem = localSearchItem;
			
			increaseSprite = null;
			backgroundColor= bgColor;
			borderColor = brdrColor;
			textColor = tColor;
			summary = summaryMsg;
			smallMarkerShape = new Sprite();
			addChild(smallMarkerShape);
			smallMarkerShape.buttonMode = true;
			smallMarkerShape.useHandCursor = true;
			this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete, false, 0, true);
            this.loader.load(new URLRequest(imageUrl), new LoaderContext(true));
            smallMarkerShape.addChild(loader);
            smallMarkerShape.addEventListener(MouseEvent.MOUSE_OVER, showSummary);
			_ds = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);
			increaseSprite = new Sprite();
			increaseLoader = new Loader();			
			increaseHoverLoader = new Loader();
			currentState = CustomIconMarker2.smallState;			
		}
		
		/**
         * Centers the loader once its content is loaded. 
         * @param event
         * 
         */        
        private function handleLoadComplete(event:Event):void 
        {
            this.loader.x = -(loader.width/2);
            this.loader.y = -(loader.height/2);
        }

		public function increaseHover(event:Event):void {
			if(currentState == CustomIconMarker2.summaryState){
				increaseSprite.removeChild(increaseLoader);
				increaseSprite.addChild(increaseHoverLoader);
			}
		} 
		
		public function increaseNormal(event:MouseEvent):void{
			if(currentState == CustomIconMarker2.summaryState){
				increaseSprite.removeChild(increaseHoverLoader);
				increaseSprite.addChild(increaseLoader);
			}
		}
		
		public function showSummary(event:Event):void{
			if(currentState == CustomIconMarker2.smallState){
				promoteToTop(); //Bring the marker to the top of the stack
				// setting format for the title 
				_titleFormat = new TextFormat();
				_titleFormat.size = 11;
				_titleFormat.color = 0xFFFFFF;//0x7bbee3;
				_titleFormat.bold = true;
				_titleFormat.font = "Arial";
				_titleFormat.underline = true;
				
				// add title object
				_titleText = new TextField();
				_titleText.width = 1;
				_titleText.height = 1;
				_titleText.autoSize = TextFieldAutoSize.LEFT;
				_titleText.text = _localSearchItem.title;
				_titleText.setTextFormat(_titleFormat);
				
				// setting format for the address 
				_addressFormat = new TextFormat();
				_addressFormat.size = 10;
				_addressFormat.bold = false;
				_addressFormat.color = 0xdddddd; //0x000000//0xdddddd;
				_addressFormat.font = "Arial";
				
				// add address object
				_addressText = new TextField();
				_addressText.width = 0;
				_addressText.height = 0;
				_addressText.autoSize = TextFieldAutoSize.LEFT;
				// concat what we need
				_addressText.text = _localSearchItem.zip+"\n" + _localSearchItem.city + " " + 
					(_localSearchItem.state.length > 0 ? (_localSearchItem.state) : "");
				_addressText.setTextFormat(_addressFormat);
			
				viewDetailsFormat = new TextFormat();
				viewDetailsFormat.size = 11;
				viewDetailsFormat.color = 0xFFFFFF;
				viewDetailsFormat.bold = true;
				viewDetailsFormat.font = "Arial";
				viewDetailsFormat.underline = true;
				
				viewDetailsText = new TextField();
				viewDetailsText.text = "View Area Details";
				viewDetailsText.width = 1;
				viewDetailsText.height = 1;
				viewDetailsText.autoSize = TextFieldAutoSize.LEFT;
				viewDetailsText.antiAliasType = AntiAliasType.ADVANCED;
				
				summaryFormat = new TextFormat();
				summaryFormat.size = 11;
				summaryFormat.color = 0xFFFFFF;
				summaryFormat.bold = true;
				summaryFormat.font = "Arial";
				
				//Add Title Textfield
				summaryText = new TextField();
				summaryText.width = 1;
				summaryText.height = 1;
				summaryText.autoSize = TextFieldAutoSize.LEFT;
				summaryText.antiAliasType = AntiAliasType.ADVANCED;
				summaryText.text = summary;
				//summaryText.addEventListener(MouseEvent.CLICK, showDetails);
				
				increaseSprite.addChild(increaseLoader);
				//Calculate max width & height of all Textfields so we can use in dynaimic background shape calculations   
				var w:Number = Math.round(summaryText.textWidth + 20);
				var h:Number = summaryText.textHeight + _addressText.textHeight + _titleText.textHeight + 30;// + _addressText.textHeight;// + _cityStZipText.textHeight + _phoneText.textHeight + _distanceText.textHeight + 10;
				var radius:Number = 8;
				var padding:Number = 9;
				w = summaryText.textWidth + increaseSprite.width + 20;
				if(_addressText.textWidth > w)
				{
					w = _addressText.textWidth + increaseSprite.width + 20;
				}
				if(_titleText.textWidth > w)
				{
					w = _titleText.textWidth + increaseSprite.width + 20;
				}
				
				//Draw Marker Background Shape
				summaryMarkerShape = new Sprite();
				summaryMarkerShape = createBubble(w, h, padding, radius);
				summaryMarkerShape.useHandCursor = false;
				summaryMarkerShape.addEventListener(MouseEvent.ROLL_OUT, showSmall);
		//		summaryMarkerShape.addEventListener(MouseEvent.CLICK, showDetails);
				addChild(summaryMarkerShape);
				//-------Here is where you want to edit the x/y coordinates. 
				//-------they are a more than likely going to be a little off once you add your own custom icon				
				summaryMarkerShape.x = 0;
				summaryMarkerShape.y = -25;
				summaryMarkerShape.alpha = .85;
				//summary text
				summaryText.x = Math.round(-w / 2 - padding);
				summaryText.y = Math.round(-h - padding/1.5) + 45;
				//tittle text
				_titleText.x = Math.round(-w / 2 - padding);
				_titleText.y = Math.round(-h - padding/1.5) + 1;
				//address text
				_addressText.x = Math.round(-w / 2 - padding);
				_addressText.y = Math.round(-h - padding/1.5) + 17;
				increaseSprite.x = (summaryMarkerShape.width / 2) - 15;
				increaseSprite.y = summaryText.y;
				increaseSprite.addEventListener(MouseEvent.ROLL_OVER, increaseHover);
				increaseSprite.addEventListener(MouseEvent.ROLL_OUT, increaseNormal);
				increaseSprite.addEventListener(MouseEvent.CLICK, showDetails);
				
				//Set Text Formats
				summaryText.setTextFormat(summaryFormat);
				
				//add text to shape	
				summaryMarkerShape.addChild(_titleText);
				summaryMarkerShape.addChild(_addressText);
				summaryMarkerShape.addChild(summaryText);
				viewDetailsText.setTextFormat(viewDetailsFormat);
				summaryMarkerShape.addChild(viewDetailsText);
				viewDetailsText.x = w / 2 - viewDetailsText.textWidth + 5;
				viewDetailsText.y = -viewDetailsText.textHeight - padding - 3;
				viewDetailsText.addEventListener(MouseEvent.CLICK, showDetails);
				summaryMarkerShape.addChild(increaseSprite);
				currentState = CustomIconMarker2.summaryState;
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
			tmpSprite.graphics.beginFill(backgroundColor,0.6);
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
			tmpSprite.filters = [_ds];
			tmpSprite.useHandCursor = false;
			
			return tmpSprite;
		}
		
		public function showDetails(event:MouseEvent):void{
			showSmall(event);		
			Alert.show("dispatching click event to open the individual community", "Event Type: " + event.type);
			// here is where you would dispatch your marker clicked event!
			/* var e:MarkerClickEvent = new MarkerClickEvent();
			e.dispatch();	 */
		}
		
		public function showSmall(event:MouseEvent):void{
			if((currentState != CustomIconMarker2.detailState) || (event.type == MouseEvent.CLICK)){ 
				promoteToTop();
				summaryMarkerShape.visible = false;
				if(detailMarkerShape != null){
					detailMarkerShape.visible = false;
				}
				loader.visible = true;
				currentState = CustomIconMarker2.smallState;
			}
		}
	}
}