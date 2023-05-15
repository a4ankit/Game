public class PassLicenseHelper{
    public static void userLicensepassing(List<User> newConList, Map<id,User> OldMap, Boolean isInsert, Boolean isUpdate)
    {
		Map<boolean,string> MapisTrueToUserId = new Map<boolean,string>();
        PackageLicense pkg = [select id,NamespacePrefix from PackageLicense Where NamespacePrefix = 'dsfs' limit 1];
        system.debug('pkg==='+pkg.id);
       //Map<Id,PackageLicense> MapIdToObject =  new Map<Id, PackageLicense>([select id,NamespacePrefix from PackageLicense Where NamespacePrefix = 'dsfs' limit 1]);
        for(user obj : newConList){
            if(obj.devsfdx__Give_License__c){
                MapisTrueToUserId.put(obj.devsfdx__Give_License__c, obj.Id);          
            }
        }
        
     	UserPackageLicense usr = new UserPackageLicense();
        usr.UserId = MapisTrueToUserId.get(true);
        system.debug('usr.UserId++++'+usr.UserId);
        usr.PackageLicenseId = pkg.id;
        system.debug('usr.PackageLicenseId------'+usr.PackageLicenseId);
        insert usr;
        system.debug('usr-->'+ usr);
        
    }
}