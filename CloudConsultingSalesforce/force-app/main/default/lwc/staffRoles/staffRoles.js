import { LightningElement, api, wire } from 'lwc';
import getRequirementsForProject from '@salesforce/apex/ProjectClass.getRequirementsForProject'
import {refreshApex} from '@salesforce/apex';

export default class LightningExampleAccordionMultiple extends LightningElement {
    @api recordId;
    requireRoles;
    projectDates;

    @wire
    (getRequirementsForProject, { projectId: '$recordId' })
    roles(result){
        this.requireRoles = result
    
    }    

    handleAssign(){
        return refreshApex(this.requireRoles);
    }
}