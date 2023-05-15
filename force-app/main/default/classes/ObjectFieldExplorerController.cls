public class ObjectFieldExplorerController {
    public String selectedObject { get; set; }
    public String selectedField { get; set; }
    public SelectOption[] getObjectOptions() {
        SelectOption[] results = new SelectOption[] { new SelectOption('','-- none --') };
        for(SObjectType sType: Schema.getGlobalDescribe().values()) {
            DescribeSObjectResult res = sType.getDescribe();
            results.add(new SelectOption(res.getName(), res.getLabel()));
            results.sort();
            results.size();
        }
        return results;
    }
    public SelectOption[] getFieldOptions() {
        SelectOption[] results = new SelectOption[] { new SelectOption('','-- none --') };
        if(selectedObject != null) {
            for(SObjectField sField: Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().values()) {
                DescribeFieldResult res = sField.getDescribe();
                results.add(new SelectOption(res.getName(), res.getLabel()));
            }
        }
        return results;
    }
}