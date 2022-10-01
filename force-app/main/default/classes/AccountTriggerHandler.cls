public class AccountTriggerHandler {   

     list<Opportunity> listOpp = new list<Opportunity>();
     list<Opportunity> listOppRes = new list<Opportunity>();
     list<Opportunity> listOppComm = new list<Opportunity>();
     Set<Id> set_accountId = new Set<Id>(); 

public void afterInsertMethod(List <Account> newAccounts){

   // if (trigger.isAfter){//on After Create
            for(Account acc:newAccounts){
               
                  //Create opp 1
                    Opportunity resOpp = new Opportunity();
                    resOpp.name='Default Residential';
                    resOpp.AccountId =acc.id;
                    resOpp.closeDate=Date.today()+60;
                    resOpp.StageName='Prospective';
                    listOpp.add(resOpp); 
                  //Create opp 
                    Opportunity commOpp = new Opportunity();
                    commOpp.name='Default Commercial';
                    commOpp.AccountId =acc.id;
                    commOpp.closeDate=Date.today()+60;
                    commOpp.StageName='Prospective';
                    listOpp.add(commOpp); 
                }
  //  }
    
    insert listOpp;

}

public void afterUpdateMethod(List <Account> newAccounts, List <Account> oldAccounts, Map<id, sObject> newMap,Map<id, sObject> oldMap){

//if ( trigger.isBefore){
    
    for(Account acc : newAccounts){
      set_accountId.add(acc.id);  
        
    }
    listOppRes = [select id, accountid,name from Opportunity where accountid in :set_accountId and name = 'Default Residential'];
    listOppComm = [select id,accountid,name from Opportunity where accountid in :set_accountId and name = 'Default Commercial'];
   
    Map<Id,Opportunity> mpRes = new Map<Id,Opportunity>();
    
    for (Opportunity oRes : listOppRes){
         mpRes.put(oRes.AccountId, oRes);
    }
    
    Map<Id,Opportunity> mpComm = new Map<Id,Opportunity>();
    
    for (Opportunity oComm : listOppComm){
         mpComm.put(oComm.AccountId, oComm);
    }
    
    for(Account acc:newAccounts){
        Boolean sendEmailAlert=false;
        if ('Prospective'.contains(acc.Type)){
            if(mpRes.get(acc.id)==null){
                //no REs opp found 
                //create opp
                Opportunity resOpp = new Opportunity();
                    resOpp.name='Default Residential Opportunity';
                    resOpp.AccountId =acc.id;
                    resOpp.closeDate=Date.today()+60;
                    resOpp.StageName='Prospective';
                    listOpp.add(resOpp); 
                //send email
                sendEmailAlert=true;
            }
            
            if(mpComm.get(acc.id)==null){
                //no Comm opp found 
                //create opp
                 Opportunity commOpp = new Opportunity();
                    commOpp.name='Default Commercial Opportunity';
                    commOpp.AccountId =acc.id;
                    commOpp.closeDate=Date.today()+60;
                    commOpp.StageName='Prospective';
                    listOpp.add(commOpp);
                sendEmailAlert =true;
            }
            
            if(sendEmailAlert){
               sendEmailAlert(acc.owner.email); 
            }
                
              
        }
    }   
    insert listOpp;
//}


}
    
    public void sendEmailAlert(String emailId){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.toAddresses = new String[] { emailId };
                email.setSubject('Child Opportunities were Altered/Deleted');
                email.setPlainTextBody('The Default Opportunities linked to this account was alered or deleted');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
    }    

}