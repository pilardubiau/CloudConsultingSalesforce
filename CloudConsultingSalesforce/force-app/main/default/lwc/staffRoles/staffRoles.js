import { LightningElement, api, wire } from 'lwc';
import getRequirementsForProject from '@salesforce/apex/ProjectClass.getRequirementsForProject'

export default class LightningExampleAccordionMultiple extends LightningElement {
    @api 
    recordId;
    
    @wire
    (getRequirementsForProject, { projectId: '$recordId' })
    requireRoles
        

    activeSectionsMessage = '';

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }

    handleSave(){
        let userList = this.template.querySelectorAll('c-user-list')
        console.log(userList.length)
        userList.forEach((list)=>{
            const users = list.selectRowsData()
            if(users.length){
                addStaff(users)
            }
        })
    }

    usersByRole= [
        {
            users:[{name:'Rodrigo Cadiz', id: '440'}, {name: 'Leonardo Campoy', id: '994'}],
            detail:{role : 'Desarrollador', lineItem: '54dfb5fDEV'}
        },
        {
            users: [{name: 'Pilar Dubiau'}],
            detail: {role: 'Arquitecto', lineItem: '45asd44ARQ'}
        },
        {
            users: [{name: 'Hernan Langer'}],
            detail: {role: 'Consultor', lineItem: '4fds5s8CONS'}
        }
    ]
}