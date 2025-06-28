trigger UpdateAccountCA on Order (after update) {
    OrderHandler.updateAccountRevenue(Trigger.new);
}
