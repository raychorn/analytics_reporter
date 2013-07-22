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
	
	import mx.core.UIComponent;
	
	import ws.tink.flex.effects.stackEffects.pairedStackEffects.Squash;
	
	public class SquashInstance extends PairedStackEffectInstance
	{
		
		public var direction 				: String;
		
		private var _nextChild				: Bitmap;
		private var _previousChild			: Bitmap;
		
		
		public function SquashInstance( target:UIComponent )
		{
			super( target );
		}
		
		override protected function drawChildren():void
		{
			super.drawChildren();
			
			var childIndex:int = ( trigger == SHOW_EFFECT ) ? 1 : 0;
			_nextChild = Bitmap ( bitmaps.getChildAt( childIndex ) );
				
			if( trigger == SHOW_EFFECT )
			{
				_previousChild = Bitmap ( bitmaps.getChildAt( 0 ) );
				
				switch( direction )
				{
					case Squash.DOWN :
					{
						_nextChild.y = contentY - contentHeight;
						break;
					}
					case Squash.UP :
					{
						_nextChild.y = contentY + contentHeight;
						break;
					}
					case Squash.LEFT :
					{
						_nextChild.x = contentX + contentWidth;
						break;
					}
					case Squash.RIGHT :
					{
						_nextChild.x = contentX - contentWidth;
						break;
					}
				}
			}
		}
		
		override protected function createPropertiesToTween():void
		{
			switch( trigger )
			{
				case HIDE_EFFECT :
				case INTERRUPTING_HIDE_EFFECT :
				{
					_to = [ contentY ];
					_from = [ contentY ];
					break;
				}
				case SHOW_EFFECT :
				{
					createShowPropertiesToTween();
					break;
				}
			}
		}
		
		private function createShowPropertiesToTween():void
		{
			switch( direction )
			{
				case Squash.DOWN :
				{
					_to = [ contentY ];
					_from = [ contentY - contentHeight ];
					break;
				}
				case Squash.UP :
				{
					_to = [ contentY ];
					_from = [ contentY + contentHeight ];
					break;
				}
				case Squash.LEFT :
				{
					_to = [ contentX ];
					_from = [ contentX + contentWidth ];
					break;
				}
				case Squash.RIGHT :
				{
					_to = [ contentX ];
					_from = [ contentX - contentWidth ];
					break;
				}
			}
		} 
		
		override public function onTweenUpdate( value:Object ):void
		{
			super.onTweenUpdate( value );
			
			if( _previousChild )
			{
			
				switch( direction )
				{
					case Squash.DOWN :
					{
						_nextChild.y = value[ 0 ];
						_previousChild.height = ( contentHeight - value[ 0 ] ) - contentHeight + contentY;
						_previousChild.y = contentHeight - _previousChild.height + contentY;
						break;
					}
					case Squash.UP :
					{
						_nextChild.y = value[ 0 ];
						_previousChild.height = _nextChild.y - contentY;
						_previousChild.y = contentY;
						break;
					}
					case Squash.LEFT :
					{
						_nextChild.x = value[ 0 ];
						_previousChild.width = _nextChild.x - contentX;
						_previousChild.x = contentX;
						break;
					}
					case Squash.RIGHT :
					{
						_nextChild.x = value[ 0 ];
						_previousChild.width = ( contentWidth - value[ 0 ] ) - contentWidth + contentX;
						_previousChild.x = contentWidth - _previousChild.width + contentX;
						break;
					}
				}
			}
		}
	}
}