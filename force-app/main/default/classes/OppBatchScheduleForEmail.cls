global class OppBatchScheduleForEmail implements Database.Batchable<String>{
    public List<string> lstOfOpp = new List<string>();
    public List<string> OwnerList = new List<string>();
    public List<Opportunity> OppList = new List<Opportunity>();
    public List<String> OwnerName = new List<String>();
    global OppBatchScheduleForEmail(){
        List<Opportunity> oppList = [SELECT Id, Owner.Email,Owner.Name, Name, CloseDate, StageName from Opportunity];
        for(Opportunity opp : oppList){
            OwnerList.add(opp.OwnerId);
            OwnerName.add(opp.Owner.Name);
        }    
    }
    global Iterable<String> start (Database.BatchableContext BC){
        return OwnerList;
    }
    global void execute(database.BatchableContext BC, List<String> scope){
        system.debug('scope=='+scope);
        String htmlBody = '';
        String oppName;
        String oppStageName;
        Date oppCloseDate;
        string oppLink;
        for(String name : OwnerName){
            htmlBody = 'Hi '+name+', <br/>'+ '\n Please review the below opportunities which are closing today and kindly take the required actions \n <table border="1" style="border-collapse: collapse"><tr><th>Name</th><th>StageName</th><th>CloseDate</th><th>Opportunity Link</th></tr>';
        }
        for(opportunity l : [SELECT Id, Owner.Email, Name, CloseDate,Owner.Name, StageName from Opportunity Where OwnerId IN :scope]){
            lstOfOpp.add(l.Owner.Email);
            oppName = l.Name;
            oppStageName = l.StageName;
            oppCloseDate = l.CloseDate;
            //oppLink = l.Link__c;
            htmlBody += '<tr><td>' + oppName + '</td><td>' + oppStageName +'</td><td>' + oppCloseDate + '</td><td>' + oppLink + '</td></tr>';
        }
        htmlBody += '</table> <br/> Thank You <br/> Salesforce Automation';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(lstOfOpp);
        mail.setSenderDisplayName(UserInfo.getName());
        mail.setSubject('Opportunity with today close date');
        mail.setHTMLBody(htmlBody);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>{mail};
            Messaging.sendEmail(mails);
    }
    global void finish(database.BatchableContext BC){
        
    }
}