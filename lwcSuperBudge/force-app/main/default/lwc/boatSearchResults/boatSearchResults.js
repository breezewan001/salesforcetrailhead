import { LightningElement,api,track, wire } from 'lwc';
import getBoats from '@salesforce/apex/BoatDataService.getBoats';
import { MessageContext, publish } from 'lightning/messageService';
import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';
// ...
const SUCCESS_TITLE = 'Success';
const MESSAGE_SHIP_IT     = 'Ship it!';
const SUCCESS_VARIANT     = 'success';
const ERROR_TITLE   = 'Error';
const ERROR_VARIANT = 'error';
export default class BoatSearchResults extends LightningElement {
  selectedBoatId;
  columns = [];

  @track boatTypeId = '';
  @track isLoading = false;
  
  // wired message context
  messageContext;
  // wired getBoats method 
  @wire(getBoats, { boatTypeId: "$boatTypeId" })
  boats;
  
  // public function that updates the existing boatTypeId property
  // uses notifyLoading
  @api searchBoats(boatTypeId) {
    console.log('cccccc');
    this.isLoading = true;
    console.log('resultboatTypeId::',boatTypeId);
    this.boatTypeId = boatTypeId;
    // this.notifyLoading(this.isLoading);
  }
  
  // this public function must refresh the boats asynchronously
  // uses notifyLoading
  refresh() { }
  
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
    const updatedFields = event.detail.draftValues;
    // Update the records via Apex
    updateBoatList({data: updatedFields})
    .then(() => {})
    .catch(error => {})
    .finally(() => {});
  }
  // Check the current value of isLoading before dispatching the doneloading or loading custom event
  notifyLoading(isLoading) { }
}
