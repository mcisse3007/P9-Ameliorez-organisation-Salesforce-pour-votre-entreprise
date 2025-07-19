public with sharing class AccountTotalOrderController {
    
    // TODO - Corriger l'erreur ici, nous retournons le montant TOTAL de tous les "Orders" 
    // mais nous souhaitons retourner le montant TOTAL des orders  aux status = 'Activated' du compte sur lequel le composant LWC se situe
    @AuraEnabled(cacheable = true)
    public static Decimal getSumOrdersByAccount(Id accountId) {
         if (!Schema.sObjectType.Order.fields.Status.isAccessible() || 
         !Schema.sObjectType.Order.fields.AccountId.isAccessible() ) {
            throw new AuraHandledException('Vous ne pouvez pas acceder aux commandes');
        }
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order where Status = 'Activated' and AccountId=:accountId];
        return (Decimal)groupedResults.get('total');
    }

}