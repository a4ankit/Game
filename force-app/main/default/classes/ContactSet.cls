public class ContactSet 
{
    public String cid{get;set;}
    public sobject temp{get;set;}
    public boolean bb {get;set;}
    public Contact objCon{get;set;}
    public Lead objLead {get;set;}
    public sObject varsObject{get;set;}
    public ContactSet()
    {
        objCon = new Contact();
        bb = false;
        system.debug('In constructor');
        
    }
    public void show(){
        bb=true;
        objCon = (Contact) displayImage(cid);
        //objLead = (Lead) displayImage(cid);
    }
    public  sObject displayImage(Id testid)
    {    
        system.debug('In Dipslay--'+testid);
        if(testid != null){
            objCon = new contact();
            objLead = new Lead();
            String sObjName = testid.getSObjectType().getDescribe().getName();
            if(testid != null && sObjName == 'Contact')
            {
                objCon = [select PhotoUrl from contact where id=: testid];
                system.debug('objCon=='+objCon);
                return objCon;
            }
            if(testid != null && sObjName == 'Lead')
            {
                objLead = [select PhotoUrl from Lead where id=: testid];
                return objLead;
            }
        }
        return null;
    }
}