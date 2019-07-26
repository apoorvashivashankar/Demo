global class ScheduleBatchUpdateSalesRegionField implements Schedulable{
	global void execute(SchedulableContext SC) { 
        BatchUpdateSalesRegionField be = new BatchUpdateSalesRegionField();
        Database.executeBatch(be);
   } 
   static TestMethod void test(){
		ScheduleBatchUpdateSalesRegionField s=new ScheduleBatchUpdateSalesRegionField();
		s.execute(null);
	}
}