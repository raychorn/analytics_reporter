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

package ws.tink.flex.effects.stackEffects.pairedStackEffects
{
	
	import mx.core.UIComponent;
	import mx.effects.IEffectInstance;
	
	import ws.tink.flex.effects.HideTargetEffect;
	import ws.tink.flex.effects.stackEffects.helpers.ViewStackHelper;
	import ws.tink.flex.effects.stackEffects.pairedStackEffects.effectClasses.PairedStackEffectInstance;

	public class PairedStackEffect extends HideTargetEffect
	{		
		
		private const DEFAULT_HELPER_CLASS			: Class = ViewStackHelper;
		
		[Inspectable(category="General", type="String", defaultValue="ws.tink.flex.effects.effectClasses.stackEffects.helpers.ViewStackHelper")]
		public var helper							: Class = DEFAULT_HELPER_CLASS;
		
		
		public function PairedStackEffect( target:UIComponent = null )
		{
			super( target );
	
			if( toString() == "[object PairedStackEffect]" ) throw( new Error( "PairedStackEffect is an abstract class and must be extended" ) );
			
			instanceClass = PairedStackEffectInstance;
		}
	
	
		override protected function initInstance( instance:IEffectInstance ):void
		{
			super.initInstance( instance );
	
			var effectInstance:PairedStackEffectInstance = PairedStackEffectInstance( instance );
			effectInstance.helper = helper;
		}
	}
}