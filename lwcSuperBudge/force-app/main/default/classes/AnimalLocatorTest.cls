@isTest
public  class AnimalLocatorTest {

    @isTest 
    static void testPostCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        String mouseName = AnimalLocator.getAnimalNameById(1);
        System.assertEquals(mouseName, 'chicken');
    }
}