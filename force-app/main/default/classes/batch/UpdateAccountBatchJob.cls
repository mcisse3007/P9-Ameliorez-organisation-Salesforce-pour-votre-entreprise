global class UpdateAccountBatchJob implements Database.Batchable<sObject>{
    
    / Query initial pour trouver les commandes non validées
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT AccountId, TotalAmount ' +
                        'FROM Order ' +
                        'WHERE Status != \'Activated\' AND AccountId != null'
        );
    }

    // Traite les commandes par lot
    global void execute(Database.BatchableContext bc, List<Order> orders) {
        // Map pour regrouper les montants par compte
        Map<Id, Decimal> accountRevenueMap = new Map<Id, Decimal>();

        for (Order order : orders) {
            if (order.AccountId != null && order.TotalAmount != null) {
                // Ajoute le montant au compte correspondant
                if (!accountRevenueMap.containsKey(order.AccountId)) {
                    accountRevenueMap.put(order.AccountId, order.TotalAmount);
                } else {
                    accountRevenueMap.put(order.AccountId, accountRevenueMap.get(order.AccountId) + order.TotalAmount);
                }
            }
        }

        // Liste des comptes à mettre à jour
        List<Account> accountsToUpdate = new List<Account>();

        for (Id accountId : accountRevenueMap.keySet()) {
            accountsToUpdate.add(new Account(
                    Id = accountId,
                    AnnualRevenue = accountRevenueMap.get(accountId)
            ));
        }

        // Mise à jour des comptes
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    // Fin du batch
    global void finish(Database.BatchableContext bc) {
        // Envoi d'une notification ou log si nécessaire
        System.debug('Batch terminé : Chiffre d\'affaires des comptes mis à jour.');
    }

}