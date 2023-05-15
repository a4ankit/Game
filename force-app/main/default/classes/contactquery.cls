public class contactquery{
    /*public List<AccountFeed> cs{get; set;}
public contactquery()
{
cs = new List<AccountFeed>();
for (AccountFeed c : [select Body, CommentCount, CreatedBy.name, CreatedDate, InsertedBy.name, LastModifiedDate, LikeCount, Parent.name, RelatedRecordid, SystemModstamp, Title, Type, Visibility, (select commentbody from feedcomments) from AccountFeed Where Parent.Name Like 'Acc%'])
{       
cs.add(c);
}

}*/
    public List<AccountFeed> afeedList { get; set; }
    public List<FeedComment> FeedcomList { get; set; }
    Set<Id> memberIds = new Set<Id>();
    
    public List<AccountFeedWrapper> memberWrapperList { get; set; }
    
    public contactquery() {   
        afeedList = [select Body, CommentCount, CreatedBy.name, CreatedDate, InsertedBy.name, 
                     LastModifiedDate, LikeCount, Parent.name, RelatedRecordid, SystemModstamp, Title, Type, Visibility
                     from AccountFeed Where ParentId ='0017F000019RpWz'];
        memberWrapperList = new List<AccountFeedWrapper>();
        if(afeedList.size() > 0) {
            for(AccountFeed mem : afeedList) {
                memberIds.add(mem.Id);
            }
            system.debug('membersIds'+memberIds);
            FeedcomList = [SELECT CommentBody,CommentType,CreatedById,CreatedDate FROM FeedComment Where ParentId IN : memberIds];
            system.debug('FeedcomList List is ' + FeedcomList);
        }
        
    }
    public class AccountFeedWrapper {
        public AccountFeed acc {get; set;}
        public Boolean selected {get; set;}
        public FeedComment fc {get;set;}
    }
}