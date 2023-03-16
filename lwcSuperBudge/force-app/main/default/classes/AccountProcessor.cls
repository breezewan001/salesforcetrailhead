public with sharing class AccountProcessor {

    @future(callout=true)
    public static void countContacts (List<Id> accountIds) {
        // The method counts the number of Contact records associated to each Account ID passed to the method and updates the 'Number_Of_Contacts__c' field with this value
        List<Account> accList = [Select id,name,Number_Of_Contacts__c from Account where id in :accountIds];
        for(Account acc : accList) {
            Integer count1 = [Select count() from Contact where AccountId = :acc.Id];
            acc.Number_Of_Contacts__c = count1;
        }
        System.debug('countResult::' + accList);
        update accList;
    }
}