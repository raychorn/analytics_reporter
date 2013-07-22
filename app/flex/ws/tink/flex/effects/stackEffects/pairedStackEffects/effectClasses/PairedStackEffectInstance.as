/*
Copyright (c) 2008 Tink Ltd - http://www.tink.ws

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

package ws.tink.flex.effects.stackEffects.pairedStackEffects.effectClasses
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import mx.containers.ViewStack;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	import ws.tink.flex.effects.effectClasses.HideTargetEffectInstance;
	import ws.tink.flex.effects.stackEffects.helpers.IStackEffectHelper;

	use namespace mx_internal;
	
	public class PairedStackEffectInstance extends HideTargetEffectInstance
	{
	
		
		public const HIDE_EFFECT					: String = "hideEffect";
		public const INTERRUPTING_HIDE_EFFECT		: String = "interruptingHideEffect";
		public const SHOW_EFFECT					: String = "showEffect";

		private const NEW_CONTENT_PANE_NAME			: String = "scrollInstanceNewContentPane";
		private const HIDE_CONTENT_PANE_NAME		: String = "scrollInstanceHideContentPane";
		private const SHOW_CONTENT_PANE_NAME		: String = "scrollInstanceShowContentPane";
		
		private var _container						: ViewStack;
		
		private var _contentPane					: Sprite;
		private var _trigger						: String;
		private var _bitmaps						: Sprite;
		private var _mask							: Sprite;
		
		private var _helper							: IStackEffectHelper;


		
		public function PairedStackEffectInstance( target:UIComponent )
		{
			super( target );
			
			if( toString() == "[object PairedStackEffectInstance]" ) throw( new Error( "PairedStackEffectInstance is an abstract class and must be extended" ) );
			
			if( target.parent is ViewStack )
			{
				_container = ViewStack( target.parent );
			}
			else
			{
				throw new Error( "PairedStackEffectInstance must have a target with a parent property that is a ViewStack or extends ViewStack" );
			}
		}
		
		
		final public function set helper( Helper:Class ):void
		{
			_helper = IStackEffectHelper( new Helper( container ) );
		}
		
		override public function initEffect( event:Event ):void
	    {
	    	retrieveContainers();

			switch( _contentPane.name )
			{
				case HIDE_CONTENT_PANE_NAME :
				{
					_contentPane.name = SHOW_CONTENT_PANE_NAME;
					_trigger = SHOW_EFFECT;
					break;
				}
				case SHOW_CONTENT_PANE_NAME :
				{
					_contentPane.name = HIDE_CONTENT_PANE_NAME;
					_trigger = INTERRUPTING_HIDE_EFFECT;
					break;
				}
				case NEW_CONTENT_PANE_NAME :
				{
					_contentPane.name = HIDE_CONTENT_PANE_NAME;			
					_trigger = HIDE_EFFECT;
					break;
				}
			}
	    	
	    	super.initEffect( event );
	    }
	    
		override public function startEffect():void
		{
			drawChildren();
			
			super.startEffect();
		}
		
		override public function play():void
		{
			super.play();

			if( _trigger == SHOW_EFFECT )
			{
				tween = createTween( this, _from, _to, duration );
			}
			else
			{
				_container.callLater( onTweenEnd, [ _from ] );
			}
		}
		
		override public function onTweenEnd( value:Object ):void
		{
			super.onTweenEnd( value );

			if( _trigger == SHOW_EFFECT )
			{
				destroyBitmaps();
				
				_contentPane.removeChild( _bitmaps );
				_bitmaps = null;
				
				if( _mask )
				{
					contentPane.removeChild( _mask );
					_mask = null;
				}
				
				_container.rawChildren.removeChild( _contentPane );
				_contentPane = null;
			}
		}
		
		final protected function get trigger():String
		{
			return _trigger;
		}
		
		final protected function get container():ViewStack
		{
			return _container;
		}
		
		final protected function get contentPane():Sprite
		{
			return _contentPane;
		}
		
		final protected function get bitmaps():Sprite
		{
			return _bitmaps;
		}
		
		final protected function get selectedIndex():int
		{
			return ( _trigger == SHOW_EFFECT ) ? _container.selectedIndex : _container.getChildIndex( DisplayObject( target ) );
		}
		
		final protected function get contentX():Number
		{
			return _helper.contentX;
		}
		
		final protected function get contentY():Number
		{
			return _helper.contentY;
		}
		
		final protected function get contentWidth():Number
		{
			return _helper.contentWidth;
		}
		
		final protected function get contentHeight():Number
		{
			return _helper.contentHeight;
		}
		
		protected function drawChildren():void
		{
			var bitmapData:BitmapData;
			var bitmap:Bitmap;
			var child:Sprite;
			
			var matrix:Matrix = new Matrix();
			var bitmapDataWidth:Number;
			var bitmapDataHeight:Number;
			
			if( trigger == INTERRUPTING_HIDE_EFFECT )
			{
				child = _bitmaps;
				bitmapDataWidth = contentWidth;
				bitmapDataHeight = contentHeight;
				matrix.translate( -contentX, -contentY );
			} 
			else 
			{
				child = UIComponent( target );
				bitmapDataWidth = child.width;
				bitmapDataHeight = child.height;
			}
			
			var backgroundColor:Number = container.getStyle( "backgroundColor" );
			if( isNaN( backgroundColor ) ) backgroundColor = 0xFFFFFF;
			
			var bitmapColor:int = ( transparent ) ? 0x00000000 : backgroundColor;
			
			bitmapData = new BitmapData( bitmapDataWidth, bitmapDataHeight, transparent, bitmapColor );
			bitmapData.draw( child, matrix );
			
			bitmap = new Bitmap( bitmapData );
			bitmap.x = contentX;
			bitmap.y = contentY;
			
			bitmaps.addChild( bitmap );
			
			if( trigger == INTERRUPTING_HIDE_EFFECT )
			{
				bitmaps.removeChildAt( 0 );
				bitmaps.removeChildAt( 0 );
			}
		}
		
		protected function destroyBitmaps():void
		{
			var _bitmap:Bitmap;
			var numBitmaps:int = _bitmaps.numChildren;
			for( var i:int = 0; i < numBitmaps; i++ )
			{
				_bitmap = Bitmap( bitmaps.removeChildAt( 0 ) );
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}
		}
		
		
		private function retrieveContainers():void
		{
			_contentPane = _container.rawChildren.getChildByName( HIDE_CONTENT_PANE_NAME ) as Sprite;
			if( _contentPane ) return retrieveContainerChildren();

			_contentPane = _container.rawChildren.getChildByName( SHOW_CONTENT_PANE_NAME ) as Sprite;
			if( _contentPane ) return retrieveContainerChildren();
			
			createContainers();
		}
		
		private function retrieveContainerChildren():void
		{
			_bitmaps = Sprite( contentPane.getChildByName( "bitmaps" ) );
			
			var mask:DisplayObject = contentPane.getChildByName( "mask" );
			if( mask ) _mask = Sprite( mask );
		}
		
		private function createContainers():void
		{
			var containerContentPane:Sprite = _container.mx_internal::contentPane;
			
			_contentPane = new Sprite();
			_contentPane.name = NEW_CONTENT_PANE_NAME;
			_contentPane.x = ( containerContentPane ) ? containerContentPane.x : 0;
			_contentPane.y = ( containerContentPane ) ? containerContentPane.y : 0;
			
			if( _container.clipContent )
			{
				_mask = new Sprite();
				_mask.name = "mask";
				_mask.graphics.beginFill( 0x666666, 1 );
				_mask.graphics.drawRect( contentX, contentY, contentWidth, contentHeight );
			
				_contentPane.mask = _mask;
				
				_contentPane.addChild( _mask );
			}

			_bitmaps = new Sprite();
			_bitmaps.name = "bitmaps";

			contentPane.addChild( _bitmaps );

			_container.rawChildren.addChild( _contentPane );
		}

		
	}
}