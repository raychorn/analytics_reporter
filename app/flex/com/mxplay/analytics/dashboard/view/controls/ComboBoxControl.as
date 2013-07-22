package com.mxplay.analytics.dashboard.view.controls
{
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ComboBoxControl extends ComboBox
	{
		public function ComboBoxControl(url:String=null, labelField:String="label", id:String=null)
		{
			super.labelField = labelField;
			if( id ) {
                super.id = id;
                VTT.debug("ComboBox ID: " + id );
            }
			if( url ) {
                loadData(url);
            }
		}
		
		public function loadData( url:String ): void {
        	//HTTP Service
			var httpService:HTTPService = new HTTPService();
			httpService.url = url;
			httpService.resultFormat = "e4x";
			httpService.addEventListener(FaultEvent.FAULT, onFaultHttpService);
			httpService.addEventListener(ResultEvent.RESULT, onResultHttpService);
			httpService.send();
        }
        
        private function onFaultHttpService(e:FaultEvent):void
		{
			Alert.show("Unable to load datasource, " + e.message + ".");
		}
		
		private function onResultHttpService(e:ResultEvent):void	
		{
			var xml:XML = new XML(e.result);
			super.dataProvider = xml.record;
		}

	}
}