@isTest(SeeAllData=false)
public class TestApexTriggerHandler {
    @testSetup static void InitializeTestData() {
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<3;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i, type='Prospect',phone='123-123-1234'));
        }
        insert testAccts;
   }
    
   @isTest private static void testAfterInsertMethod(){
       List<Account> insertListAccts = new List<Account>();
       for(Integer i=0;i<3;i++) {
           insertListAccts.add(new Account(Name = 'TestAcctIns'+i, type='Prospect'));
       }
       Test.startTest();
       insert insertListAccts;
       Test.stopTest();
       List<Account> acc =[select id from Account where name='testAcctIns0'];
       System.assertEquals(1,acc.size());
   }
    
    
   @isTest private static void testafterUpdateMethod(){
     List<Account> testAccts = new List<Account>();
     
     List<Account>    acct = [SELECT id,Phone  FROM Account WHERE Name='TestAcct0' LIMIT 1]; 
       List<Opportunity> oppList = new List<Opportunity>();
       for(Account a:acct){
            Opportunity opp = new Opportunity(name='Default Residential', accountid=a.id,closedate=Date.today(), stageName='Prospective');
           oppList.add(opp); 
            opp =new Opportunity(name='Default Commercial', accountid=a.id,closedate=Date.today(), stageName='Prospective');
            oppList.add(opp);
        }
        insert oppList;
        acct[0].phone='123-123-1234';
        Test.startTest();
        update acct;
        Test.stopTest();
        List<Account> acPh =[SELECT id,Phone  FROM Account WHERE Name='TestAcct0' LIMIT 1];
         System.assertEquals('123-123-1234',acPh[0].phone);
    }

    @isTest private static void testafterUpdateMethod2(){
        System.debug('testafterUpdateMethod2');
      
        Account   acct = [SELECT id,Phone  FROM Account WHERE Name='TestAcct0' LIMIT 1];
       
        List<Opportunity> opps =[select id from Opportunity where accountid=:acct.id] ;
        delete opps;
        System.debug('testafterUpdateMethod2'+ acct);
        acct.phone='123-123-1234';
        Test.startTest();
        update acct;
        Test.stopTest();
        List<Account> acPh =[SELECT id,Phone  FROM Account WHERE Name='TestAcct0' LIMIT 1];
        System.assertEquals('123-123-1234',acPh[0].phone);
    }
    

}