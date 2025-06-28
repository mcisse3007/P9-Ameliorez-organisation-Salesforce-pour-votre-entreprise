@isTest
private class UpdateAccountBatchJobTest {

    @isTest
    static void testBatch() {
        // Création de comptes
        Account acc1 = new Account(Name = 'Entreprise 1');
        Account acc2 = new Account(Name = 'Entreprise 2');
        insert new List<Account>{acc1, acc2};
        
        // Création de commandes liées aux comptes
        Order order1 = new Order(
            AccountId = acc1.Id,
            TotalAmount = 500,
            Status = 'En attente'
        );
        
        Order order2 = new Order(
            AccountId = acc1.Id,
            TotalAmount = 300,
            Status = 'En attente'
        );
        
        Order order3 = new Order(
            AccountId = acc2.Id,
            TotalAmount = 200,
            Status = 'En attente'
        );
        
        Order order4 = new Order(
            AccountId = acc2.Id,
            TotalAmount = 150,
            Status = 'Validé' // Cette commande ne doit pas être prise en compte
        );
        
        insert new List<Order>{order1, order2, order3, order4};
        
        // Exécution du batch
        UpdateAccountBatchJob batch = new UpdateAccountBatchJob();
        Database.executeBatch(batch);
        
        // Vérification des résultats
        Account updatedAcc1 = [SELECT AnnualRevenue FROM Account WHERE Id = :acc1.Id];
        Account updatedAcc2 = [SELECT AnnualRevenue FROM Account WHERE Id = :acc2.Id];

        System.assertEquals(800, updatedAcc1.AnnualRevenue); // 500 + 300
        System.assertEquals(200, updatedAcc2.AnnualRevenue); // 200 uniquement
    }

}