import {LightningElement, track} from 'lwc';
import getContactPointEffectiveToMax from '@salesforce/apex/ConsentCaptureService.getContactPointEffectiveToMax';

export default class ConCapEffectiveTo extends LightningElement {

    // Data
    @track maxValue;

    // State
    @track selectedValue = 1;
    @track loading = true;

    // Error Handling
    @track error;

    connectedCallback() {

        getContactPointEffectiveToMax({}).then(data => {

            this.maxValue = data;
            this.endLoading();

        }).catch(error => {

            this.error = error;
            this.endLoading();
        })

    }

    endLoading() {

        this.loading = false;

    }


    handleChange(event) {

        this.selectedValue = event.target.value;
        console.log(this.selectedValue);
        let value = this.selectedValue;
        this.bubbleCaptureType(value);

    }

    bubbleCaptureType(value) {

        const effectiveTo = new CustomEvent('effectivetoset', {
            detail: {value},
        });
        // Fire the custom event
        this.dispatchEvent(effectiveTo);


    }


}