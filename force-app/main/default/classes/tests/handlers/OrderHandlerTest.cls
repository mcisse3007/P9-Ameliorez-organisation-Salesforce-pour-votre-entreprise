@isTest
public class OrderHandlerTest {
    @isTest
    static void testUpdateAccountRevenue() {
        // Préparation des données
        Account acc = TestDataFactory.createAccount('testAccount');

        acc.Chiffre_d_affaire__c = 1000;
        update acc;

        Product2 product = TestDataFactory.createProduct('product');

        PricebookEntry priceEntry = TestDataFactory.createPricebookEntry(product, 700);

        Order ord = TestDataFactory.createOrder(acc, priceEntry);
        ord.Status = 'Activated';
        update ord;

        // Charger le compte mis à jour
        Account updatedAcc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];

        // Vérification que le Chiffre d'affaire a été mis à jour correctement
        System.assertEquals(1700, updatedAcc.Chiffre_d_affaire__c, 'Le Chiffre d\'Affaire devrait être augmenté.');
    }

    
}
