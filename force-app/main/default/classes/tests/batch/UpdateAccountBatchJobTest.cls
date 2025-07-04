@isTest
private class UpdateAccountBatchJobTest {

    @isTest
    static void testBatch() {
        // Création de comptes
        List<Account> accounts = TestDataFactory.createMultipleAccounts(2);
        Account acc1 = accounts[0];
        Account acc2 = accounts[1];

        // Création d'un produit et d'une entrée Pricebook
        Product2 product = TestDataFactory.createProduct('Test Product');
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(product, 100);

        // Création de commandes liées aux comptes
        // Création de commandes en statut "Draft" pour les comptes
        List<Order> orders = new List<Order>{
            new Order(AccountId = acc1.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pbe.Pricebook2Id),
            new Order(AccountId = acc2.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pbe.Pricebook2Id),
            new Order(AccountId = acc1.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pbe.Pricebook2Id),
            new Order(AccountId = acc2.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pbe.Pricebook2Id),
            new Order(AccountId = acc1.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pbe.Pricebook2Id)
        };
        insert orders;

        // Ajout d'OrderItems avec quantités et prix unitaires personnalisés
        List<OrderItem> items = new List<OrderItem>{
            new OrderItem(OrderId = orders[0].Id, PricebookEntryId = pbe.Id, Quantity = 2, UnitPrice = 150),
            new OrderItem(OrderId = orders[1].Id, PricebookEntryId = pbe.Id, Quantity = 3, UnitPrice = 200),
            new OrderItem(OrderId = orders[2].Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100),
            new OrderItem(OrderId = orders[3].Id, PricebookEntryId = pbe.Id, Quantity = 4, UnitPrice = 50),
            new OrderItem(OrderId = orders[4].Id, PricebookEntryId = pbe.Id, Quantity = 5, UnitPrice = 25)
        };
        insert items;
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