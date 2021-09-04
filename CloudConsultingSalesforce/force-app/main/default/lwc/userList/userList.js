import { LightningElement, api, wire } from 'lwc';
import getAvailableUsers from '@salesforce/apex/ProjectClass.getAvailableUsers'
import createProjectStaff from '@salesforce/apex/ProjectClass.createProjectStaff'
import {refreshApex} from '@salesforce/apex';
import {ShowToastEvent} from 'lightning/platformShowToastEvent'

const SUCCESS_TITLE = 'Success';
const MESSAGE_SHIP_IT     = 'Staff successfully added to your Project!';
const SUCCESS_VARIANT     = 'success';

export default class UserList extends LightningElement {
    @api recordId;
    @api lineItem;
    usersList;
    getUsers;
    
    @wire(getAvailableUsers, {projectId: '$recordId'})
    users(result){
        this.getUsers = result
        if(result.data){
            this.usersList = [];
            for(let i=0; i<result.data.length; i++){
                this.usersList.push({...result.data[i], Role: result.data[i].UserRole.Name});
            }
        }
    }

    handleSave(event){
        const users = event.detail.draftValues
        createProjectStaff({usersToAdd: users, projectId: this.recordId})
        .then(()=>{
            console.log('Todo viento');
            this.dispatchEvent(new ShowToastEvent({
                title: SUCCESS_TITLE,
                message: MESSAGE_SHIP_IT,
                variant: SUCCESS_VARIANT
            }))
            this.dispatchEvent(new CustomEvent('assign'))
            return refreshApex(this.getUsers);
        })
        .catch((error)=>{
            console.log(error);
        })
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
}