package com.mxplay.analytics.dashboard.view.controls
{
	import com.mxplay.analytics.dashboard.events.DataChangeEvent;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	[Event(name="add", type="com.mxplay.analytics.dashboard.events.DataChangeEvent")]
	[Event(name="initiated", type="com.mxplay.analytics.dashboard.events.DataChangeEvent")]
	
	public class ButtonControl extends Button
	{
		public var dataSource:String; //Should be pass in the constructor
		public var dataDisplayLabel:String //The label that will be used for the dataSource if present
		public var controlsId:String; //Holds the ID of the controls that are required for this datasource
		public var controlsParam:String; //Holds the Parameter Keys for each control ID=Value
		public var parameters:Object; //Holds Parameter Hash for HTTPService, obtained from Settings.controls
		
		public function ButtonControl(label:String,btnDataSource:String,controlsId:String="",controlsParam:String="",dataDisplayLabel:String="")
		{
			super();
			super.label = label;
			this.dataSource = btnDataSource;
			this.dataDisplayLabel = dataDisplayLabel;
			this.controlsId = controlsId;
			this.controlsParam = controlsParam;
			this.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		public function callDataService():void
		{
			var httpService:HTTPService = new HTTPService();
			httpService.url = Settings.SiteUrl + this.dataSource;// + "&" + e.buttonControl.controlsParam + "=" + objType.value;
			httpService.resultFormat = "e4x";
			httpService.addEventListener(FaultEvent.FAULT, onFaultHttpService);
			httpService.addEventListener(ResultEvent.RESULT, onResultHttpService);
			httpService.send(this.parameters);
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			//DISPATCH DataChangeEvent
			dispatchEvent(new DataChangeEvent(DataChangeEvent.INITIATED,null,this));
			// Load the data source.
			//Alert.show("ButtonControl Activated");
			/*var httpService:HTTPService = new HTTPService();
			httpService.url = Settings.SiteUrl + this.dataSource + "&vtt_hs_type=PC36100-ANDROID";
			httpService.resultFormat = "e4x";
			httpService.addEventListener(FaultEvent.FAULT, onFaultHttpService);
			httpService.addEventListener(ResultEvent.RESULT, onResultHttpService);
			httpService.send();*/
		}
        
        private function onFaultHttpService(e:FaultEvent):void
		{
			this.enabled = true;
			Alert.show("Unable to load datasource, " + e.message + ".");
		}
		
		private function onResultHttpService(e:ResultEvent):void	
		{
			this.enabled = true;
			dispatchEvent(new DataChangeEvent(DataChangeEvent.ADD,e,this));
			//var xml:XML = new XML(e.result);
			//super.dataProvider = xml.record;
		}

	}
}