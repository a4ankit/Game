public class BillingCalloutService {

    public static final String BIlLING_SERVICE_CREDENTIALS = 'BillingServiceCredential';
    private static final ServiceCredentials__c CREDENTIALS = ServiceCredentials__c.getinstance(BIlLING_SERVICE_CREDENTIALS);
    @future(callout=true)
    public static void callBillingService(String projectId) {
        system.debug('projectId=='+projectId);
        List<Project__c> projects = [
                SELECT Id, ProjectRef__c, Billable_Amount__c
                FROM Project__c
                WHERE Id =: projectId LIMIT 1];

        if (projects.isEmpty() || projects[0].ProjectRef__c == null || projects[0].Billable_Amount__c == null)
            return;

        Project__c project = projects[0];

        // project
        BillingServiceProxy.project soapProject = new BillingServiceProxy.project();
        soapProject.projectid = project.ProjectRef__c;
        soapProject.billAmount = project.Billable_Amount__c;
        soapProject.username = CREDENTIALS.Username__c;
        soapProject.password = CREDENTIALS.Password__c;
		system.debug('soapProject=='+soapProject);
        // callout
        BillingServiceProxy.InvoicesPortSoap11 port = new BillingServiceProxy.InvoicesPortSoap11();
        String response = port.billProject(soapProject);

        // update project on success
        if (response == 'OK') {
            project.Status__c = 'Billed';
            update project;
        }
    }
}