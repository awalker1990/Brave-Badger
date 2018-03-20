public class FileClaimExtension {

    public Contact c            {get;set;}
    public Claim__c claim       {get;set;}
    public Claim__c fullClaim   {get;set;}
    public Boolean startAgain;


    //Initialise the constructor
    public FileClaimExtension() {
        this.c = new Contact();
        this.claim = new Claim__c();

        }


        public PageReference step1() {
            system.debug('url --> ' + ApexPages.CurrentPage().GetURL());
            if(ApexPages.CurrentPage().GetURL().StartsWith('/apex/FileClaim') || startAgain == true)  {
                processContact();
                startAgain = false;
            } else {
                claim = new Claim__c();
            }
            return Page.ClaimDetails;
        }

        public PageReference step2() {

            processClaim();

                if(c.Email != null) {
                    sendEmail();
                }
            
            return Page.ClaimSummary;
        }

        public PageReference startAgain(){
            c = new Contact();
            claim = new Claim__c();
            fullClaim = new Claim__c();
            startAgain = true;
            return page.FileClaim;
        }


        public void processContact() {
            Account a = [SELECT Id FROM Account WHERE Name = 'United Airlines' LIMIT 1];
            c.AccountId = a.Id;
            
            try{
               insert c;
               system.debug('Contact has just been inserted --> ' + c);
                ApexPages.message success = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Records Saved');
                ApexPages.addmessage(success);

            } catch (dmlException e) {
                
                ApexPages.message err = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() );
                ApexPages.addmessage(err);
            }
            
        }

        public void processClaim() {
            system.debug('contact --> ' + c);
        
                claim.contact__c = c.Id;

                try {
                    insert claim;
                    system.debug('is the claim being inserted here --> ' + claim);
                    ApexPages.message claimSuccess = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Claim Created');
                    ApexPages.addmessage(claimSuccess);

                    //Query record again for Name which is an auto-number
                    fullClaim = [SELECT Id, Name, reason__c, type__c, Status__c FROM Claim__c WHERE Id = :claim.Id];
                    system.debug('Claim inside processClaim --> ' + claim);

                } catch (dmlException e) {
                    system.debug('is the claim being caught --> ' + claim);
                
                ApexPages.message claimErr = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() );
                ApexPages.addmessage(claimErr);
            }


        }

        public void sendEmail() {
            List<String> toAddresses = new List<String>();
            toAddresses.add(c.email);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSubject('Summary of your Claim: ' + claim.name );
            mail.setPlainTextBody('Your Claim: ' + fullClaim.Name + 'Has been registered. We will be in touch soon');
            mail.setHtmlBody('Your Claim:<b> ' + fullClaim.Name + ' </b>has been created.<p>'+
                'To view your case <a href=https://brave-badger-453409-dev-ed.my.salesforce.com/'+fullClaim.Id+'>click here.</a>' +
                'Reason: ' + fullClaim.reason__c +
                'Type: ' + fullClaim.type__c +
                'Status ' + fullClaim.Status__c);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }



}