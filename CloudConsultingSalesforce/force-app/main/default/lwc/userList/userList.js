import { LightningElement, api, wire } from 'lwc';
import getAvailableUsers from '@salesforce/apex/ProjectClass.getAvailableUsers'
import createProjectStaff from '@salesforce/apex/ProjectClass.createProjectStaff'
import HoursToAssign from '@salesforce/apex/HoursToAssign.totalHours'
import {refreshApex} from '@salesforce/apex';
import {ShowToastEvent} from 'lightning/platformShowToastEvent'

const SUCCESS_TITLE = 'Success';
const MESSAGE_SHIP_IT = 'Staff successfully added to your Project!';
const SUCCESS_VARIANT = 'success';

export default class UserList extends LightningElement {
    @api recordId;
    @api lineItem;
    @api startDate;
    @api endDate;
    usersList;
    getUsers;
    usersSelectedId;
    isLoading = false
    
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

    draftUsersFilter(usersDraft){
        const usersToAdd = usersDraft.filter((u)=> this.usersSelectedId.includes(u.Id))
        return usersToAdd;
    }

    handleSelected(event){
        const usersSelected = JSON.parse(JSON.stringify(event.detail.selectedRows));
        const draftId = []
        usersSelected.forEach(user => {
            console.log(user)
            draftId.push(user.Id)
        });
        this.usersSelectedId = draftId;
    }

    handleSave(event){
        this.isLoading = true;
        const u = JSON.parse(JSON.stringify(event.detail.draftValues))
        const users = this.draftUsersFilter(u)
        console.log(users)
        createProjectStaff({usersToAdd: users, projectId: this.recordId})
        .then(()=>{
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
        .finally(()=>{
            this.isLoading = false;
            this.template.querySelector("lightning-datatable").draftValues = []; 
        })
    }

    columns = [
        { label: 'Role', fieldName: 'Role', sorteable: true},
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
            typeAttributes: {year: "numeric",month: "2-digit",day: "2-digit"} ,
        },
        /*{ 
            label: 'Assigned Hours', 
            fieldName: 'Hours_Assigned__c', 
        },*/

    ];

    /*@wire(HoursToAssign, {startDate: '$startDate', endDate: '$endDate'})
    hoursToAssign(data, error){
        if(data){
            console.log(data)
        }
    }*/
}