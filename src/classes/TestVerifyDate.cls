@isTest
private class TestVerifyDate {
    
    //date2 is within the next 30 days of date1
    @isTest static void testDates1(){        
        VerifyDate.CheckDates(date.today(), date.today().addDays(3));        
    }
    
    //date2 is not within the next 30 days of date1
    @isTest static void testDate2() {
        verifyDate.CheckDates(date.today(), date.today().addMonths(4));
    }

}