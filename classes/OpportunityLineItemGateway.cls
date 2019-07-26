public with sharing class OpportunityLineItemGateway {
    
    // makes a simple chatter text post to the specified user from the running user 
    public static List<Order_Tracking__c > newOrderTracking (Set<Id> setOppId) { 
        
        Boolean hasOasisQuoteNumber;
        Boolean hasSAPQuoteNumber;
        List <Order_Tracking__c> newOrderTracking = new List <Order_Tracking__c>();         
        System.debug('::::OpportunityLineItemGateway + setOppId: ' + setOppId);
        List<OpportunityLineItem> oList = [SELECT Id,
                                           OpportunityId, 
                                           Product2Id,
                                           Quantity,
                                           Description,
                                           Base_Unit_of_Measure__c,
                                           Oasis_Quote_Number__c,
                                           SAP_Order_Number__c,
                                           Shipment_Date__c,
                                           Shipment_Number__c,
                                           Carrier_Tracking_Number__c,
                                           Item_Status__c,
                                           CreatedById
                                           FROM OpportunityLineItem 
                                           WHERE Id IN :setOppId
                                           AND ( (Item_Status__c = 'Fulfilled' OR Item_Status__c = 'BackOrdered')
                                                OR (Item_Status__c = '' AND Carrier_Tracking_Number__c != ''))
                                          ];        
        System.debug('::::OpportunityLineItemGateway + oList: ' + oList);
        
        Map<String, List<OpportunityLineItem>> oasisQuoteToOpp = new Map<String, List<OpportunityLineItem>>(); 
        Map<String, List<OpportunityLineItem>> oppToOppLineItem = new Map<String, List<OpportunityLineItem>>(); 
        Map<String, List<OpportunityLineItem>> sapOrderNumToOpp = new Map<String, List<OpportunityLineItem>>(); 
        Map<String, List<OpportunityLineItem>> statusToOpp = new Map<String, List<OpportunityLineItem>>(); 
        Map<String, List<OpportunityLineItem>> oppLineItemToTracking = new Map<String, List<OpportunityLineItem>>();
        Set<String> setTrackingNumber= new Set<String>();
        List<String> listTrackingNumber= new List<String>();
        
        listTrackingNumber.addAll(setTrackingNumber);     
        
        for (OpportunityLineItem o: oList) {
            if (o.Oasis_Quote_Number__c != '' ) {
                hasOasisQuoteNumber = true;
            }
            if (o.SAP_Order_Number__c != '' ) {
                hasSAPQuoteNumber = true;
            }            
            List<OpportunityLineItem> opps = oasisQuoteToOpp.get(o.id);
            if (opps == null)
            {
                opps = new List<OpportunityLineItem>();
                oasisQuoteToOpp.put(o.Oasis_Quote_Number__c, opps);
                sapOrderNumToOpp.put(o.SAP_Order_Number__c, opps);               
                statusToOpp.put(o.Item_Status__c, opps);
                oppLineItemToTracking.put(o.Carrier_Tracking_Number__c, opps);
                oppToOppLineItem.put(o.OpportunityId, opps);
            }
            setTrackingNumber.add(o.Carrier_Tracking_Number__c);
            opps.add(o);
        }
        listTrackingNumber.addAll(setTrackingNumber);
        
        System.debug('::::OpportunityLineItemGateway + oList: ' + oList);
        System.debug('::::OpportunityLineItemGateway + listTrackingNumber: ' + listTrackingNumber);
        
        if ( hasOasisQuoteNumber == true || hasSAPQuoteNumber == true) {
            
            List <Quote__c> qList =  [SELECT Id,
                                      OwnerId,
                                      Name,
                                      Account__c,
                                      Opportunity__c,
                                      Owner_ID__c ,
                                      Contact__c,
                                      Oasis_Quote_Number__c,
                                      SAP_Order_Number__c,
                                      Quote_ID__c,
                                      Status__c
                                      FROM Quote__c
                                      WHERE ((Oasis_Quote_Number__c IN :oasisQuoteToOpp.KeySet() AND Oasis_Quote_Number__c != null)
                                             OR  (SAP_Order_Number__c IN :sapOrderNumToOpp.KeySet() AND SAP_Order_Number__c != null))
                                      LIMIT 1];		
            Map<String, List<Quote__c>> oppLineItemToAccount = new Map<String, List<Quote__c>>();
            Map<String, List<Quote__c>> oppLineItemToOpp = new Map<String, List<Quote__c>>();
            Map<String, List<Quote__c>> oppLineItemToOrderNum = new Map<String, List<Quote__c>>();
            Map<String, List<Quote__c>> oppLineItemToSapOrder = new Map<String, List<Quote__c>>();
            Map<Id, List<Quote__c>> oppLineItemToQuote = new Map<Id, List<Quote__c>>();
            for (Quote__c p: qList) {     
                String varSapOrderNum = p.Oasis_Quote_Number__c;
                String varOasisOrderNum = p.SAP_Order_Number__c;
                String varOrderNumber;
                if(String.isNotBlank(varSapOrderNum)) {
                    varOrderNumber = varSapOrderNum;
                }
                else {
                    varOrderNumber = varOasisOrderNum;
                }            
                List<Quote__c> items = oppLineItemToQuote.get(p.Id);
                if (items == null)
                {
                    items = new List<Quote__c>();
                    oppLineItemToOrderNum.put(varOrderNumber, items);
                    //               oppLineItemToSapOrder.put(p.SAP_Order_Number__c, items);
                    oppLineItemToQuote.put(p.Id, items);              
                    oppLineItemToAccount.put(p.Account__c, items);
                    oppLineItemToOpp.put(p.Opportunity__c, items);
                }
                items.add(p);
            }
            System.debug('::::OpportunityLineItemGateway + qList: ' + qList);
            
            List <Order_Tracking__c> tList =  [SELECT Id,
                                               Tracking__c,
                                               Item_Status__c,
                                               Account__c,
                                               Opportunity__c,
                                               Quote_Sample__c
                                               FROM Order_Tracking__c
                                               WHERE Quote_Sample__c IN :oppLineItemToQuote.keySet()
                                               AND Account__c IN :oppLineItemToAccount.keySet()
                                               AND Opportunity__c IN :oppLineItemToOpp.keySet()
                                               //                                        AND Item_Status__c IN :statusToOpp.keySet()
                                               AND Tracking__c IN :oppLineItemToTracking.keySet()
                                               LIMIT 1];
            Map<String, List<Order_Tracking__c>> oasisQuoteTrackingCheck = new Map<String, List<Order_Tracking__c>>();
            Map<String, List<Order_Tracking__c>> quoteTrackingCheck = new Map<String, List<Order_Tracking__c>>();  
            Map<String, List<Order_Tracking__c>> statusTrackingCheck = new Map<String, List<Order_Tracking__c>>();
            for (Order_Tracking__c oTrack: tList) {
                List<Order_Tracking__c> itemsOT = oasisQuoteTrackingCheck.get(oTrack.Id);
                if (itemsOT == null)
                {
                    itemsOT = new List<Order_Tracking__c>();
                    oasisQuoteTrackingCheck.put(oTrack.Tracking__c, itemsOT);
                    quoteTrackingCheck.put(oTrack.Quote_Sample__c, itemsOT);
                    statusTrackingCheck.put(oTrack.Item_Status__c, itemsOT);
                }
                itemsOT.add(oTrack);
            }
            System.debug('::::OpportunityLineItemGateway + tList: ' + tList);
            // find the relationships between the records and create the new Order Tracking records
            
            for (String tracking : listTrackingNumber) {
                List <OpportunityLineItem> listLineItemInfo = oppLineItemToTracking.get(tracking);
                for ( OpportunityLineItem oli: listLineItemInfo) {
                    if (tracking == oli.Carrier_Tracking_Number__c) {
                        String varSapOrderNum = oli.Oasis_Quote_Number__c;
                        String varOasisOrderNum = oli.SAP_Order_Number__c;
                        String varOrderNumber;
                        String varOrderSystem;           
                        if(String.isNotBlank(varSapOrderNum)) {
                            varOrderNumber = varSapOrderNum;
                            varOrderSystem = 'SAP';
                        }
                        else {
                            varOrderNumber = varOasisOrderNum;
                            varOrderSystem = 'OASIS';
                        }        	
                        System.debug('::::OpportunityLineItemGateway + oli: ' + oli);
                        System.debug('::::OpportunityLineItemGateway + varOrderNumber: ' + varOrderNumber); 
                        
                        List<Quote__c> listSampleOrders =  oppLineItemToOpp.get(oli.OpportunityId);
                        if (listSampleOrders != null) { 
                            for (Quote__c q : listSampleOrders) {
                                List<Order_Tracking__c> oTrackingCheck =  quoteTrackingCheck.get(q.id);
                                if (oTrackingCheck == null) { 
                                    System.debug('::::OpportunityLineItemGateway + oTrackingCheck == null: ' + oTrackingCheck);	
                                    Order_Tracking__c ot = new Order_Tracking__c();
                                    ot.OwnerId = q.OwnerId;
                                    ot.Quote_Sample__c = q.Id;
                                    ot.Order_Number__c = varOrderNumber;
                                    if (oli.Carrier_Tracking_Number__c != NULL ) 
                                    {	
                                        ot.Tracking__c = oli.Carrier_Tracking_Number__c;	        		
                                    }
                                    ot.Order_System__c = varOrderSystem;
                                    ot.Account__c = q.Account__c;
                                    ot.Opportunity__c = q.Opportunity__c;
                                    ot.Item_Status__c = oli.Item_Status__c;
                                    newOrderTracking.add(ot);   			
                                } else {
                                    System.debug('::::OpportunityLineItemGateway + oTrackingCheck == null');
                                    System.debug('::::OpportunityLineItemGateway + oTrackingCheck:...' + oTrackingCheck  + ', oli.Carrier_Tracking_Number__c:...' + oli.Carrier_Tracking_Number__c);
                                    for (Order_Tracking__c  currentOT : oTrackingCheck) {
                                        List<Order_Tracking__c> trackingCheck =  oasisQuoteTrackingCheck.get(oli.Carrier_Tracking_Number__c);
                                        System.debug('::::OpportunityLineItemGateway + trackingCheck:...' + trackingCheck);
                                        if ((trackingCheck == null) || ((oli.Carrier_Tracking_Number__c == '')||(oli.Carrier_Tracking_Number__c == NULL)))
                                        {
                                            System.debug('::::OpportunityLineItemGateway + (trackingCheck == null) || (oli.Carrier_Tracking_Number__c == ');	
                                            Order_Tracking__c ot = new Order_Tracking__c();
                                            ot.OwnerId = q.OwnerId;
                                            ot.Quote_Sample__c = q.Id;
                                            ot.Order_Number__c = varOrderNumber;
                                            if (oli.Carrier_Tracking_Number__c != NULL ) 
                                            {	
                                                ot.Tracking__c = oli.Carrier_Tracking_Number__c;	        		
                                            }
                                            ot.Order_System__c = varOrderSystem;
                                            ot.Account__c = q.Account__c;
                                            ot.Opportunity__c = q.Opportunity__c;
                                            ot.Item_Status__c = oli.Item_Status__c;
                                            newOrderTracking.add(ot);   			
                                        } 
                                    }					
                                }   
                            }
                        }
                    }
                }
                System.debug('::::OpportunityLineItemGateway + newOrderTracking: ' + newOrderTracking);  
            }
        }
        return newOrderTracking;
    }
}