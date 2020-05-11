({
    handleEffectiveToSet : function(component, event, helper){

        console.log(event);

        var effectiveMonths = event.getParam('value');

        component.set('v.effectiveMonths', (effectiveMonths.length > 0 ? effectiveMonths : null));

    }

});