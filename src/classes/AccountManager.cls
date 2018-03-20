@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {
    
	@HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        // grab the accountId from the Middle of the URL
        String accId = request.requestURI.substringBetween('/Accounts/', '/contacts');
        system.debug('Account ID from url --> ' + accId);
        
        Account results = [Select Id, Name, (Select Id, Name from Contacts) from Account where Id = :accId];
        system.debug('heres the account with contacts ' + results);
        return results;
    }

}