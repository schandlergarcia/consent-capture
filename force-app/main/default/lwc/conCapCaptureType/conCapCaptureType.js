import {LightningElement, track} from 'lwc';
import getContactPointTypeCaptureTypes from '@salesforce/apex/ConsentCaptureService.getContactPointTypeCaptureTypes';

export default class ConCapCaptureType extends LightningElement {

    // Data
    @track captureTypes;

    // State
    @track selectedItemName;
    @track loading = true;

    // Error Handling
    @track error;

    connectedCallback(){

        getContactPointTypeCaptureTypes({}).then(data => {

            this.captureTypes = data;
            this.getInitialSelectedItemName(data[0]);
            this.endLoading();

        }).catch(error => {

            this.error = error;
            this.endLoading();
        })

    }

    endLoading() {

        this.loading = false;

    }

    getInitialSelectedItemName(data){

        let initialItem = {... data};
        this.selectedItemName = initialItem.Name;
        let apiName = this.selectedItemName.replace(/\s/g,'');
        this.bubbleCaptureType(apiName)

    }


    handleCaptureTypeClick(event) {

        console.log(event.detail);
        let eventBody = event.detail;
        this.selectedItemName = eventBody.Name;
        let apiName = this.selectedItemName.replace(/\s/g,'');
        this.bubbleCaptureType(apiName)

    }

    bubbleCaptureType(value){

        const captureType = new CustomEvent('capturetypeset', {
            detail: {value},
        });
        // Fire the custom event
        this.dispatchEvent(captureType);



    }

}