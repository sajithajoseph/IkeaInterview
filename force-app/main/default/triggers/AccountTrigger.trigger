trigger AccountTrigger on Account (before insert, after update) {

    AccountTriggerHandler accHandlerClass = new AccountTriggerHandler();

if(Trigger.isInsert ){
  //  if(Trigger.isInsert && trigger.isAfter){

accHandlerClass.afterInsertMethod(Trigger.new);

}
    
if(Trigger.isUpdate ){
  //  if(Trigger.isUpdate && trigger.isBefore){

accHandlerClass.afterUpdateMethod(Trigger.new, Trigger.Old, Trigger.newMap, Trigger.oldMap);

}    
    
      /*
 public static void sendSimpleEmail(List<String> recipientList, String subject, String emailBody){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(recipientList);
        email.setSubject(subject);
        email.setPlainTextBody(emailBody);
        email.setHtmlBody(emailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }

*/   
    
}