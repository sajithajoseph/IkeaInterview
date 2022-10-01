@isTest(SeeAllData=false)
public class TestApexTriggerHandler {
    
    @testSetup static void InitializeTestData() {
         List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<3;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i, type='Prospective',phone='1231231234'));
        }
        insert testAccts;
        

}
    
    @isTest private static void testafterInsertMethod(){
         List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<3;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i, type='Prospective'));
        }
        Test.startTest();
      insert testAccts;
        Test.stopTest();
    }
   @isTest private static void testafterUpdateMethod(){

       List<Account>   acct = [SELECT id,Phone  FROM Account WHERE Name='TestAcct0' LIMIT 1];
       List<Opportunity> oppList = new List<Opportunity>();
       for(Account a:acct){
            Opportunity opp = new Opportunity(name='Default Residential', accountid=a.id,closedate=Date.today(), stageName='Prospective');
           oppList.add(opp); 
            opp =new Opportunity(name='Default Commercial', accountid=a.id,closedate=Date.today(), stageName='Prospective');
            oppList.add(opp);
        }
        insert oppList;
      
       acct[0].phone='1231231234';
        Test.startTest();
        update acct;
        Test.stopTest();
    }

    @isTest private static void testafterUpdateMethod2(){
        Account acct = [SELECT id,Phone  FROM Account WHERE Name='TestAcct0' LIMIT 1];
       acct.phone='1231231234';
        Test.startTest();
        update acct;
        Test.stopTest();
    }
}