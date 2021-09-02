import { LightningElement, api } from 'lwc';

export default class ContainerStaffAlocation extends LightningElement {

 @api recordId

 connectedCallback(){console.log(this.recordId)}

}