public class ProjectStaffTriggerHelper {
    public static void triggerBeforeInsert(List<Project_Staff__c> staffList){
        Map<Id, List<Project_Staff__c>> projectStaffByUser = new Map<Id, List<Project_Staff__c>>();
        Set<Id> projectsId = new Set<Id>();
        Map<Id, Project__c> projectByProject = new Map<Id, Project__c>();
        
        Set<Id> usersId = new Set<Id>(); 
        for(Project_Staff__c staff : staffList){
            usersId.add(staff.User__c);
        }
        
        List<Project_Staff__c> projectStaff = [SELECT Id, Project_Line_Item__r.Project__r.Start_Date__c, Project_Line_Item__r.Project__r.End_Date__c, Project_Line_Item__r.Project__c
                                               FROM Project_Staff__c WHERE User__c IN: usersId AND Project_Line_Item__r.Project__r.Stage__c != 'Completed'];
        
        
        
        for(Project_Staff__c ps: projectStaff){
         	projectsId.add(ps.Project_Line_Item__r.Project__c);
            if(!(projectStaffByUser.containsKey(ps.User__c))){
                projectStaffByUser.put((Id) ps.User__c, new List<Project_Staff__c>{ps});
            }else{
                projectStaffByUser.get(ps.User__c).add(ps);
            }
        }
        
        List<Project_Staff__c> newPS = new List<Project_Staff__c>();
        
        for(Project_Staff__c sl: staffList){
            Boolean x = true;
            if(!(projectStaffByUser.get(sl.User__c).size() > 0)){
                newPs.add(sl);
                break;
            }
            for(Project_Staff__c PS: projectStaffByUser.get(sl.User__c)){
                if(!((PS.Start_Date__c < sl.Start_Date__c || PS.Start_Date__c > sl.End_Date__c) 
                    && (PS.End_Date__c < sl.Start_Date__c || PS.End_Date__c > sl.End_Date__c))){
					x = false;
                    break;
                    }
            }
            
            if(x){
                    newPs.add(sl);
            }else{
                sl.addError('FATAL ERROR loquito de mierda');
            }
        }
        
        insert newPS;
    }
}