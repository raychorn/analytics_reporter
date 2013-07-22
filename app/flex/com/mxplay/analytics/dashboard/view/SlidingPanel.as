/*
* Base class for a Sliding Panel.
*/

package com.mxplay.analytics.dashboard.view
{
	import com.mxplay.analytics.dashboard.events.SlidingPanelEvent;
	
	import flash.display.DisplayObject;
	
	import com.mxplay.analytics.dashboard.interfaces.ISlidingPanelTabSkin;
	
	import com.mxplay.analytics.dashboard.managers.SlidingPanelFocusManager;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.ScrollPolicy;
	import mx.effects.Move;
	import mx.effects.Parallel;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManagerContainer;
	
	import com.mxplay.analytics.dashboard.skins.SlidingPanelTabSkin;
	import mx.core.IUIComponent;
	import mx.managers.IFocusManagerComponent;
	import flash.display.InteractiveObject;


	
	public class SlidingPanel extends Canvas
	{
		public const STARTUP_OPEN:String = "open";
		public const STARTUP_CLOSED:String = "closed";

		public const ANCHOR_RIGHT:String = "right";
		public const ANCHOR_LEFT:String = "left";

		
		private var _startupState:String;
		private var _tabSkin:ISlidingPanelTabSkin;
		private var _button:Button;
		private var _open:Boolean;
		private var _anchor:String;
		private var _focusManager:SlidingPanelFocusManager;
		private var _focusItem:IFocusManagerComponent;

		public function SlidingPanel()
		{
			super();
			
			
			// Prevent the FocusManager associated with the parent from
			// tabbing around the controls in this panel.
			this.tabChildren = false;
			
			this.mouseEnabled = false;
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			
			this.addEventListener(FlexEvent.INITIALIZE, onInitialise);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			_startupState = STARTUP_OPEN;
			_open = true;
			_anchor = ANCHOR_RIGHT;
		}

		public function open():void
		{
			_focusManager.activate();
			_focusManager.setFocus(_focusManager.getNextFocusManagerComponent());
			_focusManager.showFocus();
			
			animate(true);			
		}
		
		
		public function close():void
		{
			_focusManager.deactivate();
			
			animate(false);
		}
		

		protected override function createChildren():void
		{
 			var factory:IFactory = getStyle("tabSkin");
			var child:DisplayObject;
			var childIndex:int;

 			super.createChildren();

 			if (factory == null)
 			{
 				factory = new ClassFactory(SlidingPanelTabSkin);
 			}

 			_tabSkin = factory.newInstance();

			// We should only really have two children of this panel -
			// - one child container to arrange the contents of the panel
			// - the tab skin. 
			for (childIndex = 0; childIndex < numChildren; childIndex++)
			{
				child = this.getChildAt(childIndex);
					
				child.x = (_anchor == ANCHOR_RIGHT) ? child.x + _tabSkin.width : child.x;
			
				if (child != _tabSkin)
				{
					child.width = this.width - _tabSkin.width;
				}
			}
 			
 			_tabSkin.anchor = _anchor;
 			_tabSkin.addEventListener(SlidingPanelEvent.ANIMATE, onClickTab);
 			_tabSkin.x = (_anchor == ANCHOR_RIGHT) ? 0 : this.width - _tabSkin.width;
 			
 			this.addChild(_tabSkin as DisplayObject);
 			
 		}


		
		private function onInitialise(event:FlexEvent):void
		{
			// This will depend on Anchor setting...
			if (_anchor == ANCHOR_RIGHT)
			{
				setStyle("right", 0);
			}
			else
			{
				setStyle("left", 0);
			}
			
			setStyle("top", 0);
			setStyle("backgroundAlpha", 0);
			setStyle("horizontalGap", 0);
		}

		private function onCreationComplete(event:FlexEvent):void
		{
			var child:DisplayObject;
			
			if (_startupState == STARTUP_CLOSED)
 			{
 				for (var childIndex:int = 0; childIndex < numChildren; childIndex++)
				{
					child = this.getChildAt(childIndex);
					
					if (_anchor == ANCHOR_RIGHT)
					{
						child.x += this.width - _tabSkin.width;
					}
					else
					{
						child.x -= this.width - _tabSkin.width;
					}
				}
				
				_tabSkin.showClosed();
 			}
 			else
 			{
 				_tabSkin.showOpen();
 			}			
 			
 			_focusManager = new SlidingPanelFocusManager(this);
		}

    	
		private function onClickTab(event:SlidingPanelEvent):void
		{
			if (_open)
			{
				close();
			}
			else
			{
				open();
			}
		}

    		
		private function animate(opening:Boolean):void
		{
			var parallel:Parallel = new Parallel();
			var effect:Move;
			var child:DisplayObject;
			
			parallel.addEventListener(EffectEvent.EFFECT_END, onMoveEnd);
			
			for (var childIndex:int = 0; childIndex < numChildren; childIndex++)
			{
				child = this.getChildAt(childIndex);
				
				effect = new Move();
				
				effect.target = child;
				effect.xFrom = child.x;
				
				if (_anchor == ANCHOR_RIGHT)
				{
					effect.xTo = opening ? child.x - this.width + _tabSkin.width : child.x + this.width - _tabSkin.width;
				}
				else
				{
					effect.xTo = opening ? child.x + this.width - _tabSkin.width : child.x - this.width + _tabSkin.width;
				}
				
				parallel.children.push(effect);
			}
			
			parallel.play();
		}

		private function onMoveEnd(event:EffectEvent):void
		{
			if (_open)
			{
				_open = false;
				_tabSkin.showClosed();
			}
			else
			{
				_open = true;
				_tabSkin.showOpen();
			}
		}

		
		public function set startupState(value:String):void
		{
			_startupState = value;
			_open = (_startupState == STARTUP_OPEN) ? true : false;
		}
		
		public function set anchor(value:String):void
		{
			_anchor = value;
		}
		
	}
}