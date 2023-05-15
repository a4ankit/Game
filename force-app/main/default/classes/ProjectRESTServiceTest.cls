@isTest
private class ProjectRESTServiceTest {
    //Implement Apex REST service tests here
    static testMethod void testData(){
        Opportunity opp = New Opportunity(Name='Test Opp', StageName='Prospecting',CloseDate=System.today());
        insert opp;
        String ProjectRef = 'Test PRoject---22--';
        String ProjectName ='Test Proj';
        String OpportunityId = String.valueOf(opp.Id);
        Date StartDate = System.today();
        Date EndDate = System.today().addDays(7);
        Double Amount = null;
        String Status ='Running';
        Test.startTest();
        ProjectRESTService.postProjectData(ProjectRef,ProjectName,OpportunityId,StartDate,EndDate,Amount,Status);
        Opportunity opportunity = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :OpportunityId];
        System.assertNotEquals('In progress',opportunity.DeliveryInstallationStatus__c);
        Test.stopTest();
    }
}