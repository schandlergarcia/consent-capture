/**
 * Created by stephan.garcia on 2019-09-04.
 */

({
    handleIndividualSet : function(component, event, helper){

        var individualId = event.getParam('value');

        component.set('v.individualId', (individualId.length > 0 ? individualId : null));


    },

    handleSObjectSet : function(component, event, helper){

        var sObjectName = event.getParam('value');
        
        component.set('v.sObjectType', (sObjectName.length > 0 ? sObjectName : null));


    }
});