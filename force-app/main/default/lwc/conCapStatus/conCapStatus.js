import { LightningElement, track } from "lwc";

import getConsentStatusTypes from "@salesforce/apex/ConsentCaptureService.getConsentStatusTypes";

export default class ConCapStatus extends LightningElement {
  // Data
  @track statusTypes;

  // State
  @track selectedItemName;
  @track loading = true;

  // Error Handling
  @track error;

  connectedCallback() {
    getConsentStatusTypes({})
      .then(data => {
        console.log("Capture Type!: " + JSON.stringify(data));
        this.statusTypes = data;
        this.endLoading();

        this.getInitialSelectedItemName(data[0]);
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
    this.bubbleStatusType(apiName);
  }

  handleStatusTypeClick(event) {
    console.log(event.detail);
    let eventBody = event.detail;
    this.selectedItemName = eventBody.Name;
    let apiName = this.selectedItemName.replace(/\s/g, "");
    this.bubbleStatusType(apiName);
  }

  bubbleStatusType(value) {
    const statusType = new CustomEvent("statustypeset", {
      detail: { value }
    });
    // Fire the custom event
    this.dispatchEvent(statusType);
  }
}
