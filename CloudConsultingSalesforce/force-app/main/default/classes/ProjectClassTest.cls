@isTest
public class ProjectClassTest {
    @testSetup static void setup(){
        ProjectFactory.createOpportunity(2);
        ProjectFactory.projectStaffCreator();
    }
    
    @isTest static void createStaffTest(){
        List<Project__c> currentProject = [SELECT Id from Project__c WHERE Name = 'Test Opp1'];
        List<User> users = ProjectClass.getAvailableUsersByRole(currentProject[0].Id, 'Desarrollador');
        
        System.assertEquals(2, users.size());
    }
}