
package com.mxplay.analytics.util
{
    import flash.events.MouseEvent;
    
    import mx.controls.CalendarLayout;
    import mx.core.mx_internal;
    
    use namespace mx_internal;
    
    public class IntervalCalendarLayout extends CalendarLayout
    {
        
        private var mousePressedState:int = -1;
        private var changeRequestedByMonth:int = -1;
        private var bFirstMouseOver:Boolean = false;
        
        public function IntervalCalendarLayout()
            {
                addEventListener(MouseEvent.MOUSE_UP, mouseUp);
                addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
                addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
                addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
                super();
            }
        
        private function mouseOverHandler(event:MouseEvent):void
            {
                /* bFirstMouseOver is used to add the move handler for
                 * the first time even if relatedObject.parent is
                 * 'this'. This is a hack so that the mouse over thing
                 * works even if the mouse is inside the control on
                 * startup. If there's a better way to handle this,
                 * let me know. */
                if (event.relatedObject && (bFirstMouseOver == false || event.relatedObject.parent != this) )
                {
                    if ( bFirstMouseOver == false )
                        bFirstMouseOver = true;
                    addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
                }
                else
                    event.stopImmediatePropagation();
            }
        
        /**
	 *  @private
	 */
        private function mouseOutHandler(event:MouseEvent):void
            {
                if (event.relatedObject && event.relatedObject.parent != this)
                {
                    
                    removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
                    if ( event.buttonDown )
                    {
                        /* if mouse button is down and a mouse out
                         * happens and the last day in the month is
                         * selected, go to next month  */
                        if ( selectedRanges && selectedRanges.length > 0 )
                        {
                            var dat:Object = selectedRanges[0];
                            var thedate:Date = dat.rangeEnd;
                            if ( changeRequestedByMonth == thedate.getMonth() )
                            {
                                changeRequestedByMonth = -1;
                                stepDate(0,1);
                            }
                        }
                    }
                    
                }
                else
                {
                    event.stopImmediatePropagation();
                }
            }
        
        private function mouseUp(evt:MouseEvent):void
            {                
                if ( evt.shiftKey == false )
                {
                    /* if mouse button is down and this is not the
                     * first time this event is fired, fake holding
                     * down the shift key. */
                    if ( mousePressedState == 0 )
                        mousePressedState = 1;
                    else if ( mousePressedState == 1 )								
                        evt.shiftKey = true;				
                    
                }
            }
        
        
        /* monthNo is from 0 to 11 */
        private function getEndDateForMonth(monthNo:int, yearNo:int):Number
            {
                /* to convert date's 0 to 11 to 1 to 12 */
                monthNo = monthNo + 1;
                
                /* feb check */
                if ( monthNo == 2 )
                {
                    /* leap year check */
                    if ( yearNo % 400 == 0 || ( yearNo % 100 != 0 && yearNo % 4 == 0 ) )
                    {
                        return 29;
                    }
                    else
                        return 28;
                }
                else if ( monthNo == 4 || monthNo == 6 || monthNo == 11 || monthNo == 9 )
                {
                    return 30;
                }
                else
                    return 31;
            }
        
        private function mouseMoveHandler(event:MouseEvent):void
            {
                var evt:MouseEvent = new MouseEvent(MouseEvent.MOUSE_UP, true, false, 
                                                    event.localX, event.localY, 
                                                    event.relatedObject, event.ctrlKey, 
                                                    event.altKey, event.shiftKey, 
                                                    event.buttonDown, event.delta);
                if ( event.buttonDown )
                {
                    /* fake a MOUSE_UP event if mouse button is down and we're on a date */
                    event.target.dispatchEvent(evt);

                    /* check if we the last date in this month is also
                     * selected, in that case change state of a var so
                     * that on mouseOut, forwardMonthButton click is
                     * faked */
                    if ( selectedRanges.length > 0 )
                    {
                        var dat:Object = selectedRanges[0];
                        var thedate:Date = dat.rangeEnd;
                        
                        if ( thedate )
                        {
                            if ( thedate.date >= 28 )
                            {
                                /* check if this is the end date for this month */
                                //trace("bchange month "+ thedate.getMonth()  + " " + thedate.date );
                                if ( getEndDateForMonth( thedate.getMonth(), thedate.getFullYear() ) == thedate.date )
                                {
                                    changeRequestedByMonth = thedate.getMonth();
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        
        private function mouseDown(evt:MouseEvent):void
            {
                /* reset mousePressedState */
                mousePressedState = 0;
            }
        
    }
}