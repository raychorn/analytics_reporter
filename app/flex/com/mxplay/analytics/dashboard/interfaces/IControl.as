package com.mxplay.analytics.dashboard.interfaces
{
	public interface IControl
	{
		function onFaultHttpService(e:FaultEvent):void
		function onResultHttpService(e:ResultEvent):void
		
	}
}