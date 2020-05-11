({
    handleContactPointTypeSet : function(component, event, helper){

        console.log(event);

        var contactPointType = event.getParam('value');

        console.log(contactPointType);


        component.set('v.contactPointConsentType', (contactPointType.length > 0 ? contactPointType : null));

    }
});