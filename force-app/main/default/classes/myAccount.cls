public with sharing class myAccount{
    //Variable Declaration
    private final Account acc;
    public string Accid='';
    public blob Photo{get;set;}
    public string photoname{get;set;}
    public string photourl{get;set;}
    //Contstructor 
    public myAccount(apexpages.standardController controller){
        acc=(Account)controller.getRecord();
        photourl = [SELECT Id, devsfdx__imageUrl__c FROM Account WHERE Id = :acc.ID ].imageUrl__c;      
        
    }
    
    //this method updates the Contact with photourl and insert The Attachment Record
    public void UploadPhoto(){
        try{
            // inserting attachement with Attached photo      
            Attachment objA=new Attachment();
            objA.body = photo;
            objA.name = 'testname';
            objA.parentid= acc.id;
            objA.ContentType = 'application/jpg';
            insert objA;
            string Attid= objA.id;
            string attachmentid=Attid.substring(0,15);
            acc.imageUrl__c = '/servlet/servlet.FileDownload?file='+attachmentid;
            update acc;
            photourl = acc.imageurl__c;        
        }catch(Exception e){
            system.debug('Exception message'+e);
        }
    } 
}