import {LightningElement, api, track} from 'lwc';

export default class ConCapDisplayType extends LightningElement {

    @api item;
    @track showDetails = false;


    // get the icon name based on the state of the component
    get iconState(){

        return this.showDetails === true ? 'utility:chevrondown' : 'utility:chevronright';

    }

    // get the title of the icon based on the state of the component
    get iconStateTitle(){

        return this.showDetails === true ? 'Hide Details' : 'Show Details';

    }

    // get the alternative text of the icon to based on the state of the component
    get iconStateAlternativeText(){

        return this.showDetails === true ? 'Hide Details' : 'Show Details';

    }

    // Change the display state of the component to hide and show details of the component
    changeState(){


        if(this.showDetails === true){

            this.showDetails = false;

        } else {

            this.showDetails = true;

        }

    }

}