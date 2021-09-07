@isTest
public class ProjectStaffTriggerTest {
	@testSetup
    static void setup(){
        ProjectFactory.createOpportunity(2);
        ProjectFactory.projectStaffCreator();
    }
    
    @isTest
    static void x(){
        
        Project_Staff__c ps = [SELECT Id, User__c, Start_Date__c, End_Date__c, Project_Line_Item__c FROM Project_Staff__c LIMIT 1];
        Project_Staff__c newPS = new Project_Staff__c(Name = 'Test trigger',
                                                      User__c = ps.User__c,
                                                      Project_Line_Item__c = ps.Project_Line_Item__c,
                                                      Start_Date__c = ps.Start_Date__c,
                                                      End_Date__c = ps.End_Date__c);
        try{
        	insert newPS;    
        }catch(DmlException e){
            System.assert(e.getMessage().contains('User not available'));
        }
    }
    
}