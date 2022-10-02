trigger AccountTrigger on Account (after insert, after update) {

    AccountTriggerHandler accHandlerClass = new AccountTriggerHandler();
    
    if(Trigger.isInsert  && Trigger.isAfter ){
    
    accHandlerClass.afterInsertMethod(Trigger.new);
    
    }
        
    if(Trigger.isUpdate && Trigger.isAfter){
    
    accHandlerClass.afterUpdateMethod(Trigger.new, Trigger.newMap);
    
    }    
        
 
    
}