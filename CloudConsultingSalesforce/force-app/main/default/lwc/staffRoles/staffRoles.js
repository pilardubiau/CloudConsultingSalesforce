import { LightningElement, api } from 'lwc';


export default class LightningExampleAccordionMultiple extends LightningElement {
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

    usersByRole= [
        {
            users:[{name:'Rodrigo Cadiz'}, {name: 'Leonardo Campoy'}],
            detail:{role : 'Desarrollador'}
        },
        {
            users: [{name: 'Pilar Dubiau'}],
            detail: {role: 'Arquitecto'}
        },
        {
            users: [{name: 'Hernan Langer'}],
            detail: {role: 'Consultor'}
        }
    ]
}

