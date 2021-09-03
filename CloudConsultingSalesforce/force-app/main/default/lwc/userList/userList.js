import { LightningElement, api } from 'lwc';


export default class UserDetail1 extends LightningElement {
    @api recordId;
    @api role;
    
    usersList;
    columns = [
        { label: 'Name', fieldName: 'name'},
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