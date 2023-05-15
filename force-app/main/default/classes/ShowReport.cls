public class ShowReport {
    @AuraEnabled
    public static String getreport(){
        //Using report id for example purpose
        Report reportRec = [SELECT
                            Id
                            FROM Report
                            WHERE Id = '00O7F00000AZXHPUA5'];
        
        Reports.ReportResults reportResult =
            Reports.ReportManager.runReport(reportRec.Id, true);
        
        return JSON.serialize(reportResult);
    }
}