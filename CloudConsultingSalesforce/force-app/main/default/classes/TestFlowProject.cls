@IsTest
public class TestFlowProject {
    @testSetup static void setup(){
       ProjectFactory.createOpportunity(10);
    }
    
    @isTest static void testFlow(){
        List<Opportunity> oppList = [SELECT Id, Project_Manager__c FROM Opportunity];
        Test.startTest();
            for(Opportunity opp : oppList){
                opp.StageName = 'Closed Won';
            }
            update oppList;
        Test.stopTest();
        System.assertEquals(oppList.size(), [SELECT count() FROM Project__c]);
        
        System.assertEquals(oppList[0].Project_Manager__c, [SELECT Id, OwnerId FROM Project__c LIMIT 1].OwnerId);
        
        List<Project_Line_Item__c> listProjectItem = [SELECT Id FROM Project_Line_Item__c];
        List<OpportunityLineItem__c> listOppItem = [SELECT Id FROM OpportunityLineItem__c];
        
        System.assertEquals(listOppItem.size(), listProjectItem.size());
        
    }
}