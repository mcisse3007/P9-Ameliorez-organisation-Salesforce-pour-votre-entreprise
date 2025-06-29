public with sharing class OrderHandler {
    public static void updateAccountRevenue(List<Order> updatedOrders) {
        // Collecter les AccountId
        Set<Id> accountIds = getAccountsId(updatedOrders);

        if (
                !Schema.sObjectType.Account.fields.Id.isAccessible() || 
                !Schema.sObjectType.Account.fields.Chiffre_d_affaire__c.isAccessible() 
                ) {
                    throw new AuraEnabledException('Vous ne pouvez pas acceder aux commandes');
                }
        // Récupérer les comptes associés
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>(
                [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds]
        );

        // Modifier les Chiffre_d_affaire
        for (Order newOrder : updatedOrders) {
            if (newOrder.AccountId != null && accountsToUpdate.containsKey(newOrder.AccountId) && newOrder.Status != 'Activated') {
                Account acc = accountsToUpdate.get(newOrder.AccountId);
                acc.Chiffre_d_affaire__c = (acc.Chiffre_d_affaire__c != null ? acc.Chiffre_d_affaire__c : 0) +
                        (newOrder.TotalAmount != null ? newOrder.TotalAmount : 0);
            }
        }

        // Mise à jour des comptes
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate.values();
        }
    }

    private static Set<Id> getAccountsId(List<Order> updatedOrders){
         Set<Id> accountIds = new Set<Id>();
        for (Order newOrder : updatedOrders) {
            if (newOrder.AccountId != null) {
                accountIds.add(newOrder.AccountId);
            }
        }
        return accountIds;
    }
}
