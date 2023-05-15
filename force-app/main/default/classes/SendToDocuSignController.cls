public with sharing class SendToDocuSignController {
    public final SBQQ__Quote__c objQuote{get;set;}
    public String envelopeId {get;set;}
    private String accountId = 'b9e3d17a-3840-4fc1-a62c-298b4841213e';
    private String userId = 'ankitsharma.algoworks@gmail.com';
    private String password = '@ansh1996';
    private String integratorsKey = '4f834c52-694c-41e2-9d0c-6d64299d0322';
    private String webServiceUrl = 'https://demo.docusign.net/api/3.0/dsapi.asmx';
    
    public SendToDocuSignController(ApexPages.StandardController controller){
        this.objQuote = [select Id,Name,SBQQ__PrimaryContact__c from SBQQ__Quote__c where id = :controller.getRecord().Id];
        //Getting the Docusign Admin credentials from custom setting
        /*DocuSign_Credentials__c objAdminSetting = DocuSign_Credentials__c.getinstance('DocuSign_Admin');
        userId = objAdminSetting.UserId__c;
        password = objAdminSetting.Password__c;*/
        envelopeId = 'Not sent yet';
    }
    public pagereference SendNow(){
        system.debug('userId::'+userId+'password:::'+password);
        
        Map<Id,SBQQ__QuoteDocument__c> MapQuoteIdToRelatedQuoteDoc = new Map<Id,SBQQ__QuoteDocument__c>();
        for(SBQQ__QuoteDocument__c objQD : [select Id, Name, SBQQ__Quote__c, SBQQ__Version__c from SBQQ__QuoteDocument__c where SBQQ__Quote__c = :objQuote.Id order by SBQQ__Version__c desc LIMIT 1]){
            MapQuoteIdToRelatedQuoteDoc.put(objQD.SBQQ__Quote__c,objQD);
        }
        system.debug('MapQuoteIdToRelatedQuoteDoc:::'+MapQuoteIdToRelatedQuoteDoc);
        // Recipient
        System.debug('getting the contact');
        List<Contact> lstContacts = [SELECT email, FirstName, LastName from Contact where id = :objQuote.SBQQ__PrimaryContact__c LIMIT 1];
        system.debug('lstContacts:::'+lstContacts);
        List<Attachment> attachmentList = [Select Id, Name, ContentType, ParentId, Body from Attachment Where Parent.Type = 'SBQQ__Quote__c' AND ParentId =:objQuote.Id  ORDER BY createddate desc LIMIT 1];
        system.debug('attachmentList!!!'+attachmentList);
        
        dsapiSend.APIServiceSoap dsApiSend = new dsapiSend.APIServiceSoap();
        dsApiSend.endpoint_x = webServiceUrl;
        
        //Set Authentication
        String auth = '<DocuSignCredentials><Username>'+ userId 
            +'</Username><Password>' + password 
            + '</Password><IntegratorKey>' + integratorsKey 
            + '</IntegratorKey></DocuSignCredentials>';
        System.debug('Setting authentication to: ' + auth);
        
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication',auth);
        dsApiSend.timeout_x = 120000;
        
        dsapiSend.Envelope envelope = new dsapiSend.Envelope();
        envelope.Subject = 'Please Sign this Contract: '+ objQuote.Name;
        if(lstContacts != null && !lstContacts.isEmpty() && attachmentList !=null && !attachmentList.isEmpty()){
            envelope.EmailBlurb = lstContacts.get(0).FirstName + ' ' + lstContacts.get(0).LastName +',' + ' \r\n'+
                ' Please DocuSign ' + attachmentList.get(0).Name +' \r\n'+
                ' Thank You, ' + UserInfo.getName();
        }
        envelope.AccountId  = accountId; 
        
        system.debug('AttName:::'+MapQuoteIdToRelatedQuoteDoc.get(objQuote.Id).Name);
        
        // Document
        dsapiSend.Document document = new dsapiSend.Document();
        document.ID = 1;
        //document.pdfBytes = EncodingUtil.base64Encode(pdfBlob);
        if(attachmentList !=null && !attachmentList.isEmpty()){
            system.debug('AttachmentBody:::'+attachmentList);
            document.pdfBytes = EncodingUtil.base64Encode(attachmentList.get(0).body);
            document.Name = attachmentList.get(0).Name;
        }
        document.FileExtension = 'pdf';
        envelope.Documents = new dsapiSend.ArrayOfDocument();
        envelope.Documents.Document = new dsapiSend.Document[1];
        envelope.Documents.Document[0] = document;
        dsapiSend.Recipient recipient = new dsapiSend.Recipient();
        recipient.ID = 1;
        recipient.Type_x = 'Signer';
        recipient.RoutingOrder = 1;
        if(lstContacts != null && !lstContacts.isEmpty()){
            recipient.Email = lstContacts.get(0).Email;
            recipient.UserName = lstContacts.get(0).FirstName + ' ' + lstContacts.get(0).LastName;
        }
        
        recipient.RequireIDLookup = false;      
        
        envelope.Recipients = new dsapiSend.ArrayOfRecipient();
        envelope.Recipients.Recipient = new dsapiSend.Recipient[1];
        envelope.Recipients.Recipient[0] = recipient;
        
        System.debug('Calling the API');
        try {
            System.debug('envelope:::'+envelope);
            dsapiSend.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
            dsapiSend.EnvelopeStatus status = dsapiSend.CreateAndSendEnvelope(envelope);
            system.debug('status'+status);
            envelopeId = es.EnvelopeID;
            return new PageReference('/'+objQuote.Id);  
        } catch ( CalloutException e) {
            System.debug('Exception - ' + e );
            envelopeId = 'Exception - ' + e;
            return null;
        }   
    }
}