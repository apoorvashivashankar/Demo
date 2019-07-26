/**
* Description :
**/
global class Dal_SubmittedDraftCleanupScheduler implements Schedulable {

   // This test runs a scheduled job at 12am every day.

   global static final String CRON_EXPRESSION = '0 0 12 ? * * *';

   global void execute(SchedulableContext SC){
		Database.executeBatch(new Dal_SubmittedDraftCleanupBatch(), 200);
   }
   public static void schedule(String cron){
		if(String.isBlank(cron)){
			cron = CRON_EXPRESSION;
		}
		List<CronTrigger> existingCronTriggers = [SELECT Id, CronJobDetail.Name
												  FROM CronTrigger
											      WHERE CronJobDetail.Name LIKE '%Dal_SubmittedDraftCleanupScheduler%'
											     ];
       System.debug('existingCronTriggers'+existingCronTriggers.size());
       if(Test.isRunningTest()){
           existingCronTriggers.clear();
       }
		if(existingCronTriggers.size() == 0){
			System.schedule('Scheduled Apex: Dal_SubmittedDraftCleanupScheduler', cron, new Dal_DraftOrderCleanupScheduler());
		}
   }
}