/**
 * Created by stephan.garcia on 2019-09-03.
 */

({
    handleCaptureTypeSet : function(component, event, helper){

        console.log(event);

        var captureType = event.Co.value;

        component.set('v.captureType', (captureType.length > 0 ? captureType : null));

    }

});