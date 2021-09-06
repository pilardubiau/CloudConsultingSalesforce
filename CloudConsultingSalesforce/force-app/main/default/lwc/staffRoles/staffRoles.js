import { LightningElement, api, wire } from 'lwc';
import getRequirementsForProject from '@salesforce/apex/ProjectClass.getRequirementsForProject'
import {refreshApex} from '@salesforce/apex';
import { getRecord } from 'lightning/uiRecordApi';
import DISPLAY_DATE from '@salesforce/schema/Project__c.Date_Display__c'

export default class LightningExampleAccordionMultiple extends LightningElement {
    @api recordId;
    requireRoles;
    projectDates;
   

    @wire(getRecord, { recordId: '$recordId', fields: DISPLAY_DATE })
    project({data, error}){
        if(data){
            console.log('Data', data)
            console.log('data date',data.fields.Date_Display__c.value)
            this.projectDates = data.fields.Date_Display__c.value;
        }
    }

    @wire
    (getRequirementsForProject, { projectId: '$recordId' })
    roles(result){
        this.requireRoles = result
    
    }    

    handleAssign(){
        return refreshApex(this.requireRoles);
    }
}