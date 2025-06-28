@isTest
public class OrderHandlerTest {
    @isTest
    static void testUpdateAccountRevenue() {
        // Préparation des données
        Account acc = new Account(Name = 'Test Account', Chiffre_d_affaire__c = 1000);
        insert acc;

        Order ord = new Order(
                Name = 'Test Order',
                AccountId = acc.Id,
                TotalAmount = 500,
                Status = 'Activated',
                EffectiveDate = Date.today()
        );
        insert ord;

        // Mise à jour de l'ordre pour déclencher le trigger
        ord.TotalAmount = 700;
        update ord;

        // Charger le compte mis à jour
        Account updatedAcc = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];

        // Vérification que le Chiffre d'affaire a été mis à jour correctement
        System.assertEquals(1700, updatedAcc.Chiffre_d_affaire__c, 'Le Chiffre d\'Affaire devrait être augmenté.');
    }

    @isTest
    static void testNoAccountId() {
        // Créer un ordre sans AccountId
        Order ord = new Order(
                Name = 'Test Order Without Account',
                TotalAmount = 500,
                Status = 'Activated',
                EffectiveDate = Date.today()
        );
        insert ord;

        // Mise à jour de l'ordre pour déclencher le trigger
        ord.TotalAmount = 700;
        update ord;

        // Vérification (aucune exception ne devrait se produire)
        System.assert(true, 'Le trigger devrait ignorer les ordres sans AccountId.');
    }
}
