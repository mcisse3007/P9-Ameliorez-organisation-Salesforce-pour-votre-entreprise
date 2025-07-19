global class UpdateAccountBatchJob implements Database.Batchable<sObject>{
    
    // Query initial pour trouver les commandes non validées
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT AccountId, TotalAmount ' +
                        'FROM Order ' +
                        'WHERE Status = \'Activated\''
        );
    }

    // Traite les commandes par lot
    global void execute(Database.BatchableContext bc, List<Order> orders) {
       

        List<Account> accountsToUpdate = new List<Account>();
        Set<Id> accountIdSet = new Set<Id>();

        for(Order order: orders){
            accountIdSet.add(order.AccountId);
        }

        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIdSet]);
        
        for (Order order : orders) {
            if (order.TotalAmount != 0) {
                Account acc = accMap.get(order.AccountId);
                acc.Chiffre_d_affaire__c += order.TotalAmount;
                if(accountsToUpdate.contains(acc)){
                    accountsToUpdate.remove(accountsToUpdate.indexOf(acc));
                }
                accountsToUpdate.add(acc);
            }
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