import { LightningElement, api, wire } from 'lwc';
import getRequirementsForProject from '@salesforce/apex/ProjectClass.getRequirementsForProject'

export default class LightningExampleAccordionMultiple extends LightningElement {
    @api recordId;
     
    @wire
    (getRequirementsForProject, { projectId: '$recordId' })
    requireRoles    

}