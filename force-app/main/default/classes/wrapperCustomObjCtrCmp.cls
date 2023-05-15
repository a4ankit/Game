public class wrapperCustomObjCtrCmp {    
    
    public class wrapperCustomClass{
        @AuraEnabled
        public string studentName;
        @AuraEnabled
        public string studentEmail;
        @AuraEnabled
        public string studentAddress;
        @AuraEnabled
        public Id recStudentId;
        @AuraEnabled
        public boolean checkAttachFile= false;
        
        public wrapperCustomClass(string studentName, string studentEmail, string studentAddress, Id recStudentId,boolean checkAttachFile){
            this.studentName = studentName;
            this.studentEmail = studentEmail;
            this.studentAddress = studentAddress;  
            this.recStudentId = recStudentId;  
            this.checkAttachFile=checkAttachFile;
        }
    }
    
    
    @AuraEnabled
    public static List<wrapperCustomClass> appCustomWrapListMthd(){
        List<Account> newStudent = new List<Account>();       
        List<wrapperCustomClass> custWrapObj = new  List<wrapperCustomClass>();
        List<Account> newStudentView =[Select Id, Name, Email__c, Site From Account];
        
        Map<Id,contentdocumentlink> projCheckIdDocMap = new Map<Id,contentdocumentlink> ();
        Set<Id> projChecklistIdSet= new Set<Id> ();
        for(Account de: newStudentView) {
            projChecklistIdSet.add(de.Id);
        }
        List<Contentdocumentlink> listDocs = [select Id,LinkedEntityId from contentdocumentlink where LinkedEntityId IN :projChecklistIdSet
                                             ];
        for(Contentdocumentlink doc: listDocs) {
            projCheckIdDocMap.put(doc.LinkedEntityId, doc); 
        }     
        
        boolean hasAttch= false;
        for(Account studentObj:newStudentView){
            
            if(projCheckIdDocMap.get(studentObj.Id)!=null){
                hasAttch=true;
                system.debug('hasAttch###' + hasAttch);
                
            }else{
                hasAttch=false;
            }            
            custWrapObj.add(new wrapperCustomClass(studentObj.Name,studentObj.Email__c, studentObj.Site,studentObj.Id, hasAttch));                       
        }
        return custWrapObj;     
    }
}