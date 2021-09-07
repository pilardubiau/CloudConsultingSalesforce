@isTest
public class ProjectClassTest {
    @testSetup static void setup(){
        ProjectFactory.createOpportunity(2);
        ProjectFactory.projectStaffCreator();
    }
    
    @isTest static void getAvailableUsersByRoleTest(){
        List<Project__c> currentProject = [SELECT Id from Project__c WHERE Name = 'Test Opp1'];
        List<User> users = ProjectClass.getAvailableUsersByRole(currentProject[0].Id, 'Desarrollador');
        
        System.assertEquals(2, users.size());
    }
    
    @isTest static void createProjectStaffTest(){
        Id projectId = [SELECT Id FROM Project__c LIMIT 1].Id;
        Id users = [SELECT Id FROM User LIMIT 1].Id;
        Map<String, String> c = new Map<String, String>();
        Datetime day = Date.today();
        Datetime day1 = day.addDays(10);
        String StringDay = day.format('yyyy-MM-dd');
        String StringDay1 = day1.format('yyyy-MM-dd');
        
        c.put('Start_Date__c', StringDay);
        c.put('End_Date__c', StringDay1);
        c.put('id', (String) users);

        List<Map<String, String>> userObject = new List<Map<String, String>>{c};
           
        ProjectClass.createProjectStaff((Object)userObject, projectId);
    }
}