public class MultiselectVFPageCtrl {
    
    public list<SelectOption> TestObjectLeftList {get;set;}
    public list<SelectOption> TestObjectRightList {get;set;}
    
    public MultiselectVFPageCtrl(){
        
        TestObjectLeftList = new list<SelectOption>();
        TestObjectRightList = new list<SelectOption>();
        
        for(Account toc:[select id,name from Account limit 25])
        { 
            TestObjectLeftList.add(new SelectOption(toc.name,toc.name));
        }
        TestObjectLeftList.sort();
        TestObjectRightList.sort();
    }
}