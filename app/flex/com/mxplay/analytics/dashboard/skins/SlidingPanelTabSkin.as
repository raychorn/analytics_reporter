package com.mxplay.analytics.dashboard.skins
{
	import com.mxplay.analytics.dashboard.events.SlidingPanelEvent;
	
	import flash.events.MouseEvent;
	
	import com.mxplay.analytics.dashboard.interfaces.ISlidingPanelTabSkin;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.events.FlexEvent;


	public class SlidingPanelTabSkin extends Canvas implements ISlidingPanelTabSkin
	{
		private var _button:Button;
		private var _startState:String = "open";
		private var _anchor:String = "right";

		[Embed(source="../../assets/arrow_right.png")]
    	public var arrowRightImage:Class;

		[Embed(source="../../assets/arrow_left.png")]
    	public var arrowLeftImage:Class;
		
		public function SlidingPanelTabSkin()
		{
			super();
			
			this.width = 30;
			this.percentHeight = 100;
			
			this.addEventListener(FlexEvent.INITIALIZE, onInitialise);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		
		public function showOpen():void
		{
			if (_button != null)
			{
				if (_anchor == "right")
				{
					_button.setStyle("icon", arrowRightImage);
				}
				else
				{
					_button.setStyle("icon", arrowLeftImage);
				}
			}
			else
			{
				_startState = "open";
			}
		}
		
		public function showClosed():void
		{
			if (_button != null)
			{
				if (_anchor == "right")
				{
					_button.setStyle("icon", arrowLeftImage);
				}
				else
				{
					_button.setStyle("icon", arrowRightImage);
				}
			}
			else
			{
				_startState = "closed";
			}
		}

		public function set anchor(value:String):void
		{
			_anchor = value;
		}

		protected override function createChildren():void
		{
			_button = new Button();
			_button.width = 20;
			_button.height = 20;
			_button.x = 5;
			_button.y = 5;
			_button.addEventListener(MouseEvent.CLICK, onClickButton);
			
			addChild(_button);
			
			super.createChildren();
			
		}

		private function onInitialise(event:FlexEvent):void
		{
			setStyle("backgroundAlpha", 0.5);
			setStyle("backgroundColor", 0x999999);
		}

		private function onCreationComplete(event:FlexEvent):void
		{
			switch (_startState)
			{
				case "open":
					showOpen();
					break;
					
				case "closed":
					showClosed();
					break;
			}
		}

		
		private function onClickButton(event:MouseEvent):void
		{
			dispatchEvent(new SlidingPanelEvent(SlidingPanelEvent.ANIMATE));
		}
		
	}
}