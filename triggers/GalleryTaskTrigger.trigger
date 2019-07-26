trigger GalleryTaskTrigger on Task (after insert) {
	Task[] tasks=new Task[]{};
	for(Task t:trigger.new){
		if(t.RecordTypeId=='012F0000000mpvb'&&t.Number_of_Gallery_Visits__c!=null&&t.Number_of_Gallery_Visits__c>0){
			for(integer i=0;i<t.Number_of_Gallery_Visits__c;i++){
				Task tt=new Task();
				tt=t.clone(false);
				tt.Number_of_Gallery_Visits__c=null;
				tasks.add(tt);
			}
		}
	}
	if(tasks.size()>0){
		insert tasks;
	}
}