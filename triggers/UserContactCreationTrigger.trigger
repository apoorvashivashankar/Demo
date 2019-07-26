trigger UserContactCreationTrigger on User (after insert) {
    static UserContactUtility con;
    con = new UserContactUtility();
    con .hateThisController();
}