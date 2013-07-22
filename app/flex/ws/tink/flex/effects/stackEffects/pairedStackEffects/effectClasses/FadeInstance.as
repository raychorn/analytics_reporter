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
	
	import mx.core.UIComponent;
	
	public class FadeInstance extends PairedStackEffectInstance
	{
		
		public function FadeInstance( target:UIComponent )
		{
			super( target );
		}
		
		
		override protected function drawChildren():void
		{
			super.drawChildren();
			
			if( trigger == SHOW_EFFECT )
			{
				bitmaps.getChildAt( 1 ).alpha = 0;
			}
		}
		
		override protected function createPropertiesToTween():void
		{
			switch( trigger )
			{
				case HIDE_EFFECT :
				{
					_to = [ 1 ];
					_from = [ 1 ];
					break;
				}
				case INTERRUPTING_HIDE_EFFECT :
				{
					_to = [ 1 ];
					_from = [ 1 ];
					break;
				}
				case SHOW_EFFECT :
				{
					_to = [ 1 ];
					_from = [ 0 ];
					break;
				}
			}
		}
		
		override public function onTweenUpdate( value:Object ):void
		{
			super.onTweenUpdate( value );
			
			bitmaps.getChildAt( bitmaps.numChildren - 1 ).alpha = value[ 0 ];
		}
		
	}
}