public class ProjectStaffTriggerHelper {
    public static void triggerBeforeInsert(List<Project_Staff__c> staffList){
        Map<Id, List<Project_Staff__c>> projectStaffByProject = new Map<Id, List<Project_Staff__c>>();
        
        Set<Id> usersId = new Set<Id>(); 
        for(Project_Staff__c staff : staffList){
            usersId.add(staff.User__c);
        }
        
        for(Project_Staff__c staff : staffList){
            if(!projectStaffByProject.containsKey(staff.Project_Line_Item__r.Project__c)){
                projectStaffByProject.put((Id)staff.Project_Line_Item__r.Project__c, new List<Project_Staff__c>{staff});
            }
            else{
                projectStaffByProject.get(staff.Project_Line_Item__r.Project__c).add(staff);
            }
        }
        
        for(Id key : projectStaffByProject.keySet()){
            //List<Project_Staff__c>ProjectClass.getAvailableUsers(key)
        }
        
    }
}