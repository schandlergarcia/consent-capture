/**
 * Created by stephan.garcia on 2019-07-09.
 */

({

    handleIndividualSet : function(component, event, helper){

        var individualId = event.Co.value;

        component.set('v.individualId', (individualId.length > 0 ? individualId : null));


    },

    handleSObjectSet : function(component, event, helper){

        var sObjectName = event.Co.value;

        component.set('v.sObjectType', (sObjectName.length > 0 ? sObjectName : null));


    }

});