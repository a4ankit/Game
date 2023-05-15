trigger ToPassLicense on User (after insert, after update) 
{
    if(trigger.IsInsert && Trigger.isAfter){
        PassLicenseHelper.userLicensepassing(Trigger.new,trigger.oldMap,true,false);
    }
    if(trigger.IsUpdate && Trigger.isAfter){
        PassLicenseHelper.userLicensepassing(trigger.new, trigger.oldMap,false,true);
    }
}