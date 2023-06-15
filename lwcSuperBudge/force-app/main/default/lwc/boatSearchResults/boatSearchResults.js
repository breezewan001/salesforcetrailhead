import { LightningElement,api,track, wire } from 'lwc';
import getBoats from '@salesforce/apex/BoatDataService.getBoats';
import updateBoatList from '@salesforce/apex/BoatDataService.updateBoatList';
import { MessageContext, publish } from 'lightning/messageService';
import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
// ...
const SUCCESS_TITLE = 'Success';
const MESSAGE_SHIP_IT     = 'Ship it!';
const SUCCESS_VARIANT     = 'success';
const ERROR_TITLE   = 'Error';
const ERROR_VARIANT = 'error';

export default class BoatSearchResults extends LightningElement {
  selectedBoatId;
  columns = [
    { label: 'Name', fieldName: 'Name',editable: true },
    { label: 'Length', fieldName: 'Length__c', type: 'text',editable: true },
    { label: 'Price', fieldName: 'Price__c', type: 'text',editable: true },
    { label: 'Description', fieldName: 'Description__c', type: 'text',editable: true },
  ];

  @track boatTypeId = '';
  @track isLoading = false;
  @track draftValues = [];
  boats;
  
  // wired message context
  @wire(MessageContext)
  messageContext;
  
  // wired getBoats method 
  @wire(getBoats, {boatTypeId: '$boatTypeId'})
  wiredBoats({error, data}) {
    if (data) {
        this.boats = data;
    } else if (error) {
      const evt = new ShowToastEvent({
          title: ERROR_TITLE,
          variant: ERROR_VARIANT,
      });
      this.dispatchEvent(evt);
    }
  }
  
  // public function that updates the existing boatTypeId property
  // uses notifyLoading
  @api searchBoats(boatTypeId) {
    console.log('cccccc');
    this.isLoading = true;
    console.log('resultboatTypeId::',boatTypeId);
    this.boatTypeId = boatTypeId;
    this.notifyLoading(this.isLoading);
  }
  
  // this public function must refresh the boats asynchronously
  // uses notifyLoading
  @api async refresh() {
    this.notifyLoading(true);
    refreshApex(this.boats);
    this.notifyLoading(false);
  }
  
  // this function must update selectedBoatId and call sendMessageService
  updateSelectedTile(event) {
    console.log('event.detail::',event.detail);
    this.selectedBoatId = event.detail.boatId;
    console.log('this.selectedBoatId::',this.selectedBoatId);
    this.sendMessageService(this.selectedBoatId);
  }
  
  // Publishes the selected boat Id on the BoatMC.
  sendMessageService(boatId) { 
    // explicitly pass boatId to the parameter recordId
    const message = {
      recordId: boatId
    };
    publish(this.messageContext, BOATMC, message);
  }
  
  // The handleSave method must save the changes in the Boat Editor
  // passing the updated fields from draftValues to the 
  // Apex method updateBoatList(Object data).
  // Show a toast message with the title
  // clear lightning-datatable draft values
  handleSave(event) {
    // notify loading
    let updatedFields = event.detail.draftValues;
    console.log('updatedFields::', updatedFields);
    // Update the records via Apex
    updateBoatList({data: updatedFields})
    .then(() => {
      console.log('success');
      this.dispatchEvent(
        new ShowToastEvent({
            title: SUCCESS_TITLE,
            message: MESSAGE_SHIP_IT,
            variant: SUCCESS_VARIANT
        })
      );
      // Display fresh data in the form
      this.draftValues = [];
      return this.refresh();
    })
    .catch(error => {
      console.log('error::',error);
      this.dispatchEvent(
        new ShowToastEvent({
            title: ERROR_TITLE,
            message: error.body.message,
            variant: ERROR_VARIANT
        })
      );
    })
    .finally(() => {
      updatedFields = [];
    });
  }
  // Check the current value of isLoading before dispatching the doneloading or loading custom event
  notifyLoading(isLoading) {
    if (!isLoading) {
        this.dispatchEvent(new CustomEvent('loading'));
    }
    this.dispatchEvent(CustomEvent('doneloading'));
  }
}