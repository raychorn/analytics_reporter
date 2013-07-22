/**
 * BlueBarPreloader.as
 */
 
package com.mxplay.analytics.preloader
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	
	public class BlueBarPreloader extends DownloadProgressBar
	{
		// Private variable to reference the Flash blueBar object
		private var bb:blueBar;
		
		// These simply hold the height/width of our bar in order to center the object,
		// no need to modify them.
		private var bbWidth:int = 396;
		private var bbHeight:int = 80;
		
		// If enabled, the bg will be a gradient
		private var useGradient:Boolean = true;
		
		// Two predefined colors - freel free to modify
		private var lightColor:uint = 0xeeeeee;
		private var darkColor:uint = 0x837462;
		
		// Constructor
		public function BlueBarPreloader()
		{
			super();						
		}
		
		// Initialize the stage and add the children
		public override function initialize():void
		{
			super.initialize();
			
			// If the useGradient boolean is true, create our BG gradient
			if(useGradient)
				createGradient();
				
			// Create and add our children (progress bar)
			createAssets();
		}		
		
		// Create the centered progress bar and add it to the stage
		private function createAssets():void
		{
			// Create a new instance of the blueBar
			bb = new blueBar();
			addChild(bb);
						
			// We don't want the MovieClip to play
			bb.stop();
			
			// Center our preloader
			bb.x = stage.stageWidth * .5 - (bbWidth/2);
			bb.y = stage.stageHeight * .5 - (bbHeight/2);
		}		
		
		// Override the 'setter' of our preloader object
		public override function set preloader(preloader:Sprite):void
		{
			preloader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			preloader.addEventListener(FlexEvent.INIT_COMPLETE, initComplete);
		}
		
		// Called every time a byte is loaded
		private function onProgress(e:ProgressEvent):void
		{
			// bytesLoaded/bytesTotal results in the percentage loaded by
			// Flex, since we have 100 frames, multiply by 100
			bb.gotoAndStop(Math.ceil(e.bytesLoaded/e.bytesTotal * 100));
		}
		
		// Done, let Flex know
		private function initComplete(e:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		// Creates a gradient from our predefined light > dark color
        protected function createGradient():void
        {    
            // Create gradient matrix Sprite and add it to canvas 
            var b:Sprite = new Sprite;
            var matrix:Matrix =  new Matrix();
            matrix.createGradientBox(stage.stageWidth, stage.stageHeight, Math.PI/2);   
            b.graphics.beginGradientFill(GradientType.LINEAR,   
                                        [lightColor, darkColor],             
                                        [1,1],                           
                                        [0,255],
                                        matrix
                                        );
            b.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            b.graphics.endFill(); 
            addChild(b);
        }		
	}
}