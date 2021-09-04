import { LightningElement, api, wire } from 'lwc';
import getAvailableUsers from '@salesforce/apex/ProjectClass.getAvailableUsers'



export default class UserList extends LightningElement {
    @api recordId;
    @api lineItem;
    usersList;

    @wire(getAvailableUsers, {projectId: '$recordId'})
    users({data, error}){
        if(data){
            this.usersList = [];
            for(let i=0; i<data.length; i++){
                this.usersList.push({...data[i], Role: data[i].UserRole.Name})
            }
        }
    }

    handleSave(event){
        const users = JSON.parse(JSON.stringify(event.detail.draftValues))
        
    }


    columns = [
        { label: 'Role', fieldName: 'Role'},
        { label: 'First Name', fieldName: 'FirstName'},
        { label: 'Last Name', fieldName: 'LastName'},
        { 
            label: 'Start Date', 
            fieldName: 'Start_Date__c', 
            editable: true, 
            type: 'date-local', 
            typeAttributes: {year: "numeric",month: "2-digit",day: "2-digit"}
        },
        { 
            label: 'End Date', 
            fieldName: 'End_Date__c', 
            editable: true, 
            type: 'date-local',
            typeAttributes: {year: "numeric",month: "2-digit",day: "2-digit"} 
        },
    ];

    @api selectRowsData(){
        const dataUserRows= this.template.querySelector('lightning-datatable').getSelectedRows()
        const usersList = JSON.parse(JSON.stringify(dataUserRows))
        console.log(usersList)
        return { users: usersList, lineItem: this.lineItem }
    }
}