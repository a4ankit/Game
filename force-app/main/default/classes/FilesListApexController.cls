public class FilesListApexController 
{
    @AuraEnabled
    public static List<ContentDocument> getContentDocsnew(Id arecordId)
    {   
        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :arecordId];
        if (CDLs.size() < 1) return new List<ContentDocument>(); 
        
        // Make a List of ContentDocument IDs
        List <Id> CDIdList = new List <Id> ();
        for (ContentDocumentLink nextCDL : CDLs) {
            CDIdList.add(nextCDL.ContentDocumentId); 
        }        
        
        List<ContentDocument> entries = [SELECT Id, Title, FileType FROM ContentDocument WHERE ContentDocument.Id IN :CDIdList];
        return entries;
    }
    @AuraEnabled
    public static List<ContentVersion> getContentDocs() {
        List<ContentVersion> docs = new List<ContentVersion>();
        ID workspaceId = [SELECT Id FROM ContentWorkspace WHERE Name = 'Partner Call Details Demo'][0].Id;
        for (ContentVersion d : [select Id, Title, FileExtension from ContentVersion where ContentDocument.ParentId = :workspaceId and IsLatest=true]) {
            docs.add(d);
        }
        return docs;
    }
    
    /*private static List<ContentVersion> GetContentDocuments(Id pLinkedEntityId) {
List<ContentDocumentLink> links = [select Id, ContentDocumentId, LinkedEntityId from ContentDocumentLink where LinkedEntityId=:pLinkedEntityId];
Set<Id> docLinkIds = EnactusUtilities.getIdFieldFromObject(links, ContentDocumentLink.ContentDocumentId);
return [select Id, Title, FileExtension, ContentDocumentId from ContentVersion where ContentDocumentId=:docLinkIds and IsLatest=true];
}

private static Map<Id, string> GetContentDocumentDistributionsUrls(List<id> contentDocumentIds) {
Map<Id, string> urls = new  map<Id, string>();
for(ContentDistribution cd : [Select id , ContentDownloadUrl, ContentDocumentId from ContentDistribution where ContentDocumentId IN : contentDocumentIds  ]){
urls.put(cd.ContentDocumentId,cd.ContentDownloadUrl);
}
system.debug('GetContentDocumentDistributionsUrls>' + urls);
return urls;
}*/
}