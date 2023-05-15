@isTest
public class AccountListControllerTest {
    
    @isTest
    public static void unitTest(){
        Account acc = new Account();
        acc.Name = 'Test';
        acc.Type = 'Installation Partner';
        acc.Website = 'www.trailhead.com';
        acc.AnnualRevenue = 500;
        acc.AccountSource = 'Web';
        acc.Industry = 'Banking';
        insert acc;
        AccountListController.fetchAccts();
        AccountListController.fetchTypeAccts('Installation Partner');
        AccountListController.fetchTypeIndustryAccts('Installation Partner', 'Banking');
        AccountListController.fetchTypeSourceAccts('Installation Partner', 'Web');
        AccountListController.saveAccount(acc.Id);
    }
}