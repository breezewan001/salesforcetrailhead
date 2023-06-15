import { api, LightningElement } from 'lwc';
import BOAT_REVIEW_OBJECT from '@salesforce/schema/BoatReview__c';
import NAME_FIELD from '@salesforce/schema/BoatReview__c.Name';
import COMMENT_FIELD from '@salesforce/schema/BoatReview__c.Comment__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const SUCCESS_TITLE = 'Review Created!';
const SUCCESS_VARIANT = 'success';
// imports
// import BOAT_REVIEW_OBJECT from schema - BoatReview__c
// import NAME_FIELD from schema - BoatReview__c.Name
// import COMMENT_FIELD from schema - BoatReview__c.Comment__c
export default class BoatAddReviewForm extends LightningElement {
    // Private
    boatId;
    rating;
    boatReviewObject = BOAT_REVIEW_OBJECT;
    nameField        = NAME_FIELD;
    commentField     = COMMENT_FIELD;
    labelSubject = 'Review Subject';
    labelRating  = 'Rating';
    
    // Public Getter and Setter to allow for logic to run on recordId change
    @api
    get recordId() { 
        return this.boatId;
    }
    set recordId(value) {
      //sets boatId attribute
      this.setAttribute('boatId', value);
      this.boatId = value;
      //sets boatId assignment
    }
    
    // Gets user rating input from stars component
    handleRatingChanged(event) {
        this.rating = event.detail.rating;
    }

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Boat__c = this.boatId;
        fields.Rating__c = this.rating;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess() {
        this.dispatchEvent(new ShowToastEvent({
            title: SUCCESS_TITLE,
            message: 'success',
            variant: SUCCESS_VARIANT
        }));
        const reviewEvent = new CustomEvent('createreview');
        this.dispatchEvent(reviewEvent);
        this.handleReset();
    }

    handleReset() {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }
}