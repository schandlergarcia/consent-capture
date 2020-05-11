/**
 * Created by stephan.garcia on 2019-09-03.
 */

({
    handleStatusTypeSet : function(component, event, helper){

        console.log(event);

        var statusType = event.Co.value;

        component.set('v.statusType', (statusType.length > 0 ? statusType : null));

    }

});