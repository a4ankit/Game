public class treenodes
{
    public class cNodes
    {
        public List<Contact> parent {get; set;}
        Public Account gparent {get;set;}
        public cNodes(Account  gp, List<Contact> p)
        {       
            parent = p;       
            gparent = gp;   
        }  
    }
    Public List<cNodes> hierarchy;
    Public List<cNodes> getmainnodes()
    {
        hierarchy = new List<cNodes>();
        List<Account> tempparent = [Select Id,Name from Account limit 50];
        for (Integer i =0; i< tempparent.size() ; i++)
        {
            List<Contact> tempchildren = [Select Id,FirstName,LastName,(Select Id,CaseNumber,Subject from Cases) from Contact where AccountId = :tempparent[i].Id ];
            system.debug('tempchildren=='+tempchildren);
            hierarchy.add(new cNodes(tempparent[i],tempchildren));
            system.debug('hierarchy=='+hierarchy);
        }
        return hierarchy;
    }
}