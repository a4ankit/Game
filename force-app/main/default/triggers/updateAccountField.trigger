trigger updateAccountField on contact (before update){
    for(contact con: trigger.new){
        if(con.Account != Null){
            if(con.devsfdx__Primary__c){
                con.Account.devsfdx__PrimaryContact__c = con.Name;
                con.Account.devsfdx__SecondaryContact__c = [SELECT Id FROM Account WHERE Id =: con.AccountId].devsfdx__PrimaryContact__c;
                
            }
            else{
                con.Account.devsfdx__PrimaryContact__c = [SELECT Id FROM Account WHERE Id =: con.AccountId].devsfdx__SecondaryContact__c;
                con.Account.devsfdx__SecondaryContact__c = con.Name;
            }
        }
    }
}