public class sendEmailPageController {

    public String toEmail {get;set;}
    public String subject {get;set;}
    public String body {get;set;}
    public Blob file {get;set;}
    public String fileName {get;set;}
    
    
    private final Lead MyLead;
    public sendEmailPageController(ApexPages.StandardController controller)
    
   
    {
        this.MyLead=(Lead)controller.getRecord();
    } 
              
    public void sendEmail() {
        
        //create a mail object to send email 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toaddress = (new String[]{toEmail});
        Id orgAddress = '0D20Y0000004DdXSAU';
        
        //File Attachment Properties
        Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
        fileAttachment.setFileName(fileName);
        fileAttachment.setBody(file);
        fileAttachment.setContentType('application/pdf');
        
        //email properties
     	Messaging.SingleEmailMessage emailContext = new Messaging.SingleEmailMessage ();
     	mail.setPlainTextBody (body);
        mail.setHtmlBody (body);
    	mail.setToAddresses (toaddress);
        mail.setOrgWideEmailAddressId (orgAddress);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {fileattachment});

     
        // send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }   
   }