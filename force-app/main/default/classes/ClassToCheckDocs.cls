global class ClassToCheckDocs {
    global List<ContentVersion> docs {get;set;}
    global static List<ContentVersion> getContentDocs() {
        List<ContentVersion> docs = new List<ContentVersion>();
        ID workspaceId = [SELECT Id FROM ContentWorkspace WHERE Name = 'Partner Call Details Demo'][0].Id;
        for (ContentVersion d : [select Id, Title, FileExtension from ContentVersion where ContentDocument.ParentId = :workspaceId and IsLatest=true]) {
            docs.add(d);
        }
        return docs;
    }
}