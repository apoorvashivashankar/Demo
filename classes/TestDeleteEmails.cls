@isTest
private class TestDeleteEmails {

    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    @testSetup
    static void setup() {    

        DateTime dt = System.now();
		DateTime oldYear = dt.addMonths(-24);
        String stringCase = '{"attributes":{"type":"Case","url":"/services/data/v25.0/sobjects/Case/500E0000002nH2fIAE"},"Subject":"Email Deletion","Status":"Closed","CreatedDate":"2015-09-13T20:30:00.000Z","ClosedDate":"2015-09-13T20:30:00.000Z"}'; 
        System.debug('Test stringCase:' + stringCase); 
        String caseJSON = stringCase;
        
        Case c = (Case) JSON.deserialize(caseJSON, Case.class ); 
        insert c;
        System.debug('Test case ClosedDate:' + c.ClosedDate); 
        System.debug('Test case Id:' + c.Id); 
        System.debug('Test case Status:' + c.status);         
        
        EmailMessage[] newEmail = new EmailMessage[0];
        
        for(Integer i=0;i<2500;i++) {
            newEmail.add(new EmailMessage(
                FromAddress = i+'test@test.com',
                FromName = 'fromName',
                ToAddress = 'email@toAddresses.com',
                Subject = 'email.subject',
                TextBody = 'email.plainTextBody',
                HtmlBody = 'email.htmlBody',
                ParentId = c.id,
                Status = '0'));   
        }
        insert newEmail;       
        System.debug('Test newEmail:' + newEmail); 
	}
    
	@isTest    
    static void testCaseEmailDeletes() { 
        
        Test.startTest();
        
        try {
            List <Case> listCases = new List <Case> ();
            listCases = [
                SELECT ID
                    , Subject
                    , (
                		SELECT id
                		FROM EmailMessages
                		)
                	, CreatedDate
                FROM CASE 
                WHERE ID IN (
                			SELECT ParentId
                			FROM EmailMessage
                			)
                AND Subject = 'Email Deletion'
            ];
            List <EmailMessage> listEMails = new List <EmailMessage> ();
            listEMails = [
                SELECT ID
                FROM EmailMessage
                WHERE Subject = 'email.subject'
            ];
            String jobId = System.schedule('ScheduledApexTest',CRON_EXP,new deleteEmailsScheduled());
            deleteOldCaseEmails delEmails = new deleteOldCaseEmails();
            deleteEmailsScheduled des = new deleteEmailsScheduled();
            Database.executeBatch(delEmails); 
            ID BatchProcessdId = Database.executeBatch(delEmails, 50);
            des.execute(null);
            delEmails.execute(null,listCases);
            // CronTrigger ct = [Select id , CronExpression from CronTrigger where id = :jobId];
            // System.assertEquals(CRON_EXP,ct.CronExpression);
        } catch (Exception e) {
            System.debug('::::test error ::::> ' + e.getMessage());
	    } 
        Test.stopTest();
       
    }
}