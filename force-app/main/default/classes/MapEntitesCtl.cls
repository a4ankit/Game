public class MapEntitesCtl {
    
    @auraEnabled
    public static List<String> getSelectoptions(){
        List<String> stdObjectNames = new List<String>();
        List<String> stdObjectNames1 = new List<String>();
        for ( Schema.SObjectType typ : Schema.getGlobalDescribe().values() ) {
            String sobjName = String.valueOf(typ);
            stdObjectNames.add(sobjName);
        }
        System.debug('stdObjectNames: ' + stdObjectNames);
        for(String val : stdObjectNames){
            if(val =='Account'){
                stdObjectNames1.add(val); 
            }else if(val=='Contact'){
                stdObjectNames1.add(val);            
            }
            else if(val=='Lead'){
                stdObjectNames1.add(val);            
            }
            else if(val=='Opportunity'){
                stdObjectNames1.add(val);            
            }
        }
        stdObjectNames1.sort();
        stdObjectNames1.size();
        System.debug('stdObjectNames Size ' + stdObjectNames.size());
        return stdObjectNames1;
    }
    
    @auraEnabled
    public static List<String> getFieldlist (String Objname){
        Sobject Objectname = Schema.getGlobalDescribe().get(Objname).newSObject();
        System.debug('******Objname*****'+Objname);
        List< String > lstfieldsName = new List< String >();
        Schema.sObjectType objType = Objectname.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        for(Schema.SObjectField fld : fieldMap.values()){
            String fieldNames = String.valueOf(fld);
            lstfieldsName.add(fieldNames);
        }
        System.debug('*******lstfieldsName********'+lstfieldsName);
        return lstfieldsName;
    }
    
    @AuraEnabled
    public static List<sObject> querydata(List<String> FieldNameList, List<String> queryList, String Objname){
        system.debug('++Objname++'+Objname);
        system.debug('===queryList=='+queryList);
        system.debug('===FieldNameList=='+FieldNameList);
        List<Sobject> recordList = new List<Sobject>();
        List<string> lsstr= new List<string>();
        String query;
        String SobjectApiName = Objname;
        string fields = string.join(FieldNameList,',');
        system.debug('fields=='+fields);
        String where_clause = ' ';
        if (!queryList.isEmpty()){
            where_clause = 'WHERE (' + String.join(queryList, ' ) AND ( ') + ')';
            system.debug('where_clause==='+where_clause);
        }
        query = 'select ' + fields + ' from ' + SobjectApiName + ' ' + where_clause ;
        system.debug('query=='+query);
        recordList = Database.query(query);
        system.debug('recordList==='+recordList);
        return recordList;
    }
    
    @auraEnabled
    public static List<SelectOptionLightning> getFilterOperators(String Objname, String fieldName){
        if(Objname !=null && fieldName !=null){
            Schema.SObjectType t = Schema.getGlobalDescribe().get(Objname);
            
            Schema.DescribeSObjectResult r = t.getDescribe();
            Schema.DescribeFieldResult f = r.fields.getMap().get(fieldName).getDescribe();
            Schema.DisplayType type = f.getType();
            
            
            List<SelectOptionLightning> selectOperators = new List<SelectOptionLightning>();
            if(type == Schema.DisplayType.Boolean || type == Schema.DisplayType.Email || type == Schema.DisplayType.EncryptedString || type == Schema.DisplayType.MultiPicklist || type == Schema.DisplayType.Picklist || type == Schema.DisplayType.Phone || type == Schema.DisplayType.Reference || type == Schema.DisplayType.String || type == Schema.DisplayType.URL || type == Schema.DisplayType.TextArea)
            {
                selectOperators.addAll(new List<SelectOptionLightning> { new SelectOptionLightning('=', 'Equals to',String.valueOf(type)), new SelectOptionLightning('!=', 'Not Equals to',String.valueOf(type))});
            }
            
            else
            {
                selectOperators.addAll(new List<SelectOptionLightning> { new SelectOptionLightning('=', '=',String.valueOf(type)), new SelectOptionLightning('!=', '!=', String.valueOf(type)), new SelectOptionLightning('>', '>',String.valueOf(type)), new SelectOptionLightning('<', '<',String.valueOf(type)), new SelectOptionLightning('>=', '>=',String.valueOf(type)), new SelectOptionLightning('<=', '<=', String.valueOf(type))});
            }
            return selectOperators;
        }else{
            return null;
        }
    }    
}