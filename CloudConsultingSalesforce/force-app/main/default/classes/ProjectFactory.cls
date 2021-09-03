public class ProjectFactory {
    public static void createOpportunity(Integer numOfOpp){
                
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        List<Opportunity> newOpps = new List<Opportunity>();
        for(Integer i=0 ; i<numOfOpp; i++){
            Date day = Date.today();
            Opportunity opp = new Opportunity(
            			Name = 'Test Opp' + i,
                		CloseDate = day.addDays(i+1),
                		Start_Date__c = day.addDays(i+1),
                		End_Date__c = day.addDays(90+i),
                		StageName = 'Prospecting',
                		AccountId = acct.Id,
                		Project_Manager__c = [SELECT Id FROM User WHERE Name = 'Rodrigo Cadiz' LIMIT 1].Id
            );
            newOpps.add(opp);
        }
        insert newOpps;
        
        List<OpportunityLineItem__c> newOppLineItem = new List<OpportunityLineItem__c>();
        Integer i = 400;
        for(Opportunity opp : newOpps){
               OpportunityLineItem__c newOppItemDev = new OpportunityLineItem__c(
                                      					Opportunity__c = opp.Id,
                    									Name = opp.name + '' + 'Desarrollador',
                    									Quantity__c = i + 50,
                   										Rol__c = 'Desarrollador'
                                                    );
            newOppLineItem.add(newOppItemDev);
            
            OpportunityLineItem__c newOppItemArch = new OpportunityLineItem__c(
                                      					Opportunity__c = opp.Id,
                    									Name = opp.name + '' + 'Arquitecto',
                    									Quantity__c = i - 50,
                   										Rol__c = 'Arquitecto'
                                                    );
            newOppLineItem.add(newOppItemArch);
            
            OpportunityLineItem__c newOppItemCons = new OpportunityLineItem__c(
                                      					Opportunity__c = opp.Id,
                    									Name = opp.name + '' + 'Consultor',
                    									Quantity__c = i,
                   										Rol__c = 'Consultor'
                                                    );
            newOppLineItem.add(newOppItemCons);
        }
        
        insert newOppLineItem;
    }
}