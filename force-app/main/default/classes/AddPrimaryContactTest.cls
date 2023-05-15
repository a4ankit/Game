@isTest
public class AddPrimaryContactTest {
    
    @isTest
    public  static void testlogic()
    {
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<50;i++)
        {
            accList.add(new Account( Name = 'Account'+i, BillingState = 'NY'));

        }
        for(integer j=0;j<50;j++)
        {
            accList.add(new Account( Name = 'Account'+j, BillingState = 'CA'));            
        }
        insert accList;
        
        Contact c = new Contact();
        c.LastName = 'test';
        insert c;
        
        string state = 'CA';
        AddPrimaryContact updater = new AddPrimaryContact(c, state);
        Test.startTest();        
        System.enqueueJob(updater);
        Test.stopTest();
    }
}