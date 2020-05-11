/**
 * Created by stephan.garcia on 2019-09-01.
 */

({
    handleContactPointTypeSet : function(component, event, helper){

        console.log(event);

        var contactPointType = event.Co.value;

        component.set('v.contactPointType', (contactPointType.length > 0 ? contactPointType : null));

    }

});