public with sharing class OpportunityProductsExtension {

	public Opportunity opp;
    public List<WrapperLineItems> oppProductList    {get;set;}
    public Boolean showMessage {get;set;}

    //Constructor
    public OpportunityProductsExtension(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
        showMessage = false;
    }

    public List<WrapperLineItems> getOpportunityProducts() {
        if(oppProductList == null ) {
            oppProductList = new List<WrapperLineItems>();
                for(OpportunityLineItem line : [SELECT Product2.Name, Quantity, UnitPrice, PricebookEntry.Product2Id FROM OpportunityLineItem WHERE OpportunityId = :opp.Id] ) {
                        oppProductList.add(new WrapperLineItems(line) );
                }       
        }
        return oppProductList;
    }

    public pageReference addLineItem() {
        
        OpportunityLineItem line = new OpportunityLineItem(OpportunityId = opp.Id);
        oppProductList.add(new WrapperLineItems(line));
        return null;
    }

    //Method to auto-calculate the price if the opportunity line item is null. It gets the selected products then queries for PricebookEntries and uses the unit price by default
    public void calculatePrice() {

        List<Id> newSelectedProducts = new List<Id>();
        Map<Id, PricebookEntry> myMap = new Map<Id, PricebookEntry>();

        //Get the Opportunity Pricebook
        Opportunity myOpp = [SELECT Pricebook2Id FROM Opportunity WHERE Id = :opp.Id];

        //Get a list of new selected prodcuts and add them to a list
        for(WrapperLineItems w : oppProductList) {
            if(w.oppLine.UnitPrice == null && w.pbe.Product2Id != null) {
                newSelectedProducts.add(w.pbe.Product2Id);
                system.debug('heres your product added to list --> ' + w.pbe.Product2Id);
            }
        }
        
        //Query Pricebook Entries for prices
        List<PricebookEntry> prices = [SELECT Id, UnitPrice, PriceBook2Id, Product2Id FROM PricebookEntry WHERE Product2Id = :newSelectedProducts AND Pricebook2Id = :myOpp.PriceBook2Id];
        system.debug('Heres your Pricebook Entry -->' + prices);

        for(PricebookEntry pr : prices) {
            myMap.put(pr.Product2Id, pr);
        }
        system.debug('heres your map --> ' + myMap);

        //Now Iterate through the wrapper class again and update the prices
        for(WrapperLineItems line : oppProductList) {
            if(line.oppLine.UnitPrice == null && line.pbe.Product2Id != null) {
                if( myMap.ContainsKey(line.pbe.product2Id) ) {
                    line.oppLine.UnitPrice = myMap.get(line.pbe.product2Id).UnitPrice;
                    line.oppLine.PricebookEntryId = myMap.get(line.pbe.Product2Id).Id;
                    system.debug('heres your new wrapper line --> ' + line);
                }
            }
        }
    }

    public PageReference deleteOppLines() {

        List<OpportunityLineItem> selectedLineItems = new List<OpportunityLineItem>();
        
            //iterate over the list of contacts and see which ones are selected        
            for(WrapperLineItems item : oppProductList ) {
                if(item.selected == true && item.oppLine.Id != null) {
                selectedLineItems.add(item.oppLine); 
                item = null;
            }
            system.debug('list of line items marked for delete --> ' + selectedLineItems);
        }
        try {
            delete selectedLineItems;
            showMessage = true;
            ApexPages.Message successMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Selected Line Items Deleted');
            ApexPages.addmessage(successMsg);
        } catch (dmlException e) {      
            }
        system.debug('current --> ' + oppProductList);
        oppProductList = null;
        getOpportunityProducts();
        return null;
    }

    public Pagereference saveChanges() {

        List<OpportunityLineItem> upsertItems = new List<OpportunityLineItem>();

        system.debug('wrapper class before save --> ' + oppProductList);

        for(WrapperLineItems item : oppProductList) {
            system.debug('individual opp line --> ' + item.oppLine);
                upsertItems.add(item.oppLine);
            
        }
        oppProductList = null;
        getOpportunityProducts();
        return null;
    }


    //Wrapper Class for table in VF page, Contains the Opportunity Products list and some checkboxes
    public class WrapperLineItems {
        
        public Boolean selected                     {get; set;}
        public OpportunityLineItem oppLine          {get; set;}
        public PriceBookEntry pbe                   {get;set;}
        
        public WrapperLineItems(OpportunityLineItem oli) {
            oppLine = oli;
            selected = false;
            pbe = new PriceBookEntry( product2Id = oli.PricebookEntry.Product2Id );
        }
    }

}