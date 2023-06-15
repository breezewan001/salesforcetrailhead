import { LightningElement,track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

 // imports
export default class BoatSearch extends NavigationMixin(LightningElement) {
    @track isLoading = false;

    // Handles loading event
    handleLoading() { 
        this.isLoading = true;
    }
    
    // Handles done loading event
    handleDoneLoading() {
        this.isLoading = false;
    }
    
    // Handles search boat event
    // This custom event comes from the form
    searchBoats(event) {
        console.log('fromChildboatType:::', event.detail);
        if (event.detail) {
            // get boatTypeIdResult from child
            const boatTypeId = event.detail.boatTypeId;
            console.log('this.boatTypeId::', boatTypeId);
            this.template.querySelector('c-boat-search-results').searchBoats(boatTypeId);
            this.handleDoneLoading();
        }
    }
    
    createNewBoat() { 
        console.log('执行new boat create');
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                "objectApiName": "Boat__c",
                "actionName": "new"
            },
        });
    }
}