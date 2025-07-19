@isTest
private class UpdateAccountBatchJobTest {

    @isTest
    static void testBatch() {
        // Création de comptes
        List<Account> accounts = TestDataFactory.createMultipleAccounts(3);
        Account acc1 = accounts[0];
        Account acc2 = accounts[1];
        Account acc3 = accounts[2];

        TestDataFactory.createOrdersAddItemsAndActivate(acc1, acc2, acc3);

        // Exécution du batch
        UpdateAccountBatchJob batch = new UpdateAccountBatchJob();
        Database.executeBatch(batch);
        
        // Vérification des résultats
        // Récupération des comptes mis à jour
        Account updatedAcc1 = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        Account updatedAcc2 = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc2.Id];

        // Calcul attendu du chiffre d'affaires par compte
        Decimal expected1 = (2 * 150) + (1 * 100) + (5 * 25); // 300 + 100 + 125 = 525
        Decimal expected2 = (3 * 200) + (4 * 50);             // 600 + 200 = 800

        // Vérification que les valeurs correspondent aux montants attendus
        System.assertEquals(expected1, updatedAcc1.Chiffre_d_affaire__c, 'Chiffre d’affaires incorrect pour acc1');
        System.assertEquals(expected2, updatedAcc2.Chiffre_d_affaire__c, 'Chiffre d’affaires incorrect pour acc2');
    }

}