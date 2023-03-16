@isTest
public with sharing class AccountProcessorTest {
    @testSetup
    static void setup() {
        // 各テストメソッドで使用できるテストデータを作成する
        List<Account> acList = new List<Account>();
        Account ac1 = new Account();
        ac1.name = 'ac1';
        acList.add(ac1);
        Account ac2 = new Account();
        ac2.name = 'ac2';
        acList.add(ac2);
        insert acList;

        List<Contact> conList = new List<Contact>();
        Contact con1 = new Contact();
        con1.Lastname = 'con1';
        con1.AccountId = ac1.Id;
        conList.add(con1);
        Contact con2 = new Contact();
        con2.Lastname = 'con2';
        con2.AccountId = ac2.Id;
        conList.add(con2);
        Contact con3 = new Contact();
        con3.Lastname = 'con3';
        con3.AccountId = ac2.Id;
        conList.add(con3);
        insert conList;
    }


    @IsTest
    private static void testcountContacts() {
        List<Account> accl = [select id from Account where name in ('ac1','ac2')];
        List<Id> ids = new List<Id>();
        ids.add(accl[0].Id);
        ids.add(accl[1].Id);
        Test.startTest();
        AccountProcessor.countContacts(ids);
        Test.stopTest();
        // runs callout and check results
        List<Account> acclres = [select id,Number_Of_Contacts__c from Account where name in ('ac1','ac2')];
        System.assertEquals(1, acclres[0].Number_Of_Contacts__c);
        System.assertEquals(2, acclres[1].Number_Of_Contacts__c);
    }
}