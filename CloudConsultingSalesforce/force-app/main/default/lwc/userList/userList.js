import { LightningElement, api, wire } from 'lwc';
import getAvailableUsersByRole from '@salesforce/apex/ProjectClass.getAvailableUsersByRole'


export default class UserList extends LightningElement {
    @api recordId;
    @api role;

    @wire(getAvailableUsersByRole, {projectId: '$recordId',role:'$role'})
    users

    columns = [
        { label: 'First Name', fieldName: 'FirstName'},
        { label: 'Last Name', fieldName: 'LastName'},
        { 
            label: 'Start Date', 
            fieldName: 'Start_Date__c', 
            editable: true, 
            type: 'date', 
            typeAttributes: {year: "numeric",month: "2-digit",day: "2-digit"}
        },
        { 
            label: 'End Date', 
            fieldName: 'End_Date__c', 
            editable: true, type: 'date', 
            typeAttributes: {year: "numeric",month: "2-digit",day: "2-digit"} 
        },
    ];

    @api selectRowsData(){
        const dataUserRows= this.template.querySelector('lightning-datatable').getSelectedRows()
        return JSON.parse(JSON.stringify(dataUserRows))
    }

}