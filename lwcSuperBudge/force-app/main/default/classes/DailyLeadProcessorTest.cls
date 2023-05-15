@isTest
private class DailyLeadProcessorTest {
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 1 * * ?';
    static testmethod void testScheduledJob() {
        // Create some out of date Opportunity records
        List<Lead> leads = new List<Lead>();
        for (Integer i=0;i<200;i++) {
            leads.add(new Lead(LastName='Lead '+i,Company='testCompany',LeadSource=''));
        }
        insert leads;

        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new DailyLeadProcessor());
        Test.stopTest();
        // Now that the scheduled job has executed,
        System.assertEquals(200, [select count() from Lead where LeadSource = 'Dreamforce']);
    }
}