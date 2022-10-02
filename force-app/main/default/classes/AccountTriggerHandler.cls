/*
Handler class for Account Trigger
Methods:
public void afterInsertMethod(List <Account> newAccounts)
public void afterUpdateMethod(List <Account> newAccounts, Map<id, sObject> newMap)
public void sendEmailAlert(String emailId)
private void logException(Exception e, String methodName, String className)
*/
public class AccountTriggerHandler {   
     private String className='AccountTriggerHandler';
     list<Opportunity> listOpp = new list<Opportunity>();
     list<Opportunity> listOppRes = new list<Opportunity>();
     list<Opportunity> listOppComm = new list<Opportunity>();
     Set<Id> set_accountId = new Set<Id>(); 

public void afterInsertMethod(List <Account> newAccounts){
 String methodName='afterInsertMethod';
    Try{       
    for(Account acc:newAccounts){
               
                  //Create opp 1
                    Opportunity resOpp = new Opportunity();
                    resOpp.name='Default Residential';
                    resOpp.AccountId =acc.id;
                    resOpp.closeDate=Date.today()+60;
                    resOpp.StageName='Prospective';
                    listOpp.add(resOpp); 
                  //Create opp 2
                    Opportunity commOpp = new Opportunity();
                    commOpp.name='Default Commercial';
                    commOpp.AccountId =acc.id;
                    commOpp.closeDate=Date.today()+60;
                    commOpp.StageName='Prospective';
                    listOpp.add(commOpp); 
                }
    
    insert listOpp;
    }catch(Exception e){
        logException(e,methodName, className);
    }

}

public void afterUpdateMethod(List <Account> newAccounts, Map<id, sObject> newMap){
String methodName='afterUpdateMethod';
    Try{
    set_accountId = newMap.keySet(); 

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
        if ('Prospect'.contains(acc.Type)){
            if(mpRes.get(acc.id)==null){
                //No Residentials Opp found 
                //Create new Opp to replace old one
                Opportunity resOpp = new Opportunity();
                    resOpp.name='Default Residential';
                    resOpp.AccountId =acc.id;
                    resOpp.closeDate=Date.today()+60;
                    resOpp.StageName='Prospective';
                    listOpp.add(resOpp); 
                
                sendEmailAlert=true;
            }
            
            if(mpComm.get(acc.id)==null){
                //No Commercial opp found 
                //Create new Opp to replace old one
                 Opportunity commOpp = new Opportunity();
                    commOpp.name='Default Commercial';
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
    }catch(Exception e){
		 logException(e,methodName, className);
    }
}
    
public void sendEmailAlert(String emailId){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.toAddresses = new String[] { emailId };
                email.setSubject('Child Opportunities were Altered/Deleted');
                email.setPlainTextBody('The Default Opportunities linked to this account was alered or deleted');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
}  
    
private void logException(Exception e, String methodName, String className){
        SJ_Error_Log__c exc = new SJ_Error_Log__c();
        exc.Exception_Message__c	=e.getMessage();
        exc.Method_Name__c=methodName;
        exc.Line_Number__c =e.getLineNumber();
        exc.Stack_Trace__c=e.getStackTraceString();
        exc.Class_Name__c =className;
        insert exc;
}

}