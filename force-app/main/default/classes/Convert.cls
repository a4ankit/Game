public class Convert
{
    
    public PageReference RedirecttoSite()
    {
        String currentLead = '/' + Lead.Id;
        PageReference pageRef = new PageReference(currentLead);
        return pageRef;
    }
    
    private Lead siteObj;
    //public ID Cus_Account_ID, Cus_obj_Record_ID;
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public Convert(ApexPages.StandardController stdController)
    {
        System.debug('******sai******');
        siteObj = (Lead)stdController.getRecord();
        // Cus_obj_Record_ID=siteObj.Id;
    }
    List<Account> acctList = new List<account>();
    public void convertbutton()
    {
        
        Account acc = new Account();
        acc.Name = siteObj.Company;
        acctList = [select id from Account where Name = :acc.Name];
        if (acctList.size() > 0)
        {
            
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Account Name ' + acc.Name + ' already exists,Duplicate Account Name not allowed');
            ApexPages.addMessage(errormsg);
            return;
        }
        /*acc.BillingStreet = siteObj.Company_Address__c;
acc.BillingCity = siteObj.Company_City__c;
acc.BillingState= siteObj.Company_State__c;
acc.BillingPostalCode = siteObj.Company_Postal_Code__c;
acc.Phone = siteObj.Company_Phone__c;
acc.Website = siteObj.Company_Email__c;
acc.Fax = siteObj.Company_Fax__c;*/
        // acc.CurrencyIsoCode = siteObj.CurrencyIsoCode;
        
        try
        {
            insert acc;
            ApexPages.Message successmsg = new ApexPages.Message(ApexPages.severity.confirm,'New Account ' + acc.Name + ' is created, Related Contact and Opporunity also created' );
            ApexPages.addMessage(successmsg);
        }
        Catch (Exception ex1)
        {
            ex1.getmessage();
        }
        Contact cc = new Contact();
        cc.LastName = siteObj.LastName;
        cc.Email = siteObj.Email;
        cc.Phone = siteObj.MobilePhone;
        cc.AccountId = acc.Id;
        
        try
        {
            insert cc;
        }
        Catch (Exception ex2)
        {
            
            ex2.getmessage();
        }
        
        Opportunity opp = new Opportunity();
        opp.Name = siteObj.Company;
        opp.AccountId= acc.Id;
        //opp.CloseDate = siteObj.Opp_CloseDate__c;
        opp.StageName = 'Prospecting';
        if(opp.StageName == 'Needs Analysis')
            opp.Probability= 20;
        else if(opp.StageName == 'Prospecting')
            opp.Probability= 10;
        else if(opp.StageName == 'Negotiation/Review')
            opp.Probability= 90;
        else if(opp.StageName == 'Closed Won')
            opp.Probability= 100;
        else if(opp.StageName == 'Closed Lost')
            opp.Probability= 0;
        
        try
        {
            insert opp;
        }
        Catch (Exception ex3)
        {
            ex3.getmessage();
        }
        
    }
}