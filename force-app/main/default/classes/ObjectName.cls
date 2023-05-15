public class ObjectName{
  public String val {get;set;}
 
  public List<SelectOption> getName()
  {
    List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();     
    List<SelectOption> options = new List<SelectOption>();
      System.debug('+++'+gd.size());
    
    for(Schema.SObjectType f : gd)
    {
        
            options.add(new SelectOption(f.getDescribe().getLabel(),f.getDescribe().getLabel()));
       
       
    }
    return options;
   }
}