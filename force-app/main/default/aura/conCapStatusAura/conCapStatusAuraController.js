({
    handleStatusTypeSet : function(component, event, helper){

        console.log(event);

        var statusType = event.getParam('value');

        component.set('v.statusType', (statusType.length > 0 ? statusType : null));

    }
});