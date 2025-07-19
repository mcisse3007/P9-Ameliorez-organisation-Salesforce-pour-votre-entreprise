public with sharing class TestDataFactory {

    // Méthode pour créer un compte de test 
    public static Account createAccount(String accountName) {
        Account account = new Account(
            Name = accountName,
            TypeClient__c='Particulier'
        );  
        try {
            insert account;
        } catch (DmlException e) {
            System.debug('Erreur lors de l\'insertion du compte: ' + e.getMessage());
            throw e;
        }
        return account;
    }

    // Méthode pour créer un produit de test
    public static Product2 createProduct(String productName) {
        Product2 product = new Product2(
            Name = productName,
            IsActive = true
        );
        try {
            insert product;
        } catch (DmlException e) {
            System.debug('Erreur lors de l\'insertion du produit: ' + e.getMessage());
            throw e;
        }
        return product;
    }

    // Méthode pour créer une entrée de Pricebook de test
    public static PricebookEntry createPricebookEntry(Product2 product, Decimal unitPrice) {
        Id standardPbId = Test.getStandardPricebookId();
        PricebookEntry priceEntry = new PricebookEntry(
            Product2Id = product.Id,
            Pricebook2Id = standardPbId,
            UnitPrice = unitPrice,
            IsActive = true,
            UseStandardPrice = false
        );
        try {
            insert priceEntry;
        } catch (DmlException e) {
            System.debug('Erreur lors de l\'insertion de PricebookEntry: ' + e.getMessage());
            throw e;
        }
        return priceEntry;
    }

    // Méthode pour créer une commande de test
    public static Order createOrder(Account account, PricebookEntry priceEntry) {
        Order order = new Order(
            AccountId = account.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = priceEntry.Pricebook2Id,
            ShipmentCost__c=620
        );
        try {
            insert order;
        } catch (DmlException e) {
            System.debug('Erreur lors de l\'insertion de la commande: ' + e.getMessage());
            throw e;
        }

        // Ajouter une ligne de commande
        OrderItem orderItem = new OrderItem(
            OrderId = order.Id,
            PricebookEntryId = priceEntry.Id,
            Quantity = 1,
            UnitPrice = priceEntry.UnitPrice
            
        );
        try {
            insert orderItem;
        } catch (DmlException e) {
            System.debug('Erreur lors de l\'insertion de la ligne de commande: ' + e.getMessage());
            throw e;
        }

        return order;
    }

    

    // Méthode pour initialiser plusieurs comptes pour un test
    public static List<Account> createMultipleAccounts(Integer numberOfAccounts) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account account = new Account(
                Name = 'Test Account ' + i,
               TypeClient__c='Particulier'

            );
            accounts.add(account);
        }
        //ajouter un controle d'acces des donnees
        insert accounts;
        return accounts;
    }

    // Méthode pour créer des commandes en masse
    public static List<Order> createBulkOrders(List<Account> accounts, PricebookEntry priceEntry) {
        List<Order> orders = new List<Order>();
        for (Account account : accounts) {
            Order order = new Order(
                AccountId = account.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                Pricebook2Id = priceEntry.Pricebook2Id
            );
            orders.add(order);
        }
        insert orders;

        // Ajouter des lignes de commande
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order order : orders) {
            OrderItem orderItem = new OrderItem(
                OrderId = order.Id,
                PricebookEntryId = priceEntry.Id,
                Quantity = 1,
                UnitPrice = priceEntry.UnitPrice
            );
            orderItems.add(orderItem);
        }
        insert orderItems;

        return orders;
    }

    public static void createOrdersAddItemsAndActivate(Account acc1, Account acc2, Account acc3) {
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
        
        // on ajoute 100 commandes a l'account 3
        for(Integer i=0; i<100; i++){
            orders.add(new Order(AccountId = acc3.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pbe.Pricebook2Id));
        }
        insert orders;

        

        // Ajout d'OrderItems avec quantités et prix unitaires personnalisés
        List<OrderItem> items = new List<OrderItem>{
            new OrderItem(OrderId = orders[0].Id, PricebookEntryId = pbe.Id, Quantity = 2, UnitPrice = 150),
            new OrderItem(OrderId = orders[1].Id, PricebookEntryId = pbe.Id, Quantity = 3, UnitPrice = 200),
            new OrderItem(OrderId = orders[2].Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100),
            new OrderItem(OrderId = orders[3].Id, PricebookEntryId = pbe.Id, Quantity = 4, UnitPrice = 50),
            new OrderItem(OrderId = orders[4].Id, PricebookEntryId = pbe.Id, Quantity = 5, UnitPrice = 25)
        };

        for(Integer i=0; i<100; i++){
            items.add(new OrderItem(OrderId = orders[i + 5].Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100));
        }
        insert items;

        for (Order order : orders) {
            order.Status = 'Activated';
        }
        update orders;
    }
}