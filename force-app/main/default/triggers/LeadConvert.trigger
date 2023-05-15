/*** This is used when we wanted to update existing account and contact when same lead which is created from opportunity when its staged to 'closed lost' **/
trigger LeadConvert on Lead (before update) {
    for(Lead Ld : Trigger.new){
        if(Ld.IsConverted){
            List<Account> accountlist = [select id, Name ,Industry from Account where Name =: Ld.Company];  //Checking is there aleady any account or not
            if(accountlist == NULL & accountlist.size() == 0){
                Account account=new Account();
                account.Name=Ld.Company;
                account.Industry=Ld.Industry;
                insert account; //creating new account if not found any account
            }
            else{
                accountlist.get(0).Industry = Ld.Industry ;
                upsert accountlist.get(0); //update the existing account
            }
            List<Contact> contactList = [select Id,Name, LastName,FirstName,MailingStreet,phone from Contact where LastName =: Ld.LastName]; //Checking is there aleady any contact or not
            if(contactList == NULL & contactList.size() == 0){
                System.debug('####Account##########'+Account.Name);
                Contact con2= new Contact();
                con2.LastName=Ld.LastName;
                con2.FirstName=Ld.FirstName;
                con2.MailingStreet=Ld.Street;
                con2.MailingCity=Ld.City;
                con2.MailingState=Ld.State;
                con2.phone=Ld.phone;
                con2.MobilePhone=Ld.MobilePhone;
                con2.Title= Ld.Title;
                con2.Email=Ld.Email;
                con2.AccountId=Ld.ConvertedAccountId;
                insert con2;    //creating new account if not found any contact
            }
            else {
                contactList.get(0).MailingStreet=Ld.Street;
                contactList.get(0).MailingCity=Ld.City;
                contactList.get(0).MailingState=Ld.State;
                upsert contactList.get(0);  //update the existing account
            }
        }
    }
}