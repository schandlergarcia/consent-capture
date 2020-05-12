import { LightningElement, track } from "lwc";

import getContactPointTypeConsentTypes from "@salesforce/apex/ConsentCaptureService.getContactPointTypeConsentTypes";

export default class ConCapTypes extends LightningElement {
  // Data
  @track contactPointConsentTypes;

  // State
  @track selectedItemName;
  @track loading = true;

  // Error Handling
  @track error;

  connectedCallback() {
    getContactPointTypeConsentTypes({})
      .then(data => {
        console.log("Success!: " + JSON.stringify(data));
        this.contactPointConsentTypes = data;

        this.getInitialSelectedItemName(data[0]);
        this.endLoading();
      })
      .catch(error => {
        console.log("Error");
        this.error = error;
        this.endLoading();
      });
  }

  endLoading() {
    this.loading = false;
  }

  getInitialSelectedItemName(data) {
    let initialItem = { ...data };
    this.selectedItemName = initialItem.Name;
    let apiName = this.selectedItemName.replace(/\s/g, "");
    this.bubbleContactPointType(apiName);
  }

  handleContactPointTypeClick(event) {
    console.log(event.detail);
    let eventBody = event.detail;
    this.selectedItemName = eventBody.Name;
    let apiName = this.selectedItemName.replace(/\s/g, "");
    this.bubbleContactPointType(apiName);
  }

  bubbleContactPointType(value) {
    const contactPointType = new CustomEvent("contactpointtypeset", {
      detail: { value }
    });
    // Fire the custom event
    this.dispatchEvent(contactPointType);
  }
}
