import { LightningElement, api } from 'lwc';
import getSumOrders from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount'; // Import de la méthode Apex

export default class Orders extends LightningElement {
    @api recordId; // ID du compte (AccountId)
    sumOrdersOfCurrentAccount; // Montant total des commandes
    error; // Gestion des erreurs

    connectedCallback() {
        this.fetchSumOrders();
    }

    fetchSumOrders() {
        // Appel de la méthode Apex
        getSumOrdersByAccount({ accountId: this.recordId })
            .then((result) => {
                this.sumOrdersOfCurrentAccount = result; // Mise à jour de la valeur
                this.error = undefined; // Réinitialise l'erreur
            })
            .catch((error) => {
                // Stocke et affiche l'erreur si elle survient
                this.error = error;
                this.sumOrdersOfCurrentAccount = undefined;
            });
    }
}
