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

package ws.tink.flex.effects
{
	
	import mx.core.UIComponent;
	import mx.effects.IEffectInstance;
	import mx.effects.TweenEffect;
	
	import ws.tink.flex.effects.effectClasses.HideTargetEffectInstance;

	public class HideTargetEffect extends TweenEffect
	{
		
		private const DEFAULT_TRANSPARENT	: Boolean = false;
		
		[Inspectable(category="General", enumeration="false,true", defaultValue="false")]
		public var transparent 				: Boolean = DEFAULT_TRANSPARENT;
		
		
		
		public function HideTargetEffect( target:UIComponent = null )
		{
			super( target );
	
			instanceClass = HideTargetEffectInstance;
		}
	
	
		override protected function initInstance( instance:IEffectInstance ):void
		{
			super.initInstance( instance );
	
			var effectInstance:HideTargetEffectInstance = HideTargetEffectInstance( instance );
			effectInstance.transparent = transparent;
		}
	}
}