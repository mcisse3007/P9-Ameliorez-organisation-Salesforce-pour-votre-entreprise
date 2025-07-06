public with sharing class TestDataFactory {

    // Méthode pour créer un compte de test 
    public static Account createAccount(String accountName) {
        Account account = new Account(
            Name = accountName
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
            Pricebook2Id = priceEntry.Pricebook2Id
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
                Name = 'Test Account ' + i
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
}