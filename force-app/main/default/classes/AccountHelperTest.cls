@isTest
public class AccountHelperTest {

    @isTest
    static void myTestMethod()
    {
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        AccountHelper.getAccounts();
        AccountHelper.saveAccount(a);
        AccountHelper.getselectOptions();
        
    }
}