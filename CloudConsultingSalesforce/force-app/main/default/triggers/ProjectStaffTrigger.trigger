trigger ProjectStaffTrigger on Project_Staff__c (before insert) {
	ProjectStaffTriggerHelper.triggerBeforeInsert(Trigger.new);
}