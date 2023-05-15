public class SelectOptionLightning {
    public SelectOptionLightning(String value, String label, String fieldType) {
        this.value = value;
        this.label = label;
        this.disabled = false;
        this.escapeItem = false;
        this.fieldType = fieldType;
    }
    
    public SelectOptionLightning(String value, String label, Boolean isDisabled,  String fieldType) {
        this.value = value;
        this.label = label;
        this.disabled = isDisabled;
        this.escapeItem = false;
        this.fieldType = fieldType;
    }
    
    @AuraEnabled
    public String label { get;set; }
    @AuraEnabled
    public String value { get;set; }
    @AuraEnabled
    public Boolean disabled { get;set; }
    @AuraEnabled
    public Boolean escapeItem { get;set; }
    @AuraEnabled
    public String fieldType { get;set; }
}