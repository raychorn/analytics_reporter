package com.mxplay.analytics.util
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    
    public class AppXML extends EventDispatcher {
        
        public function AppXML( url:String=null ) {
            if( url ) {
                loadData(url);
            }
        }

        private var _xmlData:XML
        
        
        [Bindable(event='propertyChange')]
        public function get appXML(): XML {
            return _xmlData;
        }
        
        public function loadData( url:String ): void {
            var loader:URLLoader = new URLLoader();
            
            loader.addEventListener(Event.COMPLETE, handleLoadXMLComplete);
            loader.load(new URLRequest(url));
        }
        
        private function handleLoadXMLComplete( event:Event ): void  {
            _xmlData = XML(event.target.data);
            dispatchEvent( new Event('propertyChange') );
            dispatchEvent( new Event(Event.COMPLETE, true));
        }

    }
}