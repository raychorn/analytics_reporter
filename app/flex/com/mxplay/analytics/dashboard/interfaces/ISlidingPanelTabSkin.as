package com.mxplay.analytics.dashboard.interfaces
{
	public interface ISlidingPanelTabSkin
	{
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		function showOpen():void
		function showClosed():void
		
		function get width():Number
		function set anchor(value:String):void
		function get x():Number;
		function set x(value:Number):void;
		
	}
}