package 
{
	public class Settings
  	{
  		//Site Context URL
  		//Default: "http://localhost"
  		//Local: "http://localhost:3000"
  		//Public: http://198.177.231.61
  		//Private: http://10.100.162.61
    	static public var SiteUrl:String="http://localhost";
    	
    	//Project Database
    	static public var dataConnection:String="verizon";
    	
    	//Data Range Could be Daily or Monthly or Weekly
    	static public var dataRange:String="daily";
    	
    	//Type of Data Export
    	static public var exportType:String;
    	
    	//Selected First Date on DateRangeChooser
    	static public var dateSel:Date=new Date();
    	
    	//Displayed Month on DateRangeChooser
    	static public var displayedMonth:String;
    	static public var displayedMonthLabel:String;
    	
		//Labels for Month    	
    	static public var monthLabels:Array = new Array("Jan",
														"Feb",
														"Mar",
														"Apr",
														"May",
														"Jun",
														"Jul",
														"Aug",
														"Sep",
														"Oct",
														"Nov",
														"Dec");  
  	}
}