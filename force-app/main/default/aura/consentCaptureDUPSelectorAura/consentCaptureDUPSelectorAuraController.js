/**
 * Created by stephan.garcia on 2019-08-31.
 */

({
    handleDataUsePurposeIdSet : function(component, event, helper){

        console.log(event);

        var dataUsePurposeId = event.Co.value;

        component.set('v.dataUsePurposeId', (dataUsePurposeId.length > 0 ? dataUsePurposeId : null));


    },

    handleDataUsePurposeNameSet : function(component, event, helper){

        console.log(event);

        var dataUsePurposeName = event.Co.value;

        component.set('v.dataUsePurposeName', (dataUsePurposeName.length > 0 ? dataUsePurposeName : null));


    }

});