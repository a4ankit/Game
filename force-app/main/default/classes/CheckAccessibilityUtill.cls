//Generic class to check accessibilty of any object and its fields
public with sharing class CheckAccessibilityUtill { 
    //method to check FLS access through three parameters(ObjectName, AllFields, DMLType)
    public static boolean checkFieldLevelSecurity(String sObjectType, String commaDelimitedFields, String typeOfDml){
        boolean securityPass = true;
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        
        //check object permission first
        
        if(schemaType.getDescribe().isAccessible()){
            if(typeOfDml == 'Create'){
                if(!schemaType.getDescribe().isCreateable()){
                    securityPass = false;
                }
            }
            else if(typeOfDml == 'Update'){
                if(!schemaType.getDescribe().isUpdateable()){
                    securityPass = false;
                }
            }
            else if(typeOfDml == 'Upsert'){
                if(!schemaType.getDescribe().isCreateable() && !schemaType.getDescribe().isUpdateable()){
                    securityPass = false;
                }
            }
            else if(typeOfDml == 'Query'){
                securityPass = true;
            }
            for (String field : commaDelimitedFields.split(',')){
                if(fields.get(field) != null && fields.get(field).getDescribe() != null && fields.get(field).getDescribe().isPermissionable()){
                    if(typeOfDml == 'Create'){
                        if (!fields.get(field).getDescribe().isCreateable()){
                            securityPass = false;
                        }
                    }
                    else if(typeOfDml == 'Update'){
                        if (!fields.get(field).getDescribe().isUpdateable()){
                            securityPass = false;
                        }
                    }
                    else if(typeOfDml == 'Query'){
                        if (!fields.get(field).getDescribe().isAccessible()){
                            securityPass = false;
                        }
                    }
                    else if(typeOfDml == 'Upsert'){
                        if ((!fields.get(field).getDescribe().isUpdateable()) || (!fields.get(field).getDescribe().isCreateable())){
                            securityPass = false;
                        }
                    }
                }
            }
        }else{
            securityPass = false;
        }
        return securityPass;
    }
}