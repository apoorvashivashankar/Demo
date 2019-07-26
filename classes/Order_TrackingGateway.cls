public with sharing class Order_TrackingGateway {

    public static List<Map<List<FeedItem>,List<ConnectApi.FeedItemInput>>> newChatterTrackingUpdate (Set<Id> setOppId) { 
        String varSapOrderNum;
        String varOasisOrderNum;
        String varOrderNumber;

        System.debug('::::Order_TrackingGateway + setOppId: ' + setOppId);
        List<Order_Tracking__c> listOrderTrackings = [SELECT Id, 
                                                        Quote_Sample__c,
                                                        Tracking__c, 
                                                        Order_Number__c,
                                                        Order_System__c,
                                                        Item_Status__c,
                                                        Track_Status__c
                                                    FROM Order_Tracking__c 
                                                    WHERE Id IN :setOppId];
        Map<Id, List<Order_Tracking__c>> mapQuoteToOrderTracking = new Map<Id, List<Order_Tracking__c>>();
        Map<String, List<Order_Tracking__c>> mapOrderNumberToOrderTracking = new Map<String, List<Order_Tracking__c>>();
        for (Order_Tracking__c o: listOrderTrackings) {
            List<Order_Tracking__c> listOrderTrackingRecord = mapQuoteToOrderTracking.get(o.id);
            if (listOrderTrackingRecord == null)
            {
                listOrderTrackingRecord = new List<Order_Tracking__c>();
                mapQuoteToOrderTracking.put(o.Quote_Sample__c, listOrderTrackingRecord);
                mapOrderNumberToOrderTracking.put(o.Order_Number__c, listOrderTrackingRecord);
            }
            listOrderTrackingRecord.add(o);
        }

        System.debug('::::Order_TrackingGateway + listOrderTrackings: ' + listOrderTrackings);
        System.debug('::::Order_TrackingGateway + mapOrderNumberToOrderTracking: ' + mapOrderNumberToOrderTracking);

        List<Quote__c> listQuotes = [SELECT Id, 
                                        OwnerId, 
                                        Oasis_Quote_Number__c , 
                                        Quote_ID__c , 
                                        API_Partner_URL__c, 
                                        API_Session_ID__c,
                                        SAP_Order_Number__c, 
                                        Fulfillment_Method__c ,
                                        Account__r.OwnerId, 
                                        Account__r.Name, 
                                        Owner_ID__c, 
                                        Opportunity__r.Name, 
                                        Opportunity__r.OwnerId, 
                                        Opportunity__c
                                    FROM Quote__c
                                    Where Id IN :mapQuoteToOrderTracking.Keyset()
                                    LIMIT 1];
        Map<Id, List<Quote__c>> mapQuote = new Map<Id, List<Quote__c>>();
        Map<Id, List<Quote__c>> mapOppToQuote = new Map<Id, List<Quote__c>>();
        for (Quote__c c: listQuotes) {
          List<Quote__c> quote = mapQuote.get(c.Id);
          if (quote == null)
          {
            quote = new List<Quote__c>();
            mapQuote.put(c.Id, quote);
            mapOppToQuote.put(c.Opportunity__c, quote);
          }
          quote.add(c);
        }
        System.debug('::::Order_TrackingGateway + listQuotes: ' + listQuotes);

        List<Quote__c> listQuotesByOrderNum = [SELECT Id, 
                                                    OwnerId, 
                                                    Oasis_Quote_Number__c , 
                                                    Quote_ID__c , 
                                                    API_Partner_URL__c, 
                                                    API_Session_ID__c,
                                                    SAP_Order_Number__c, 
                                                    Fulfillment_Method__c ,
                                                    Account__r.Name, 
                                                    Account__r.OwnerId, 
                                                    Owner_ID__c, 
                                                    Opportunity__r.Name, 
                                                    Opportunity__c
                                                FROM Quote__c
                                                WHERE ((Oasis_Quote_Number__c IN :mapOrderNumberToOrderTracking.KeySet())
                                                AND (Oasis_Quote_Number__c != NULL))
                                                OR  ((SAP_Order_Number__c IN :mapOrderNumberToOrderTracking.KeySet())
                                                AND (SAP_Order_Number__c != NULL))];
        for (Quote__c c: listQuotesByOrderNum) {
          List<Quote__c> quote = mapQuote.get(c.Id);
          if (quote == null)
          {
            quote = new List<Quote__c>();
            mapQuote.put(c.Id, quote);
            mapOppToQuote.put(c.Opportunity__c, quote);
          }
          quote.add(c);
        }
        System.debug('::::Order_TrackingGateway + listQuotesByOrderNum: ' + listQuotesByOrderNum);                                                
    
        listQuotes.addAll(listQuotesByOrderNum);
        System.debug('::::Order_TrackingGateway + listQuotes + listQuotesByOrderNum: ' + listQuotes);                 
    
        List<Opportunity> listOpps = [SELECT Id, 
                                OwnerId,
                                Owner.ProfileId, 
                                Owner.Profile.Name
                                FROM Opportunity
                                Where Id IN :mapOppToQuote.Keyset()
                                LIMIT 1];
        Map<Id,String> mapOppOwnerProfileToOpp = new Map<Id,String> ();
        Map<Id, List<Opportunity>> mapOppOwnerToOpp = new Map<Id, List<Opportunity>>();
        for (Opportunity c: listOpps) {
          List<Opportunity> opp = mapOppOwnerToOpp.get(c.Id);
          if (opp == null)
          { 
            opp = new List<Opportunity>();
            mapOppOwnerToOpp.put(c.OwnerId, opp);
            mapOppOwnerProfileToOpp.put(c.Id,c.Owner.Profile.Name);
          }
          opp.add(c);
        }
        System.debug('::::Order_TrackingGateway + listOpps: ' + listOpps);

        List<OpportunityLineItem> listOppLineItems = [SELECT Id,
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
                                    WHERE ((Oasis_Quote_Number__c IN :mapOrderNumberToOrderTracking.KeySet())
                                    AND (Oasis_Quote_Number__c != NULL))
                                    OR  ((SAP_Order_Number__c IN :mapOrderNumberToOrderTracking.KeySet())
                                    AND (SAP_Order_Number__c != NULL))];
        System.debug('::::Order_TrackingGateway + listOppLineItems: ' + listOppLineItems);
        Integer varNumLineItems = listOppLineItems.size();
        Map<String , List<OpportunityLineItem>> mapOrderNumberToOppLineItems = new Map<String , List<OpportunityLineItem>>();
        List<OpportunityLineItem> listOppLineItemsForUpdate = new List<OpportunityLineItem>();
        for (OpportunityLineItem listOppLineItem: listOppLineItems ) {
            System.debug('::::Order_TrackingGateway + listOppLineItem.SAP_Order_Number__c: ' + listOppLineItem.SAP_Order_Number__c);
            System.debug('::::Order_TrackingGateway + listOppLineItem.Oasis_Quote_Number__c: ' + listOppLineItem.Oasis_Quote_Number__c);
            varSapOrderNum = listOppLineItem.Oasis_Quote_Number__c;
            varOasisOrderNum = listOppLineItem.SAP_Order_Number__c;
            if(String.isNotBlank(varOasisOrderNum) || varOasisOrderNum == '') {
                varOrderNumber = varOasisOrderNum;
            }
            else {
                varOrderNumber = varSapOrderNum;
            }  
            listOppLineItemsForUpdate.add(listOppLineItem);
        }         
        System.debug('::::listOppLineItems + varOrderNumber: ' + varOrderNumber);
        Integer varFulfillLineItems = listOppLineItemsForUpdate.size();         
        
        mapOrderNumberToOppLineItems.put(varOrderNumber , listOppLineItemsForUpdate);
        
        List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>(); 
        List<ConnectApi.FeedItemInput> batchUpdates = new List<ConnectApi.FeedItemInput>();
        Integer MAXSIZE = 2 ;// Select Your size
        List<Map<List<FeedItem>, List<ConnectApi.FeedItemInput>>> newChatterPost = new List<Map<List<FeedItem>, List<ConnectApi.FeedItemInput>>>();
        // List <Map<ConnectApi.FeedElement, ConnectApi.FeedItemInput>> newChatterPost = new List <Map<ConnectApi.FeedElement, ConnectApi.FeedItemInput>>();
        for (Order_Tracking__c ot: listOrderTrackings) {
            List<Quote__c> quotes = mapQuote.get(ot.Quote_Sample__c);
            if (quotes == NULL) {
                System.debug('::::Order_TrackingGateway + listQuotes: ' + listQuotes);
                quotes = listQuotes;
            }
            System.debug('::::Order_TrackingGateway + quotes: ' + quotes);

            // remove duplicates

            Set<Quote__c> myset = new Set<Quote__c>();
            List<Quote__c> result = new List<Quote__c>();
            myset.addAll(quotes);
            result.addAll(myset);     
            quotes = result;

            if (quotes != NULL) {
                for (Quote__c q: quotes) {
                    System.debug('::::Order_TrackingGateway + q: ' + q);
                    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();                                                                                
                    ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                    ConnectApi.LinkCapabilityInput linkSegmentInput = new ConnectApi.LinkCapabilityInput();
                    
//                    ConnectApi.Actor actor = new ConnectApi.Actor();
                    // create the body of the message
                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                    
                    string text2 = null;
                    
                    String hashtag = 'OrderTracking';
                    String text1 = ': Your sample Order for ';
                    String theAccount = q.Account__r.Name;
                    String theOpprtunity = q.Opportunity__r.Name;                   
                    if (String.isNotBlank(ot.Tracking__c)) { 
                        text2 = ' has shipped. Follow the link to track your Sample Order# ';
                    } else { 
                        if (ot.Item_Status__c == 'Fulfilled'){
                            if (q.Fulfillment_Method__c == 'Ship') {
                                text2 = ' has items fulfilled and shipped, however no tracking information was provided. Follow the link to see your items status for Order#: ';                                
                            } else {
                                text2 = ' has items fulfilled and ready for pickup. Follow the link to see your items status for Order#: ';
                            } 
                        }else {
                            text2 = ' has been updated with items in a status of ' + ot.Item_Status__c + '. Follow the link to see your items status for Order#: ';
                        }
                    }
                    System.debug('::::Order_TrackingGateway + String text2: ' + text2);
                    String order = varOrderNumber;

                    textSegmentInput.text =  '#' + hashtag + text1 + theAccount + ', ' + theOpprtunity + text2 + order + '. ' ;
                    messageBodyInput.messageSegments.add(textSegmentInput);
                    
                    string messageText = textSegmentInput.text;

                    String varUserGettingMessage;                    
                    String varUserProfileGettingMessage = mapOppOwnerProfileToOpp.get(q.Opportunity__c);
                    if (varUserProfileGettingMessage == 'System Administrator') {
                        varUserGettingMessage = q.Account__r.OwnerId;
                    } else {
                        varUserGettingMessage = q.OwnerId;
                    }

                    // add the mention 
                    mentionSegmentInput.id = varUserGettingMessage;
                    messageBodyInput.messageSegments.add(mentionSegmentInput);

                    string link = NULL;
                    String cpqLocation = System.Label.CPQ_URL;
                    
                    // add the link                 
                    if (String.isNotBlank(ot.Tracking__c)) { 
                        link = 'http://wwwapps.ups.com/etracking/tracking.cgi?tracknums_displayed=1&TypeOfInquiryNumber=T&HTMLVersion=4.0&InquiryNumber1='; 
                    } else {
                        // link now is just the edit mode for the quote, which in turn will pull the users current connection information
                        PageReference cqpLink = new PageReference('/' + String.valueOf(q.id).substring(0, 15) + '/e');
                        String cpqLinkString = cqpLink.getUrl();
                        link =  cpqLinkString;
                    }

                    System.debug('::::Order_TrackingGateway + String link: ' + link);

                    if (String.isNotBlank(ot.Tracking__c)) {                     
                        String tracking = ot.Tracking__c;    
                        linkSegmentInput.url = link + tracking;
                        linkSegmentInput.urlName = 'Track Order #' + order;
                    } else {   
                        linkSegmentInput.url = link;
                        linkSegmentInput.urlName = 'View Sample Order #' + order + ' Item Status';                      
                    }

                    string linkURL = linkSegmentInput.url;
                    string linkName = linkSegmentInput.urlName;
                        
                    ConnectAPI.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectAPI.FeedElementCapabilitiesInput();
                    feedElementCapabilitiesInput.link = linkSegmentInput;

//                    feedItemInput.capabilities = feedElementCapabilitiesInput;
                    feedItemInput.body = messageBodyInput;
                    // feedItemInput.subjectId = q.Opportunity__c;
                    // feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;

                    // Use a record ID for the subject ID.
                    // feedItemInput.subjectId = q.Opportunity__c;
                
                    FeedItem fi = new FeedItem(
                    parentId = q.Opportunity__c, // where post is being made: user, group, record
                    createdById = varUserGettingMessage, // who is posting the message
                    body = messageText, // rich-text, but @mentions not supported
                    LinkUrl = linkURL,
                    title = linkName,
                    isRichText = true // we support rich-text and @mentions
                    );
                    
                    list <FeedItem> listFeedItems = new list <FeedItem>(); 
                    listFeedItems.add(fi);
                    
                    ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
            
                    input.subjectId = q.Opportunity__c;
                    
                    ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
                    body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
                    ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
                    textSegment.text = messageText;
            
                    body.messageSegments.add(textSegment);
                    input.body = body;
                    
                    // input.createdById = q.OwnerId; // who is posting the message
            
                    ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
                    batchInputs.add(batchInput);
                    batchUpdates.add(feedItemInput);
                    
                    Map <List<FeedItem>, List<ConnectApi.FeedItemInput>> newChatterPostMap = new Map <List<FeedItem>, List<ConnectApi.FeedItemInput>>();
                    newChatterPostMap.put(listFeedItems,batchUpdates);
                    newChatterPost.add(newChatterPostMap);

                    // insert fi;

                    // ConnectApi.FeedElement fe = ConnectApi.ChatterFeeds.getFeedElement( Network.getNetworkId(), fi.id ); 
                    // newChatterPostMap.put(fe,feedItemInput);
                    // newChatterPost.add(newChatterPostMap);
                    System.debug('::::Order_TrackingHandler + batchInputs: ' + batchInputs);
                }
            }
        }
        return newChatterPost;
    }
}