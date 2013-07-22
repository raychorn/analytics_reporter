package com.mxplay.analytics.util
{
	import com.yahoo.maps.api.core.location.LatLon;
	import com.yahoo.maps.api.markers.Marker;
	
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

	public class CustomIconMarker extends Marker
	{
		public static const smallState:String = "small";
		public static const summaryState:String = "summary";
		public static const detailState:String = "detail";
		public var summary:String;
		public var details:String;
		public var currentState:String;
		
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
		private var summaryFormat:TextFormat;
		private var detailFormat:TextFormat;
		private var viewDetailsFormat:TextFormat;
		private var _ds:DropShadowFilter;
		private var increaseLoader:Loader;
		private var increaseHoverLoader:Loader;
		private var closeButton:Sprite;
		private var loader:Loader;
		
		public function CustomIconMarker(centerLatLon:LatLon, bgColor:uint = 0xFF0000, brdrColor:uint = 0xFFFFFF, tColor:uint = 0x000000, summaryMsg:String = "Just a small Summary", imageUrl:String = "")
		{
			super();
			// setting its position
			latlon = centerLatLon;
			
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
			currentState = CustomIconMarker.smallState;			
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
			if(currentState == CustomIconMarker.summaryState){
				increaseSprite.removeChild(increaseLoader);
				increaseSprite.addChild(increaseHoverLoader);
			}
		} 
		
		public function increaseNormal(event:MouseEvent):void{
			if(currentState == CustomIconMarker.summaryState){
				increaseSprite.removeChild(increaseHoverLoader);
				increaseSprite.addChild(increaseLoader);
			}
		}
		
		public function showSummary(event:Event):void{
			if(currentState == CustomIconMarker.smallState){
				promoteToTop(); //Bring the marker to the top of the stack
				viewDetailsFormat = new TextFormat();
				viewDetailsFormat.size = 12;
				viewDetailsFormat.color = 0xFFFFFF;
				viewDetailsFormat.bold = true;
				viewDetailsFormat.font = "Arial";
				viewDetailsFormat.underline = true;
				
				viewDetailsText = new TextField();
				viewDetailsText.text = "View Details";
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
				var h:Number = summaryText.textHeight + 30;// + _addressText.textHeight;// + _cityStZipText.textHeight + _phoneText.textHeight + _distanceText.textHeight + 10;
				if((increaseSprite.height + 10) > h){
					h = increaseSprite.height + 10;
				}         
				var radius:Number = 8;
				var padding:Number = 9;
				w = summaryText.textWidth + increaseSprite.width + 10;
				
				//Draw Marker Background Shape
				summaryMarkerShape = new Sprite();
				var tipShape:Array;
				tipShape = [[0, 0], [7, -7], [w / 2, -7], [w / 2 + radius + padding, -7, w / 2 + radius + padding, -7 -radius], [w / 2 + radius + padding, -h], [w / 2 + padding + radius, -radius-h, w / 2, -radius-h], [-w / 2 - padding , -radius-h], [-w / 2 -padding -radius, -radius-h, -w / 2 -padding -radius, -h],[-w/2 -padding -radius, -7-radius],[-w / 2 - padding -radius, -7, -w /2 - padding, -7], [-7, -7], [0,0]];
				//---------[--1--]--[--2--]--[---3-----]--[-----------4------------------------------------------------------]--[------------5---------------]--[---------------------------6-------------------------]--[---------7------------------]--[--------------------------8------------------------------------]-[-------------------9------------]-[--------------10---------------------------------]--[--11--]--[-12-]
				var len:int = tipShape.length;
				summaryMarkerShape.graphics.lineStyle(1,borderColor);
				summaryMarkerShape.graphics.beginFill(backgroundColor,1);
				for (var i:int = 0; i < len; i++) {
					if (i == 0) {
						summaryMarkerShape.graphics.moveTo(tipShape[i][0], tipShape[i][1]);
					}
					else if (tipShape[i].length == 2) {
						summaryMarkerShape.graphics.lineTo(tipShape[i][0], tipShape[i][1]);
					}
					else if (tipShape[i].length == 4) {
						summaryMarkerShape.graphics.curveTo(tipShape[i][0], tipShape[i][1], tipShape[i][2], tipShape[i][3]);
					}
				}
				summaryMarkerShape.graphics.endFill();    
				summaryMarkerShape.filters = [_ds];
				summaryMarkerShape.useHandCursor = false;
				summaryMarkerShape.addEventListener(MouseEvent.ROLL_OUT, showSmall);
		//		summaryMarkerShape.addEventListener(MouseEvent.CLICK, showDetails);
				addChild(summaryMarkerShape);
				//-------Here is where you want to edit the x/y coordinates. 
				//-------they are a more than likely going to be a little off once you add your own custom icon				
				summaryMarkerShape.x = 0;
				summaryMarkerShape.y = -25;
				summaryMarkerShape.alpha = .65;
				//summary text
				summaryText.x = Math.round(-w / 2 - padding);
				summaryText.y = Math.round(-h - padding/1.5) + 1;
				increaseSprite.x = (summaryMarkerShape.width / 2) - 25;
				increaseSprite.y = summaryText.y;
				increaseSprite.addEventListener(MouseEvent.ROLL_OVER, increaseHover);
				increaseSprite.addEventListener(MouseEvent.ROLL_OUT, increaseNormal);
				increaseSprite.addEventListener(MouseEvent.CLICK, showDetails);
				
				//Set Text Formats
				summaryText.setTextFormat(summaryFormat);
				
				//add text to shape	
				summaryMarkerShape.addChild(summaryText);
				viewDetailsText.setTextFormat(viewDetailsFormat);
				summaryMarkerShape.addChild(viewDetailsText);
				viewDetailsText.x = -80;
				viewDetailsText.y = -30;
				viewDetailsText.addEventListener(MouseEvent.CLICK, showDetails);
				summaryMarkerShape.addChild(increaseSprite);
				currentState = CustomIconMarker.summaryState;
			}
		}
		
		public function showDetails(event:MouseEvent):void{
			showSmall(event);		
			Alert.show("dispatching click event to open the individual community", "Event Type: " + event.type);
			// here is where you would dispatch your marker clicked event!
			/* var e:MarkerClickEvent = new MarkerClickEvent();
			e.dispatch();	 */
		}
		
		public function showSmall(event:MouseEvent):void{
			if((currentState != CustomIconMarker.detailState) || (event.type == MouseEvent.CLICK)){ 
				promoteToTop();
				summaryMarkerShape.visible = false;
				if(detailMarkerShape != null){
					detailMarkerShape.visible = false;
				}
				loader.visible = true;
				currentState = CustomIconMarker.smallState;
			}
		}
	}
}