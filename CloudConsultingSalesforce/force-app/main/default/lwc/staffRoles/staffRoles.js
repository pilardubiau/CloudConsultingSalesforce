import { LightningElement, api, wire } from 'lwc';
import getRequirementsForProject from '@salesforce/apex/ProjectClass.getRequirementsForProject'

export default class LightningExampleAccordionMultiple extends LightningElement {
    @api recordId;
     
    @wire
    (getRequirementsForProject, { projectId: '$recordId' })
    requireRoles    

    handleSave(){
        let userList = this.template.querySelectorAll('c-user-list')
        userList.forEach((list)=>{
            const users = list.selectRowsData()
            console.log(JSON.parse(JSON.stringify(users)))
        })
    }
}