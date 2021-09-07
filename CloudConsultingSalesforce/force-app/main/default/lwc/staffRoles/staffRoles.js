import { LightningElement, api, wire } from 'lwc';
import getRequirementsForProject from '@salesforce/apex/ProjectClass.getRequirementsForProject'
import {refreshApex} from '@salesforce/apex';
import { getRecord } from 'lightning/uiRecordApi';
import DISPLAY_DATE from '@salesforce/schema/Project__c.Date_Display__c'

export default class LightningExampleAccordionMultiple extends LightningElement {

    @api recordId;
    requireRoles;
    projectDates;

    // Trae la fecha del proyecto 
    @wire(getRecord, { recordId: '$recordId', fields: DISPLAY_DATE })
    project({data, error}){
        if(data){
            this.projectDates = data.fields.Date_Display__c.value;
        }
    }

    //Trae los requerimientos del proyecto, mediante una llamada a un metodo de Apex
    @wire
    (getRequirementsForProject, { projectId: '$recordId' })
    roles(result){
        this.requireRoles = result
    }   
    
    //Actualiza la informacion de los requerimientos
    handleAssign(){
        return refreshApex(this.requireRoles);
    }
}