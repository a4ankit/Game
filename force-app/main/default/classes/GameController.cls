public class GameController {
    public  devsfdx__GameSetting__c gameSet{get;set;}
    public  String savedHighScr{get;set;}
    public  String highScr{get;set;}
    public String userID {get;set;}
    public List<ContentVersion> docs {get;set;}
    public List<String> docsURL {get;set;}
    public Set<Id> cvIds {get;set;}
    public  GameController(){
        cvIds = new Set<Id>();
        docsURL = new List<String>();
        docs = new List<ContentVersion>();
        ID workspaceId = [SELECT Id FROM ContentWorkspace WHERE Name = 'Partner Call Details Demo'][0].Id;
        system.debug('docsdocs=='+docs);
        savedHighScr = '';
        highScr = '';
        gameSet = devsfdx__GameSetting__c.getInstance('Game Setting');
        
    }
    public PageReference compareHighScore(){
        Map<String, String> parms = ApexPages.currentPage().getParameters();
        
        if( parms.containsKey( 'highScr' ) ){
            userID = parms.get( 'highScr' );
            system.debug('userID......'+userID);
        }
        system.debug('gameSet.devsfdx__High_Score__c).222.....'+gameSet);
        String gameHighScore = gameSet.devsfdx__High_Score__c;
        
        system.debug('gameSet.v)......'+gameSet.devsfdx__High_Score__c);
        system.debug('Integer.valueOf(userID)......'+Integer.valueOf(gameHighScore));
        system.debug('Integer.valueOf(gameSet.devsfdx__High_Score__c).....'+Integer.valueOf(gameSet.devsfdx__High_Score__c));
        if(Integer.valueOf(userID) > Integer.valueOf(gameSet.devsfdx__High_Score__c)){
            gameSet.devsfdx__High_Score__c = userID;
            update gameSet;
        }
        
        savedHighScr = gameSet.devsfdx__High_Score__c;
        return null;
    }
    
    public PageReference forRerender(){
        return null;
    }
    public static List<ContentVersion> getContentDocs() {
        List<ContentVersion> docs = new List<ContentVersion>();
        ID workspaceId = [SELECT Id FROM ContentWorkspace WHERE Name = 'Partner Call Details Demo'][0].Id;
        for (ContentVersion d : [select Id, Title, FileExtension from ContentVersion where ContentDocument.ParentId = :workspaceId and IsLatest=true]) {
            docs.add(d);
        }
        system.debug('docsdocs=='+docs);
        return docs;
    }
    public Static List<ContentDistribution> getImageURL(){
        ID workspaceId = [SELECT Id FROM ContentWorkspace WHERE Name = 'Partner Call Details Demo'][0].Id;
        Set<Id> cvIds = new Set<Id>();
        List<ContentVersion> cv = new List<ContentVersion>();
        for (ContentVersion d : [select Id, Title, FileExtension from ContentVersion where ContentDocument.ParentId = :workspaceId and IsLatest=true]) {
            cv.add(d);
            cvIds.add(d.id);
        }
        List<ContentDistribution> cdList = [select ID,DistributionPublicUrl ,ContentDownloadURL  from ContentDistribution where ContentVersionId IN :cvIds];
        List<ContentDistribution> cdListNew = new List<ContentDistribution>();
        system.debug('cdList=='+cdList);
        if(cdList.size()>0){
            return cdList;
        }else{
            for(ContentVersion c : cv){
                ContentDistribution newItem = new ContentDistribution();
                newItem.Name = c.Title;
                newItem.ContentVersionId = c.Id;
                newItem.PreferencesAllowViewInBrowser= true;
                newItem.PreferencesLinkLatestVersion=true;
                newItem.PreferencesNotifyOnVisit=false;
                newItem.PreferencesPasswordRequired=false;
                newItem.PreferencesAllowOriginalDownload= true;
                cdListNew.add(newItem);
            }
        }
        insert cdListNew;
        system.debug('cdListNew=='+cdListNew);
        return cdListNew;
    }
}