package com.mxplay.analytics.dashboard.view
{
	import com.mxplay.analytics.dashboard.events.DataChangeEvent;
	import com.mxplay.analytics.dashboard.view.controls.ButtonControl;
	import com.mxplay.analytics.dashboard.view.controls.ComboBoxControl;
	
	import flash.events.MouseEvent;
	
	import mx.charts.Legend;
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.TabNavigator;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.Spacer;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	[Event(name="add", type="com.mxplay.analytics.dashboard.events.DataChangeEvent")]
	[Event(name="initiated", type="com.mxplay.analytics.dashboard.events.DataChangeEvent")]

	public class SettingsSlidingPanel extends SlidingPanel
	{
		public var properties:XML; // Properties are from pods.xml.
		public var legend:Legend = new Legend();
		public var controls:ArrayCollection = new ArrayCollection();
		
		public function SettingsSlidingPanel(prop:XML=null)
		{
			super();
			this.properties = prop;
		
			//DataChange Event Listener
			this.addEventListener(DataChangeEvent.INITIATED, dataChangeEventHandler);
			
			//Create Canvas for inside Sliding Panel
			var can:Canvas = new Canvas();
			can.percentHeight = 100;
			can.percentWidth = 100;
			can.alpha = .7;
			can.setStyle("backgroundColor", 0xFFFFFF);
			//Create TabNavigator for inside Canvas
			var tab:TabNavigator = new TabNavigator();
			tab.percentHeight = 100;
			tab.percentWidth = 100;
			
			if (properties) {
				var numSettings:Number = properties.settings.length();
				VVM.debug("Number of Setting Tags = " + numSettings.toString());
				
				var settingsArray:Array = new Array();
				for (var i:Number = 0; i < numSettings; i++)
				{
					//Create VBOX for each Settings Tag
					var settings:VBox = new VBox();
					settings.setStyle("paddingLeft",10);
					settings.setStyle("paddingTop",10);
					settings.label = properties.settings[i].@label;
					
					//Add some default Legend Attributes
					legend.toolTip = "Click to Remove";
					legend.direction="vertical";
			    	legend.percentWidth=100;
			    	legend.setStyle("verticalGap", 5);
			    	legend.setStyle("markerWidth", 10);
			    	legend.setStyle("markerHeight", 10);
					
					var numControls:Number = properties.settings[i].control.length();
					VVM.debug("Number of Control Tags = " + numControls.toString() + " For Tab: " + properties.settings[i].@label);
					//Create Controls for each Control Tag in Settings
					var controlArray:Array = new Array();
					for (var j:Number = 0; j < numControls; j++)
					{
						var control:XML = new XML(properties.settings[i].control[j]);
						if (control.@type == "label") {
							var lbl:Label = new Label();
							lbl.text = control.@label;
							controlArray[j] = lbl;
						}
						else if (control.@type == "combobox") {
							controlArray[j] = new ComboBoxControl(Settings.SiteUrl + control.@datasource, control.@labelField, control.@id);
						}
						else if (control.@type == "legend") {
							controlArray[j] = legend;
						}
						else if (control.@type == "button") {
							//Alert.show("datasource: " + control.@datasource);
							controlArray[j] = new ButtonControl(control.@label,control.@datasource,control.@controlFieldsId,control.@controlFieldsParam,control.@dataDisplayLabel);
						}
						else {
							controlArray[j] = new Spacer();
						}
						//Add Control to settings object (vbox)
						settings.addChild(controlArray[j]);
					}
					controls.addItem(controlArray);
					settingsArray.push(settings);
					tab.addChild(settings);
				}
				
				//Add Settings Tabs/VBOX to TabNavigator
				//for (var index:Number = 0; index < 1; index++)
			   	//{
			   	//	tab.addChild(settingsArray[0]);
			   	//}
			   	//tab.addChild(settingsArray[0]);
			   	//tab.addChild(settingsArray[1]);
				
				
				/*var controlArray:Array = new Array();
				controlArray[0] = new ComboBoxControl(Settings.SiteUrl + "/swaps/vvm/daily/handset_type/from_handset_type.xml","from_handset");
				controlArray[1] = new ComboBoxControl(Settings.SiteUrl + "/swaps/vvm/daily/handset_type/to_handset_type.xml","to_handset");
				var addBtn:Button = new Button();
				addBtn.label = "Add";
				addBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
				controlArray[2] = addBtn;
				
				legend.label = "Legend Settings";
				
				//Temp: Add Legend to Settings
				settingsArray[0].addChild(legend);
				//Temp: Add Controls to Settings
				settingsArray[1].addChild(controlArray[0]);
				settingsArray[1].addChild(controlArray[1]);
				settingsArray[1].addChild(controlArray[2]);
				//Add Settings Tabs/VBOX to TabNavigator
				tab.addChild(settingsArray[0]);
				tab.addChild(settingsArray[1]); */
			}
			//Add TabNavigator to Canvas
			can.addChild(tab);
			//Add Canvas to SlidingPanel
			this.addChild(can);
			//VTT.debug("Original Canvas: " + can.name);
		}
		
		public function returnControlObject(id:String):Object {
			var myObject:Object= new Object();
			VTT.debug("Settings Controls: ");
			for each (var controlArray:Object in this.controls) {
				//for each (var controlItem:Object in controlArray) {
				for (var i:int = 0; i < controlArray.length; i++) {
					var controlItem:Object = controlArray[i];
					if (controlItem.id == id) {
						if (controlItem is Label) {
							myObject.value= Label(controlItem).text;
							myObject.type= "Label";
							VTT.debug("\t\t[Label] Value: " + myObject.value);
						}
						if (controlItem is ComboBoxControl) {
							myObject.value= ComboBoxControl(controlItem).selectedLabel;
							myObject.type= "ComboBoxControl";
							VTT.debug("\t\t[Combo] Value: " + myObject.value);
						}
					}
				}
			}
			return myObject;
		}
		
		public function dataChangeEventHandler(e:DataChangeEvent):void {
			//Alert.show("DataTestHandler Active");
			//Alert.show(e.buttonControl.label.toString());
			VTT.debug("Settings DataChangeEvent: ");
			VTT.debug("\t\tButton Name: " + e.buttonControl.name.toString());// + " ID: " + e.buttonControl.id.toString());
			VTT.debug("\t\tButton Label: " + e.buttonControl.label.toString());
			VTT.debug("\t\tButton Controls: " + e.buttonControl.controlsId);
			VTT.debug("\t\tButton Controls Params: " + e.buttonControl.controlsParam);
			
			e.buttonControl.enabled = false;
			
			var objType:Object = returnControlObject(e.buttonControl.controlsId);
			VTT.debug("VALUE OF OBJECT: " + objType.value );
			
			//This should be the last thing as this sends out the data call
			if (e.buttonControl.dataSource && e.buttonControl.dataSource != "") {
				// Load the data source.
				
				// Create Parameters
				var params:Object = {};
				params[e.buttonControl.controlsParam] = objType.value;
				
				// Parse Display Label (replace marks with values) 
				if (e.buttonControl.dataDisplayLabel && e.buttonControl.dataDisplayLabel != "") {
					e.buttonControl.dataDisplayLabel = params["vtt_hs_type"];
				}
				e.buttonControl.parameters = params
				e.buttonControl.callDataService();
				/*var httpService:HTTPService = new HTTPService();
				httpService.url = Settings.SiteUrl + e.buttonControl.dataSource;// + "&" + e.buttonControl.controlsParam + "=" + objType.value;
				httpService.resultFormat = "e4x";
				httpService.addEventListener(FaultEvent.FAULT, onFaultHttpService);
				httpService.addEventListener(ResultEvent.RESULT, onResultHttpService);
				httpService.send(params);*/
			}
		}
		
		//NOTE: Replaced with onButtonClick from BottonCotrol
		private function onMouseClick(e:MouseEvent):void {
			// Load the data source.
			Alert.show("SettingsSlidingPanel Activated");
			var httpService:HTTPService = new HTTPService();
			httpService.url = Settings.SiteUrl + "/swaps/vvm/daily/handset_type/to_handset_type.xml","to_handset";
			httpService.resultFormat = "e4x";
			httpService.addEventListener(FaultEvent.FAULT, onFaultHttpService);
			httpService.addEventListener(ResultEvent.RESULT, onResultHttpService);
			httpService.send();
			
		}
		
		private function onFaultHttpService(e:FaultEvent):void
		{
			Alert.show("Unable to load datasource, " + e.message + ".");
		}
		
		// abstract.
		protected function onResultHttpService(e:ResultEvent):void	{
			dispatchEvent(new DataChangeEvent(DataChangeEvent.ADD,e));
		}

	}
}