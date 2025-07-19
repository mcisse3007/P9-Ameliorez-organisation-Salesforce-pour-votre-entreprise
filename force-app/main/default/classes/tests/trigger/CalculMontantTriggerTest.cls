/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CalculMontantTriggerTest {

      /**
     * Test case: Validate that NetAmount__c is calculated correctly
     * when TotalAmount and ShipmentCost__c are provided.
     */
    @isTest
    static void testNetAmountCalculation() {

        // Arrange
        Account acc = TestDataFactory.createAccount('testAccount');

        acc.Chiffre_d_affaire__c = 1000;
        update acc;

        Product2 product = TestDataFactory.createProduct('product');

        PricebookEntry priceEntry = TestDataFactory.createPricebookEntry(product, 700);

        Order ord = TestDataFactory.createOrder(acc, priceEntry);
        ord.Status = 'Activated';
        update ord;

        // Act
        ord = [SELECT TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :ord.Id];

        // Assert
        System.assertEquals(80.0, ord.NetAmount__c, 'NetAmount__c should be TotalAmount - ShipmentCost__c');
    }

    /**
     * Test case: Validate that NetAmount__c is set to null
     * when either TotalAmount or ShipmentCost__c is null.
     */
    @isTest
    static void testNetAmountNullWhenInputsNull() {
        // Arrange
        // Arrange
        Account acc = TestDataFactory.createAccount('testAccount');

        acc.Chiffre_d_affaire__c = 1000;
        update acc;

        Product2 product = TestDataFactory.createProduct('product');

        PricebookEntry priceEntry = TestDataFactory.createPricebookEntry(product, 700);

        Order ord = TestDataFactory.createOrder(acc, priceEntry);
        ord.ShipmentCost__c = null;
        update ord;

        // Act
        ord = [SELECT TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :ord.Id];

        // Assert
        System.assertEquals(null, ord.NetAmount__c, 'NetAmount__c should be null when inputs are null');
    }

    /**
     * Test case: Validate that NetAmount__c is set to null
     * when ShipmentCost__c is null, even if TotalAmount is provided.
     */
    @isTest
    static void testNetAmountNullWhenShipmentCostIsNull() {
        // Arrange
        Account acc = TestDataFactory.createAccount('testAccount');

        acc.Chiffre_d_affaire__c = 1000;
        update acc;

        Product2 product = TestDataFactory.createProduct('product');

        PricebookEntry priceEntry = TestDataFactory.createPricebookEntry(product, 700);

        Order ord = TestDataFactory.createOrder(acc, priceEntry);
        ord.NetAmount__c = null;
        ord.ShipmentCost__c=null;
        update ord;

        // Act
        ord = [SELECT TotalAmount, ShipmentCost__c, NetAmount__c FROM Order WHERE Id = :ord.Id];

        // Assert
        System.assertEquals(null, ord.NetAmount__c, 'NetAmount__c should be null when ShipmentCost__c is null');
    }

}