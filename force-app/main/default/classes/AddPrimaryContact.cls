public class AddPrimaryContact implements Queueable {

	private String state;
    private contact c;

    
    public AddPrimaryContact(Contact c, String state)
    {
		this.c = c;
        this.state = state;
    }
     public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState = :state LIMIT 200];
        List<Contact> arrContNew = New List<Contact>() ;
        
        for (Account account : accounts) {
          Contact contNew = c.clone(false, true);
          contNew.AccountId = account.Id;
          arrContNew.add(contNew);
        }
        insert arrContNew;
    }
}