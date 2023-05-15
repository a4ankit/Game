global class OppBatchSchedule implements database.Batchable <sObject>{
    public List<string> lstOfOpp = new List<string>();
    public List<Opportunity> OppList = new List<Opportunity>();
    global database.QueryLocator start (Database.BatchableContext BC){
        string query = 'Select Id, Owner.Email, Name, CloseDate, StageName, Owner.Name from Opportunity';
        return database.getQueryLocator(query);
    }
    global void execute(database.BatchableContext BC, List<opportunity> scope){
        String htmlBody = '';
        String oppName;
        String oppStageName;
        Date oppCloseDate;
        string oppLink;
        // string OwnerFullName;
        Map<string, list<opportunity>> oppMap = new Map<string, list<opportunity>>();
        for(opportunity opp1 : scope){
            if(!oppMap.containsKey(opp1.OwnerId)) {
                oppMap.put(opp1.OwnerId, new List<Opportunity> { opp1});
                system.debug('oppMap111 =' +oppMap);
            } else {
                oppMap.get(opp1.OwnerId).add(opp1);
                system.debug('oppMap222 =' +oppMap);
            }
        }
        system.debug('oppMap333 =' +oppMap);
        for(String key : oppMap.KeySet()){
            for(opportunity l : oppMap.get(key)){
                htmlBody = 'Hi'+l.OwnerId+ '\nPlease review the below opportunities which are closing today and kindly take the required actions \n <table border="1" style="border-collapse: collapse"><tr><th>Name</th><th>StageName</th><th>CloseDate</th><th>Opportunity Link</th></tr>';
                lstOfOpp.add(l.Owner.Email);
                oppName = l.Name;
                oppStageName = l.StageName;
                oppCloseDate = l.CloseDate;
                //oppLink = l.Link__c;
                htmlBody += '<tr><td>' + oppName + '</td><td>' + oppStageName +'</td><td>' + oppCloseDate + '</td><td>' + oppLink + '</td></tr>';
            }
        }
        htmlBody += '</table>';
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