
package com.mxplay.analytics.util
{
    import mx.controls.DateChooser;
    import mx.core.mx_internal;
    import mx.events.CalendarLayoutChangeEvent;
    import mx.events.DateChooserEvent;
    import mx.events.DragEvent;
    import mx.styles.StyleProxy;
    
    use namespace mx_internal;
    
    public class DatePeriodChooser extends DateChooser
    {
        public function DatePeriodChooser()
            {
                super();
                allowMultipleSelection = true;
            }
        
        override protected function createChildren():void
            {
                /* create our version of calendarlayout before
                 * datechooser does */
                dateGrid = new IntervalCalendarLayout();
                dateGrid.styleName = new StyleProxy(this, calendarLayoutStyleFilters);
                dateGrid.addEventListener(CalendarLayoutChangeEvent.CHANGE,
                                          dateGrid_changeHandler);
                dateGrid.addEventListener(DateChooserEvent.SCROLL,
                                          dateGrid_scrollHandler);
                
                super.createChildren(); 
                
                addChildAt(dateGrid, 2);           
                
            }
        
        private function dateGrid_changeHandler(event:CalendarLayoutChangeEvent):void
            {
                /* not being able to execute the line below means that
                 * selectedDate is  null */
                //_selectedDate = IntervalCalendarLayout(event.target).selectedDate;
                
                var e:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
                e.newDate = event.newDate;
                e.triggerEvent = event.triggerEvent;
                dispatchEvent(e);
            }
        
        private function dateGrid_scrollHandler(event:DateChooserEvent):void
            {
                invalidateDisplayList();	
                dispatchEvent(event);
            }
            
        override public function set allowMultipleSelection(value:Boolean):void
            {
                /* disable setting allowMultipleSelection to false */
                if ( value == false )
                {
                    var err:Error = new Error("DatePeriodChooser doesn't support changing allowMultipleSelction property to false");
                    throw err;
                    return;
                }
                super.allowMultipleSelection = value;
            }
        
    }
}