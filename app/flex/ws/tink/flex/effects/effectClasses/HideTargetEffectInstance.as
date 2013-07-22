/*
Copyright (c) 2008 Tink Ltd | http://www.tink.ws

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

package ws.tink.flex.effects.effectClasses
{

	import flash.display.BlendMode;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.effects.effectClasses.TweenEffectInstance;

	
	public class HideTargetEffectInstance extends TweenEffectInstance
	{
		
		public var transparent 						: Boolean;
		
		protected var _to							: Array;
		protected var _from							: Array;
		
		private var _blendMode						: String;
		

		public function HideTargetEffectInstance( target:UIComponent )
		{
			super( target );
		}
		
		override public function initEffect( event:Event ):void
	    {
	    	createPropertiesToTween();
	    }
		
		override public function play():void
		{
			super.play();

			setTargetVisible( false );
		}
		
		override public function onTweenEnd( value:Object ):void
		{
			super.onTweenEnd( value );

			setTargetVisible( true );
		}
		
		override public function end():void
		{
			// Pause the animation.
			if( tween )
			{
				tween.pause();
				tween = null;
				
				setTargetVisible( true );
			}

			super.end();
		}
		
		final protected function setTargetVisible( value:Boolean ):void
		{
			if( !value ) _blendMode = target.blendMode;
			if( !_blendMode ) _blendMode = target.blendMode;
			target.blendMode = ( value ) ? _blendMode : BlendMode.ERASE;
		}
		
		protected function createPropertiesToTween():void
		{
			_to = new Array();
			_from = new Array();
		}

		
	}
}