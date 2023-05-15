@isTest
private class WarehouseSyncScheduleTest{
    
    @isTest
    public static void WarehouseSync() {
        
        Test.StartTest();
        WarehouseSyncSchedule sh1 = new WarehouseSyncSchedule();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
        
    }
}