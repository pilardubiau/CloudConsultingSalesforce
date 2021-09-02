public class ProjectClass {
    //Metodo que retorna los roles requeridos por el proyecto
    public static List<Project_Line_Item__c> getRolsInProject(Id projectId){
        List<Project_Line_Item__c> staffRequirementsInProject = [SELECT Id, Project__r.Start_Date__c, Project__r.End_Date__c, Role__c
                                      							 FROM Project_Line_Item__c WHERE Project__c = 'a035f000001JlQwAAK'];
       
        return staffRequirementsInProject;
    }
    

    public static List<User> getAvailableUsers(Id projectId){
        List<Project_Line_Item__c> staffRequirementsInProject = getRolsInProject(projectId);
        Date startProjectDate = staffRequirementsInProject[0].Project__r.Start_Date__c;
        Date endProjectDate = staffRequirementsInProject[0].Project__r.End_Date__c;
        
 		List<String> rolesList = new List<String>();
        for(Project_Line_Item__c p: staffRequirementsInProject){
            rolesList.add(p.Role__c);
        }
          
   		List<User> usersByRoles = [select Id, FirstName, LastName, UserRole.Name from User where UserRole.Name in: rolesList];  
        List<Project_Staff__c> staffList = [SELECT Id, Project_Line_Item__r.Project__r.Start_Date__c,Project_Line_Item__r.Project__r.End_Date__c, User__c   
                                            FROM Project_Staff__c where User__c IN: usersByRoles and Project_Line_Item__r.Project__r.Stage__c != 'Completed'];
        
        Map<Id, List<Project_Staff__c>> userMap = new Map<Id, List<Project_Staff__c>>(); 
        for(User currentUser: usersByRoles){
            if(!userMap.containsKey(currentUser.Id)){
               userMap.put(currentUser.Id, new List<Project_Staff__c>()); 
            }
        }              
        for(Project_Staff__c staff: staffList){
            userMap.get(staff.user__c).add(staff);
        }
        
        List<User> availableUsers = new List<User>();
        
        for(Id staffId: userMap.keySet()){
            Boolean available = true;
            if(userMap.get(staffId).size()>0){
                for(Project_Staff__c PS: userMap.get(staffId)){
                    if(!((PS.Project_Line_Item__r.Project__r.Start_Date__c < startProjectDate || PS.Project_Line_Item__r.Project__r.Start_Date__c > endProjectDate) 
                       && (PS.Project_Line_Item__r.Project__r.End_Date__c < startProjectDate || PS.Project_Line_Item__r.Project__r.End_Date__c > endProjectDate))){
                           available = false;
                           break;                        
                       }
                }    
                if(available){
                    for(User userToAdd: usersByRoles){
                        if(userToAdd.Id == staffId){
                            availableUsers.add(userToAdd);
                        }
                    }
                  }
            } 
            else{
                for(User userToAdd: usersByRoles){
                    if(userToAdd.Id == staffId){
                        availableUsers.add(userToAdd);
                    }
                }               
            }
        }   
        return availableUsers;
    } 
}