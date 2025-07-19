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
private class AccountTotalOrderControllerTest {

      /**
     * This class tests the `getSumOrdersByAccount` method in the `AccountTotalOrderController` class.
     * <p>
     * Method:
     * - `getSumOrdersByAccount(Id accountId)`: Retrieves the sum of all activated orders
     * linked to a specific account. Throws an exception if access to Order fields is restricted.
     */

    @isTest
    static void testGetSumOrdersByAccount_WithValidAccountAndOrders() {
        List<Account> accounts = TestDataFactory.createMultipleAccounts(2);
        Account acc1 = accounts[0];
        Account acc2 = accounts[1];

        TestDataFactory.createOrdersAddItemsAndActivate(acc1, acc2);
        Decimal expected1 = (2 * 150) + (1 * 100) + (5 * 25);
        // Act: Invoke the method
        Decimal totalOrderSumAcc1 = AccountTotalOrderController.getSumOrdersByAccount(acc1.Id);

        // Assert: Validate the results
        System.assertEquals(expected1, totalOrderSumAcc1, 'The sum of orders should be 300.00');
    }

    @isTest
    static void testGetSumOrdersByAccount_WithNoOrders() {
        // Arrange: Create a test Account with no Orders
        Account testAccount = new Account(Name = 'Test Account No Orders', TypeClient__c='Particulier');
        insert testAccount;

        // Act: Invoke the method
        Decimal totalOrderSum = AccountTotalOrderController.getSumOrdersByAccount(testAccount.Id);

        // Assert: Validate the results
        System.assertEquals(null, totalOrderSum, 'The sum of orders should be null for an account with no orders');
    }
}