import { LightningElement, api, track, wire } from "lwc";
import getSObjectType from "@salesforce/apex/IndividualUtilities.getSObjectType";
import getIndividualId from "@salesforce/apex/IndividualUtilities.getIndividualId";
import getIndividualConsent from "@salesforce/apex/ConsentCaptureService.getIndividualConsent";

export default class ConCapDisplay extends LightningElement {
  //Data
  @api recordId;
  @api individualId = {};
  @api sObjectType;
  @track relatedCPTCRecords = {};

  //State
  @track loading = true;

  /**
   * Consent Capture is used in a flow template - when navigating back to the starting screen
   * after completeing the flow - there is no action to invalidate the cache - Refresh Apex did not work
   * in this scenario - because of this, we have to call everything imparitively.
   */
  connectedCallback() {
    this.getIndividualId();
    this.getIndividualConsent();
  }

  getIndividualId() {
    getIndividualId({ recordId: this.recordId })
      .then(data => {
        this.individualId = data;
        this.bubbleIndividualId(data);
      })
      .catch(error => {
        this.error = error;
      });
  }

  getIndividualConsent() {
    getIndividualConsent({ recordId: this.recordId })
      .then(data => {
        this.relatedCPTCRecords = data;
        this.endLoading();
      })
      .catch(error => {
        this.error = error;
        this.endLoading();
      });
  }

  @wire(getSObjectType, { recordId: "$recordId" })
  getSObjectType(result) {
    if (result.error) {
      this.error = result.error;
    } else if (result.data) {
      this.sObjectType = result.data;
      this.bubbleSObjectType(result.data);
    }
  }

  endLoading() {
    this.loading = false;
  }

  /**
   * The result from the callouts is bubbled up to the Aura component container as when this was first packaged
   * we could not put LWC directly in flows.
   * @param {String} the result of the callouts
   */
  bubbleIndividualId(value) {
    console.log(JSON.stringify(value));
    const sendIndividualId = new CustomEvent("individualset", {
      detail: { value }
    });
    this.dispatchEvent(sendIndividualId);
  }

  bubbleSObjectType(value) {
    console.log(JSON.stringify(value));
    const sendSObjectType = new CustomEvent("sobjectset", {
      detail: { value }
    });
    this.dispatchEvent(sendSObjectType);
  }

  /**
   * These methods control the condition rendering of data based on data being returned.
   */

  get emptyIndividualId() {
    return this.individualId === undefined ||
      this.individualId === "No Individual"
      ? true
      : false;
  }

  get emptyConsentRecords() {
    return (
      this.relatedCPTCRecords.length === 0 &&
      (this.individualId !== "No Individual" || this.individualId !== undefined)
    );
  }

  get hydratedConsentRecords() {
    return this.relatedCPTCRecords.length >= 1;
  }
}
