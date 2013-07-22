/*
* Base class for pod content.
*/

package com.mxplay.analytics.dashboard.view
{
import mx.charts.Legend;
import mx.collections.ArrayCollection;
import mx.containers.Canvas;
import mx.containers.TabNavigator;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.utils.ObjectProxy;

public class PodContentBase extends VBox
{
	[Bindable]
	public var properties:XML; // Properties are from pods.xml.
	public var settingsPanel:SettingsSlidingPanel;
	//ifong
	private var gComboBox_1:ComboBox;
	private var gComboBox_2:ComboBox;
	
	function PodContentBase()
	{
		super();
		percentWidth = 100;
		percentHeight = 100;
		addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
	}
	
	private function onCreationComplete(e:FlexEvent):void
	{
		//Alert.show(Settings.SiteUrl + properties.@dataSource);
		//Alert.show(properties.settings.length());
		//Alert.show(properties.settings[0].control.@type);
		
		// Load the data source.
		var httpService:HTTPService = new HTTPService();
		httpService.url = Settings.SiteUrl + properties.@dataSource;
		httpService.resultFormat = "e4x";
		httpService.addEventListener(FaultEvent.FAULT, onFaultHttpService);
		httpService.addEventListener(ResultEvent.RESULT, onResultHttpService);
		httpService.send();
		
		//Alert.show(properties.settings.length());
		VVM.debug("Settings XML\n"+ properties.settings);
		//SettingsSlidingPanel
		settingsPanel = new SettingsSlidingPanel(properties);
		settingsPanel.percentHeight = 100;
		settingsPanel.width = 340;
		settingsPanel.startupState = "closed";
		settingsPanel.anchor = "right";
		
	}
	
	protected function onDatasource_custom(comboBox:ComboBox):void
	{
		var httpService:HTTPService = new HTTPService();
		if(comboBox.id=="comboBox_from") {
			httpService.url = Settings.SiteUrl + properties.@dataSource_from;
			gComboBox_1 = comboBox;
		}
		if (comboBox.id=="comboBox_to") {
			httpService.url = Settings.SiteUrl + properties.@dataSource_to;
			gComboBox_2 = comboBox;
		}
		httpService.resultFormat = "e4x";
		httpService.addEventListener(FaultEvent.FAULT, onFaultHttpService);
		if(comboBox.id=="comboBox_from") {
			httpService.addEventListener(ResultEvent.RESULT, onResultHttpServiceFrom);
		}
		if (comboBox.id=="comboBox_to") {
			httpService.addEventListener(ResultEvent.RESULT, onResultHttpServiceTo);
		}
		httpService.send();
	}
	
	protected function onDateChange(startDate:Date, endDate:Date):void
	{
		//Format Date
		var start:String = DateField.dateToString(startDate, "YYYY-MM-DD");
		var end:String = DateField.dateToString(endDate, "YYYY-MM-DD");
		// Load the data source.
		var httpService:HTTPService = new HTTPService();
		httpService.url = Settings.SiteUrl + properties.@dataSource + "&startdate=" + start + "&enddate=" + end;
		httpService.resultFormat = "e4x";
		httpService.addEventListener(FaultEvent.FAULT, onFaultHttpService);
		httpService.addEventListener(ResultEvent.RESULT, onResultHttpService);
		httpService.send();
		//Alert.show(Settings.SiteUrl + properties.@dataSource + "&startdate=" + start + "&enddate=" + end);
		VTT.debug(Settings.SiteUrl + properties.@dataSource + "&startdate=" + start + "&enddate=" + end);
	}
	
	//Abstract
	//protected function onDataChange(e:ResultEvent):void	{}
	protected function onDataChange(from_handset:String, to_handset:String):void
	{
		// Load the data source.
		var httpService:HTTPService = new HTTPService();
		httpService.url = Settings.SiteUrl + properties.@dataSource + "&from_handset=" + from_handset + "&to_handset=" + to_handset;
		//Alert.show("NEW URL" + httpService.url.toString());
		httpService.resultFormat = "e4x";
		httpService.addEventListener(FaultEvent.FAULT, onFaultHttpService);
		//httpService.addEventListener(ResultEvent.RESULT, onResultHttpService);
		httpService.addEventListener(ResultEvent.RESULT, parseXMLData);
		httpService.send();
	}
	
	// ifong
	protected function parseXMLData(e:ResultEvent):void	{}
	// ----------------------------------------------------------------------------------
	
	
	protected function onFaultHttpService(e:FaultEvent):void
	{
		Alert.show("Unable to load datasource, " + Settings.SiteUrl + properties.@dataSource + ".");
	}
	
	// abstract.
	protected function onResultHttpService(e:ResultEvent):void	{}
	protected function onResultHttpServiceFrom(e:ResultEvent):void
	{
		var a:Array = xmlListToObjectArray(e.result.record);
		var data_1:ArrayCollection = new ArrayCollection(a);

		if(gComboBox_1.id=="comboBox_from") {
			//Alert.show("===>Get in comboBox_from beginning"); 
			gComboBox_1.dataProvider = data_1;
       		gComboBox_1.labelField = "from_handset";
       	} 
	}
	
	protected function onResultHttpServiceTo(e:ResultEvent):void
	{
		var a:Array = xmlListToObjectArray(e.result.record);
		var data_2:ArrayCollection = new ArrayCollection(a);

		if(gComboBox_2.id=="comboBox_to") {
			//Alert.show("===>Get in comboBox_from beginning"); 
	   		gComboBox_2.dataProvider = data_2;
       		gComboBox_2.labelField = "to_handset";
       		gComboBox_2.selectedIndex = 3;
    	} 
	}
	//Note: Replaced by SettingsSlidingPanel.as
	//Settings Panel is generated based on pods.xml <settings>
	//One <settings> tag represents one settings tab window
	protected function createSettingsPanel():SlidingPanel
	{
		//Create Sliding Panel
		var sp:SlidingPanel = new SlidingPanel();
		sp.percentHeight = 100;
		sp.width = 340;
		sp.startupState = "closed";
		sp.anchor = "right";
		//Create Canvas for inside Sliding Panel
		var can:Canvas = new Canvas();
		can.percentHeight = 100;
		can.percentWidth = 100;
		can.alpha = .5;
		can.setStyle("backgroundColor", 0xFFFFFF);
		//Create TabNavigator for inside Canvas
		var tab:TabNavigator = new TabNavigator();
		tab.percentHeight = 100;
		tab.percentWidth = 100;
		//Create VBOX for each Settings Tag
		var settings:VBox = new VBox();
		settings.setStyle("paddingLeft",10);
		settings.setStyle("paddingTop",10);
		settings.label = "Legend";
		
		//Create tmp Manual Legend
		var legend:Legend = new Legend();
		legend.direction = "vertical";
		legend.id = "settingsLeggend";
		//legend.dataProvider = columnChart;
		
		
		
		//Temp: Add Legend to Settings
		settings.addChild(legend);
		//Add Settings Tabs/VBOX to TabNavigator
		tab.addChild(settings);
		//Add TabNavigator to Canvas
		can.addChild(tab);
		//Add Canvas to SlidingPanel
		sp.addChild(can);
		return sp;
	}
			
	// Converts XML nodes in an XMLList to an Array.
	protected function xmlListToObjectArray(xmlList:XMLList):Array
	{
		var a:Array = new Array();
		for each(var xml:XML in xmlList)
		{
			var nodes:XMLList = xml.children();
			var o:Object = new Object();
			for each (var node:XML in nodes)
			{
				var nodeName:String = node.name().toString();
				var value:*;
				value = node.toString();
				o[nodeName] = value;
			}
			
			a.push(new ObjectProxy(o));
		}
		
		return a;
	}
	// Converts XML attributes in an XMLList to an Array.
	protected function xmlListAttributeToObjectArray(xmlList:XMLList):Array
	{
		var a:Array = new Array();
		for each(var xml:XML in xmlList)
		{
			var attributes:XMLList = xml.attributes();
			var o:Object = new Object();
			for each (var attribute:XML in attributes)
			{
				var nodeName:String = attribute.name().toString();
				var value:*;
				if (nodeName == "date")
				{
					var date:Date = new Date();
					date.setTime(Number(attribute.toString()));
					value = date;
				}
				else
				{
					value = attribute.toString();
				}
					
				o[nodeName] = value;
			}
			
			a.push(new ObjectProxy(o));
		}
		
		return a;
	}
	
	// Dispatches an event when the ViewStack index changes, which triggers a state save.
	// ViewStacks are only in ChartContent and FormContent.
	protected function dispatchViewStackChange(newIndex:Number):void
	{
		dispatchEvent(new IndexChangedEvent(IndexChangedEvent.CHANGE, true, false, null, -1, newIndex));
	}
}
}