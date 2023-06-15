import { api, LightningElement } from 'lwc';
const TILE_WRAPPER_SELECTED_CLASS = 'tile-wrapper selected';
const TILE_WRAPPER_UNSELECTED_CLASS = 'tile-wrapper';

// imports
export default class BoatTile extends LightningElement {
    @api boat; // get boat info from parent(searchresult)
    @api selectedBoatId; // get selected id from parent(searchresult)
    
    // Getter for dynamically setting the background image for the picture
    get backgroundStyle() {
        return 'background-image: url(' + this.boat.Picture__c + ')';
    }
    
    // Getter for dynamically setting the tile class based on whether the
    // current boat is selected
    get tileClass() {
        if (this.selectedBoatId === this.boat.Id) {
            return TILE_WRAPPER_SELECTED_CLASS;
        } else {
            return TILE_WRAPPER_UNSELECTED_CLASS;
        }
    }
    
    // Fires event with the Id of the boat that has been selected.
    selectBoat() {
        const selectedEvent = new CustomEvent('boatselect', {
            detail: {
                boatId: this.boat.Id,
            } 
        });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
}