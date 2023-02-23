import { LightningElement,wire,api, track } from 'lwc';
import getBoatsByLocation from '@salesforce/apex/BoatDataService.getBoatsByLocation';
import { getLocationService } from 'lightning/mobileCapabilities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// imports
const LABEL_YOU_ARE_HERE = 'You are here!';
const ICON_STANDARD_USER = 'standard:user';
const ERROR_TITLE = 'Error loading Boats Near Me';
const ERROR_VARIANT = 'error';
export default class BoatsNearMe extends LightningElement {
  @api boatTypeId;
  mapMarkers = [];
  isLoading = true;
  isRendered = false;
  latitude;
  longitude;
  
  // Add the wired method from the Apex Class
  // Name it getBoatsByLocation, and use latitude, longitude and boatTypeId
  // Handle the result and calls createMapMarkers
  @wire(getBoatsByLocation, {latitude: '$latitude', longitude: '$longitude', boatTypeId: '$boatTypeId'})
  wiredBoatsJSON({error, data}) { 
    console.log('wireboatsdata excute');
    if (data) {
      console.log('wireboatsdata::', data);
      this.createMapMarkers(data);
    } else if (error) {
      console.log('erorr::', error);
      const evt = new ShowToastEvent({
          title: ERROR_TITLE,
          variant: ERROR_VARIANT,
      });
      this.dispatchEvent(evt);
    }
    this.isLoading = false;
  }
  
  // Controls the isRendered property
  // Calls getLocationFromBrowser()
  renderedCallback() { 
    console.log('renderedCallback excute');
    console.log('this.isRendered::', this.isRendered);
    if (!this.isRendered) {
      this.getLocationFromBrowser();
    }
    this.isRendered = true;
  }
  
  // Gets the location from the Browser
  // position => {latitude and longitude}
  getLocationFromBrowser() { 
    console.log('excute getPosition');
    navigator.geolocation.getCurrentPosition(
      position => {
        console.log('current Position::', position);
        this.latitude = position.coords.latitude;
        this.longitude = position.coords.longitude;
        console.log('current this.latitude::', this.latitude);
        console.log('current this.longitude::', this.longitude);
      }
    );
  }
  
  // Creates the map markers
  createMapMarkers(boatData) {
    const newMarkers = JSON.parse(boatData).map(boat => {
      console.log('boat.Geolocation__Latitude__s::', boat.Geolocation__Latitude__s);
      console.log('boat.Name::', boat.Name);
      return {
        location: {
            Latitude: boat.Geolocation__Latitude__s,
            Longitude: boat.Geolocation__Longitude__s
        },
        title: boat.Name,
      };
    });
    newMarkers.unshift({
      title: LABEL_YOU_ARE_HERE,
      icon: ICON_STANDARD_USER,
      location: {
        Latitude: this.latitude,
        Longitude: this.longitude
      }
    });
    this.mapMarkers = newMarkers;
    
    console.log('this.mapMarkers::',this.mapMarkers);
  }
}