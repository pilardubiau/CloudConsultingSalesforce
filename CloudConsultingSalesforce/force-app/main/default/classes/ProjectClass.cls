public class ProjectClass {
    //Devuelve el listado de requerimientos de staff para el proyecto.
    @AuraEnabled(cacheable=true)
    public static List<Project_Line_Item__c> getRequirementsForProject(Id projectId){
        List<Project_Line_Item__c> staffRequirementsInProject = [SELECT Id, Project__r.Start_Date__c, Project__r.End_Date__c, Role__c, Quantity__c, Hours_Assigned__c
                                      							 FROM Project_Line_Item__c WHERE Project__c =: projectId];
       
        return staffRequirementsInProject;
    }
    
    //Devuelve una lista de usuarios asociados a los roles requeridos.
    public static List<User> getUserByRol(Id projectId){
        List<Project_Line_Item__c> staffRequirementsInProject = getRequirementsForProject(projectId);
        
 		List<String> rolesList = new List<String>();
        for(Project_Line_Item__c p: staffRequirementsInProject){
            rolesList.add(p.Role__c);
        }
          
   		List<User> usersByRoles = [select Id, FirstName, LastName, UserRole.Name from User where UserRole.Name in: rolesList];  
     	
        return usersByRoles;
    }
        
    //Agrupa los projects staff por usuarios.
    public static Map<Id, List<Project_Staff__c>> getProjectStaffByUser(Id projectId){
        List<User> usersByRoles = getUserByRol(projectId);
        
        List<Project_Staff__c> staffList = [SELECT Id, Start_Date__c, End_Date__c, User__c   
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
        
        return userMap;
    }
        
    //Lista los usuarios disponibles, Cuyos project staff no coinciden con lad fechas del proyecto actual.
    public static List<User> getAvailableUsers(Id projectId){ 
        Map<Id, List<Project_Staff__c>> userMap = getProjectStaffByUser(projectId);
        List<Project_Line_Item__c> staffRequirementsInProject = getRequirementsForProject(projectId);
        List<User> usersByRoles = getUserByRol(projectId);
        
        Date startProjectDate = staffRequirementsInProject[0].Project__r.Start_Date__c;
        Date endProjectDate = staffRequirementsInProject[0].Project__r.End_Date__c;
        
        List<User> availableUsers = new List<User>();
        for(Id staffId: userMap.keySet()){
            Boolean available = true;
            if(userMap.get(staffId).size()>0){
                for(Project_Staff__c PS: userMap.get(staffId)){
                    if(!((PS.Start_Date__c < startProjectDate || PS.Start_Date__c > endProjectDate) 
                       && (PS.End_Date__c < startProjectDate || PS.End_Date__c > endProjectDate))){
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
    
   	//Lista los usuarios disponibles segun el rol solicitado.
    @AuraEnabled(cacheable=true)
    public static List<User> getAvailableUsersByRole(Id projectId, String role){
        List<User> availableUsers = getAvailableUsers(projectId); 
        List<User> availableUsersByRole = new List<User>();
        
        for(User u: availableUsers){
            if(u.UserRole.Name == role){
                availableUsersByRole.add(u);
            }
        }
        return availableUsersByRole;
    }
}