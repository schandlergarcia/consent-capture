({
  handleDataUsePurposeIdSet: function(component, event, helper) {
    console.log(event);

    var dataUsePurposeId = event.getParam("value");

    console.log(dataUsePurposeId);

    component.set(
      "v.dataUsePurposeId",
      dataUsePurposeId.length > 0 ? dataUsePurposeId : null
    );
  },

  handleDataUsePurposeNameSet: function(component, event, helper) {
    console.log(event);

    var dataUsePurposeName = event.getParam("value");

    console.log(dataUsePurposeName);

    component.set(
      "v.dataUsePurposeName",
      dataUsePurposeName.length > 0 ? dataUsePurposeName : null
    );
  }
});
