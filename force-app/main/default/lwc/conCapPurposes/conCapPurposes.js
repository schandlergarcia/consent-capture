import {LightningElement, track} from 'lwc';

import getDataUseLegalBasis from '@salesforce/apex/ConsentCaptureService.getDataUseLegalBasis';
import getDataUsePurpose from '@salesforce/apex/ConsentCaptureService.getDataUsePurpose';

export default class ConCapPurposes extends LightningElement {

    // Data
    @track LegalBases;
    @track purposes;

    // State
    @track selectedLegalBasisId;
    @track totalItems;

    // State
    @track selectedItemId;
    @track selectedItemName;
    @track selectedPurposeId;
    @track selectedPurposeName;
    @track loading = true;

    // Error Handling
    @track error;

    connectedCallback(){

        getDataUseLegalBasis({}).then(data => {

            this.LegalBases = data;
            this.totalItems = data.length;

            this.getInitialSelectedItemName(data[0])

        }).catch(error => {

            this.error = error;

        })

    }

    getInitialSelectedItemName(data){

        let initialItem = {... data};
        this.selectedItemName = initialItem.Name;
        this.selectedItemId = initialItem.Id;
        this.returnDataUsePurpose(this.selectedItemId);

    }


    returnDataUsePurpose(legalBasisId){

        getDataUsePurpose({'legalBasisId' : legalBasisId}).then(data => {

            this.purposes = data;
            this.endLoading();

        }).catch(error => {

            this.error = error;
            this.endLoading();

        })

    }

    endLoading() {

        this.loading = false;

    }

    handleLegalBasisClick(event) {

        let eventBody = event.detail;
        this.selectedItemId = eventBody.Id;
        this.selectedItemName = eventBody.Name;
        this.returnDataUsePurpose(eventBody.Id);

    }

    handlePurposeClick(event) {

        let eventBody = event.detail;
        this.selectedPurposeId = eventBody.Id;
        this.selectedPurposeName = eventBody.Name;
        this.bubbleDataUsePurposeId(eventBody.Id);
        this.bubbleDataUsePurposeName(eventBody.Name);

    }

    bubbleDataUsePurposeId(value){

        console.log('Sending Id:' +  value);

        const sendDataUsePurposeId = new CustomEvent('datausepurposeidset', {
            detail: {value},
        });
        // Fire the custom event
        this.dispatchEvent(sendDataUsePurposeId);



    }

    bubbleDataUsePurposeName(value){

        console.log('Sending Name:' +  value);

        const sendDataUsePurposeName = new CustomEvent('datausepurposenameset', {
            detail: {value},
        });
        // Fire the custom event
        this.dispatchEvent(sendDataUsePurposeName);

    }

}