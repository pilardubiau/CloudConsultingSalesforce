trigger ProjectStaffTrigger on Project_Staff__c (before insert) {
    if(Trigger.isBefore){
        ProjectStaffTriggerHelper.triggerBeforeInsert(Trigger.new);
    }	
}