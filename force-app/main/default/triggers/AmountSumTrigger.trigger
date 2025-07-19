trigger AmountSumTrigger on Order (before update) {

	// Parcourt toutes les commandes dans l'opération de mise à jour
	for (Order newOrder : Trigger.new) {
		// Vérifie que les champs nécessaires ne sont pas null
		if (newOrder.TotalAmount != null && newOrder.ShipmentCost__c != null) {
			// Calcul de NetAmount
			newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
		} else {
			// Si l'un des champs est null, NetAmount__c reste null
			newOrder.NetAmount__c = null;
		}
	}

}