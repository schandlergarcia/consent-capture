({
    handleCaptureTypeSet : function(component, event, helper){

        console.log(event);

        var captureType = event.getParam('value');

        component.set('v.captureType', (captureType.length > 0 ? captureType : null));

    }

});