public class SampleController {
     
    Public List<String> leftSelected {get;set;}
    Public List<String> rightSelected {get;set;}
    Set<String> leftValues = new Set<String>();
    Set<String> rightValues = new Set<String>();
    public SampleController(){
        leftSelected = new List<String>();
        rightSelected = new List<String>();
        Sobject Objectname = Schema.getGlobalDescribe().get('Account').newSObject();
        List< String > lstfieldsName = new List< String >();
        Schema.sObjectType objType = Objectname.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        for(Schema.SObjectField fld : fieldMap.values()){
            String fieldNames = String.valueOf(fld);
            lstfieldsName.add(fieldNames);
        }
        leftValues.addAll(lstfieldsName);
        system.debug('leftValues:::'+leftValues);
        system.debug('leftSelected:::'+leftSelected);
    }
     
    public PageReference getSelect(){
        rightSelected.clear();
        for(String s : leftSelected){
            leftValues.remove(s);
            rightValues.add(s);
        }
        return null;
    }
     
    public PageReference getDeselect(){    
        leftSelected.clear();
        for(String s : rightSelected){
            rightValues.remove(s);
            leftValues.add(s);
        }
        return null;
    }
     
    public List<SelectOption> getDeselectedValues(){
       /* List<SelectOption> options = new List<SelectOption>();
        List<String> objList = new List<String>();
        objList.addAll(leftValues);
        objList.sort();
        for(String s : objList){
            options.add(new SelectOption(s,s));
        }
        return options;*/
        return null;
    }
     
    public List<SelectOption> getSelectedValues(){
         
        List<SelectOption> options = new List<SelectOption>();
        List<String> objList = new List<String>();
        objList.addAll(rightvalues);
        objList.sort();
        for(String s : objList){
            options.add(new SelectOption(s,s));
        }
        system.debug('options=='+options);
        return options;
    }
}