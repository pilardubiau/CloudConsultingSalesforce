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
    @AuraEnabled(cacheable= true)
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
    
    @AuraEnabled
    public static void createProjectStaff(Object usersToAdd, Id projectId){
    
    List<Project_Staff__c> userObject = (List<Project_Staff__c>) JSON.deserialize(JSON.serialize(usersToAdd), List<Project_Staff__c>.class);
    System.debug(userObject);    

      List<Project_Line_Item__c> projectLineItemList =  getRequirementsForProject(projectId);
      Set<Id> usersId = new Set<Id>();   
      List<Project_Staff__c> newProjectStaffs = new List<Project_Staff__c>();
      Map<Id, Date> startDate = new Map<Id, Date>();
      Map<Id, Date> endDate = new Map<Id, Date>();
        
        for(Project_Staff__c so: userObject){
            startDate.put((Id) so.get('id'), (Date) so.get('Start_Date__c'));
            endDate.put((Id)so.get('id'),(Date) so.get('End_Date__c'));
            usersId.add((Id)so.Id);
        } 
        
      List<User> users = [select id, UserRole.Name from User where Id IN: usersId];
      System.debug(users);  
        for(Project_Line_Item__c pli: projectLineItemList){
            for(User u: users){
                if(u.UserRole.Name == pli.Role__c){
                    newProjectStaffs.add(
                        new Project_Staff__c(
                                            Name = pli.Role__c,
                                            User__c = u.Id,
                                            Project_Line_Item__c = pli.Id,
                                            Start_Date__c = startDate.get(u.Id),
                                            End_Date__c = endDate.get(u.Id))
                    );
                }
            }
        }  
        insert newProjectStaffs;   
    }   
    
    @AuraEnabled
    public static void squadLeadAssingment(Id idUser, Id idProject){
        Project__c projectSquadLead = [select Id from project__c where Id =: idProject];
        
        projectSquadLead.Squad_Lead__c = idUser;
        
        update projectSquadLead;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Project_Staff__c> getProjectStaff(Id projectId){
        List<Project_Staff__c> staff = [select Id, User__r.Name, Start_Date__c, End_Date__c  from Project_Staff__c where Project_Line_Item__r.Project__r.Id =: projectId];
        
        return staff;
    }
    
}