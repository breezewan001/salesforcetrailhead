@isTest
public class AddPrimaryContactTest 
{
    @isTest static void TestList()
    {
        List<Account> Teste = new List <Account>();
        for(Integer i=0;i<50;i++)
        {
            Teste.add(new Account(BillingState = 'CA', name = 'Test'+i));
        }
        for(Integer j=0;j<50;j++)
        {
            Teste.add(new Account(BillingState = 'NY', name = 'Test'+j));
        }
        insert Teste;

        Contact co = new Contact();
        co.FirstName='test';
        co.LastName ='test';
        insert co;
        String state = 'CA';
      
        AddPrimaryContact apc = new AddPrimaryContact(co, state);
        Test.startTest();
            System.enqueueJob(apc);
        Test.stopTest();
        System.assertEquals(50, [select count() from account where BillingState = 'CA']);
        System.assertEquals(50, [select count() from contact where Account.BillingState = 'CA' and LastName = 'test']);
    }
 }