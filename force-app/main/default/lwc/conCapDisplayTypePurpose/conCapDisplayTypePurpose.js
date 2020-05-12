import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class ConCapDisplayTypePurpose extends NavigationMixin(
  LightningElement
) {
  @api item;

  // get the icon name based on the state of the component
  get iconState() {
    return this.item.concap__ConsentValid__c === true
      ? "utility:check"
      : "utility:close";
  }

  // get the title of the icon variant based on the state of the component
  get iconStateVariant() {
    return this.item.concap__ConsentValid__c === true ? "success" : "error";
  }

  // get the title of the icon based on the state of the component
  get iconStateTitle() {
    return this.item.concap__ConsentValid__c === true
      ? "Valid"
      : "Unsubscribed/Expired";
  }

  // get the alternative text of the icon to based on the state of the component
  get iconStateAlternativeText() {
    return this.item.concap__ConsentValid__c === true
      ? "Valid"
      : "Unsubscribed/Expired";
  }

  // get the alternative text of the icon to based on the state of the component
  get activeStyle() {
    return this.item.concap__ConsentValid__c === true
      ? ""
      : "background-color:#f4f6f9;border-bottom: 2px solid red";
  }

  viewRecord() {
    console.log("clicked");

    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.item.Id,
        objectApiName: "contactPointTypeConsent",
        actionName: "view"
      }
    });
  }
}
