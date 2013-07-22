// ActionScript file
package com.mxplay.analytics.dashboard.events
{
import com.mxplay.analytics.dashboard.view.controls.ButtonControl;

import flash.events.Event;

import mx.rpc.events.ResultEvent;

public class DataChangeEvent extends Event
{
	public static var ADD:String = "add";
	public static var UPDATE:String = "update";
	public static var INITIATED:String = "initiated";

	public var resultEvent:ResultEvent;
	public var buttonControl:ButtonControl;
		
	public function DataChangeEvent(type:String, result:ResultEvent=null, button:ButtonControl=null)
	{
		super(type, true, true);
		this.resultEvent = result;
		this.buttonControl = button;
	}
}
}