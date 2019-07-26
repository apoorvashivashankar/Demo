/**
* Created by 7Summits on 5/11/18.
**/
public without sharing class Dal_ShipmentManager {
    
    @TestVisible
    private static list<DT_SYS_ShipmentList__x> mockallShipmentList = new list<DT_SYS_ShipmentList__x>();
    @TestVisible
    private static list<DT_SYS_ShipmentLine__x> mockallShipmentLineList = new list<DT_SYS_ShipmentLine__x>();
    
    
    	// Wrapper for Shipment header object
        public class ShipmentHeaderWrapper {
           
            
            @AuraEnabled public String  BolNumber;
         	@AuraEnabled public String  CarrierName;
       		@AuraEnabled public String  ShipFromLocDesc;
            @AuraEnabled public String  ShipmentCreationDate;
            @AuraEnabled public String  StatusDesc;
            @AuraEnabled public String  Status;
            @AuraEnabled public String  TrackingNbr;
            @AuraEnabled public String  Invoice;
            @AuraEnabled public Decimal Total_Weight;
            @AuraEnabled public List<ShipmentlineWrapper> lineWrapper;
                	
            public ShipmentHeaderWrapper(DT_SYS_ShipmentList__x shipment){
                    this.BolNumber = shipment.Shipment__c;
                    this.ShipmentCreationDate = shipment.ShipmentCreationDate__c;
                    this.CarrierName = shipment.Carrier_Name__c;
                    this.ShipFromLocDesc = shipment.ShipFromLocDesc__c ;
                    this.StatusDesc = shipment.StatusDesc__c;
                    this.Status = shipment.Status__c;
                    this.TrackingNbr = shipment.TrackingNbr__c;
            }

            public ShipmentHeaderWrapper(DT_SYS_ShipmentList__x shipment, List<ShipmentlineWrapper> shipLineWrapper,Decimal totalWeight){
                    this.BolNumber = shipment.Shipment__c;
                    this.ShipmentCreationDate = shipment.ShipmentCreationDate__c;
                    this.CarrierName = shipment.Carrier_Name__c;
                    this.ShipFromLocDesc = shipment.ShipFromLocDesc__c ;
                    this.StatusDesc = shipment.StatusDesc__c;
                    this.Status = shipment.Status__c;
                    this.TrackingNbr = shipment.TrackingNbr__c;
                    this.lineWrapper = shipLineWrapper;
                	this.Total_Weight = totalWeight;
            }
        }
        
    	// Wrapper for Line Items 
        public class ShipmentlineWrapper{
             @AuraEnabled public String CartonCount;
             @AuraEnabled public String CustomerPONo; 
             @AuraEnabled public String MaterialDesc;
             @AuraEnabled public String Material;
             @AuraEnabled public Decimal OrderQuantity;
             @AuraEnabled public String PieceCount;
             @AuraEnabled public String SalesOrder;
             @AuraEnabled public String Shade;
             @AuraEnabled public String Shipment;
             @AuraEnabled public Decimal ShippedQuantity;
             @AuraEnabled public String TrackingNo;
             @AuraEnabled public String Invoice;
             @AuraEnabled public String UOM;
             @AuraEnabled public Decimal Weight;
            
            public ShipmentlineWrapper(DT_SYS_ShipmentLine__x shipmentLine){
                 this.CartonCount = shipmentLine.CartonCount__c;
                 this.CustomerPONo = shipmentLine.CustomerPONo__c; 
                 this.MaterialDesc = shipmentLine.MaterialDesc__c;
                 this.Material = shipmentLine.Material__c;
                 this.OrderQuantity = shipmentLine.OrderQuantity__c;
                 this.PieceCount = shipmentLine.PieceCount__c;
                 this.SalesOrder = shipmentLine.SalesOrder__c;
                 this.Shade = shipmentLine.Shade__c;
                 this.Shipment = shipmentLine.Shipment__c;
                 this.ShippedQuantity = shipmentLine.ShippedQuantity__c;
                 this.TrackingNo = shipmentLine.TrackingNo__c;
                 this.Invoice = shipmentLine.Invoice__c;
                 this.UOM = shipmentLine.UOM__c;
                 this.Weight = shipmentLine.Weight__c;
            }
        }
   		
    	/*
        * Method Name: getShipmentCount
        * Description: Purpose to grab all shipment List created in past 90 days.
        * @param: None
        * @return Integer
        */
    	@AuraEnabled
        public static Integer getShipmentCount(){
            
            Integer count = 0;
            String customerId = Dal_ShipmentManager.getCustomerId();
            System.debug('customerId'+customerId);
            
            String dateValue = string.valueOf(System.today().addDays(-90));  
            
            List<DT_SYS_ShipmentList__x> ShipmentList = new List<DT_SYS_ShipmentList__x>();
            ShipmentList = [Select id from DT_SYS_ShipmentList__x WHERE Customer__c =: customerId AND ShipmentCreationDate__c >=: dateValue];
            
            for(DT_SYS_ShipmentList__x shipment : ShipmentList)
            {
                count = count + 1;
            }
            System.debug('COUNT----->'+count);
            return count;
        }

        @AuraEnabled
        public static List<ShipmentHeaderWrapper> getShipmentList(String shipFrom, String shipTo, Integer listLimit){
            List<ShipmentHeaderWrapper> shipHeaderList = searchShipments(null, shipFrom, shipTo, null, listLimit);
            return shipHeaderList;
        }

        @AuraEnabled
        public static List<ShipmentHeaderWrapper> searchShipments(String shipmentNumber, String shipFrom, String shipTo,String shipFromLoc, Integer listLimit){
            String customerId = Dal_ShipmentManager.getCustomerId();
            System.debug('customerId'+customerId);


            List<DT_SYS_ShipmentList__x> shipmentList = new List<DT_SYS_ShipmentList__x>();
            List<ShipmentHeaderWrapper> shipHeaderList = new List<ShipmentHeaderWrapper>();

            if(customerId !=null) {

                System.debug(shipmentNumber);
                System.debug(shipFrom);
                System.debug(shipTo);
                System.debug(shipFromLoc);
                
                shipmentList = queryShipment(shipmentNumber,shipFrom,shipTo,shipFromLoc,customerId,listLimit);
                if(Test.isRunningTest())
                {
                    shipmentList.addAll(mockallShipmentList);
                }
                if(shipmentList.size() > 0 && String.isNotBlank(shipmentList[0].id)) {

                    System.debug('Case List--->'+shipmentList[0]);

                    for(DT_SYS_ShipmentList__x shipHeader : shipmentList){
                        ShipmentHeaderWrapper headerWrapper = new ShipmentHeaderWrapper(shipHeader);
                        shipHeaderList.add(headerWrapper);
                    }
                }
            }

            System.debug('shipHeaderList-->'+shipHeaderList);
            return shipHeaderList;
        }

        /*
        * Method Name: getShipmentList
        * Description: Purpose to grab all shipment List or Searched shipment item .
        * @param: shipmentNumber, shipFrom, shipTo, ShipFromLoc
        * @return ShipmentHeaderWrapper
        */


        
        /*
        * Method Name: getShipmentDetail
        * Description: Method to get Shipment Detail form External Object DT_SYS_ShipmentLine__x
        * @param: ShipmentId
        * @return Customer Id
        */
    	@AuraEnabled
    	public static ShipmentHeaderWrapper getShipmentDetail(String ShipmentId){
            system.debug('ShipmentId '+ShipmentId);
            Decimal totalWeight = 0;
            String customerId = Dal_ShipmentManager.getCustomerId();
            
            List<DT_SYS_ShipmentLine__x> shipmentLineList = new List<DT_SYS_ShipmentLine__x>();
            List<ShipmentlineWrapper> shipmentLineWrapperList = new List<ShipmentlineWrapper>();
            
            if(customerId !=null) {
                if(!Test.isRunningTest()){
                     shipmentLineList = [SELECT CartonCount__c, CustomerPONo__c, MaterialDesc__c, Material__c, 
                            		OrderQuantity__c, PieceCount__c, SalesOrder__c, Shade__c, Shipment__c, ShippedQuantity__c,
                            		TrackingNo__c, UOM__c,Invoice__c, Weight__c FROM DT_SYS_ShipmentLine__x where Customer__c =: customerId AND Shipment__c =: ShipmentId];

                }
                else{
                    shipmentLineList.addAll(mockallShipmentLineList);
                }
                    
                               
                   // System.debug('shipmentLineList--->'+shipmentLineList[0]);
                    System.debug('shipmentLineList.size()--->'+shipmentLineList.size());
                if(shipmentLineList.size() > 0 && String.isNotBlank(shipmentLineList[0].id)) {
                    
                    for(DT_SYS_ShipmentLine__x shipLineList : shipmentLineList){
                        ShipmentlineWrapper LineWrapper = new ShipmentlineWrapper(shipLineList);
                        shipmentLineWrapperList.add(LineWrapper);
                        totalWeight = totalWeight + shipLineList.Weight__c;
                    }
                }
            }
            
            List<DT_SYS_ShipmentList__x> header = queryShipment(ShipmentId,null,null,null,customerId,0);
            if(header != null && header.size() > 0) {
                System.debug('Total_Weight---->'+totalWeight);
                ShipmentHeaderWrapper headerWrapper = new ShipmentHeaderWrapper(header[0], shipmentLineWrapperList,totalWeight);
                System.debug('List of Data for Detail page ------>' + headerWrapper);
                return headerWrapper;
            }
            return null;
        }     
        
        /*
        * Method Name: getCustomerId
        * Description: Method to get Customer Id
        * @param: ShipmentNumber, shipFrom, shipTo, ShipFromLoc, customerId, listLimit
        * @return DT_SYS_ShipmentList__x : shipment List
        */
        public static List<DT_SYS_ShipmentList__x> queryShipment(String ShipmentNumber, String shipFrom, String shipTo,String shipFromLoc, String customerId, Integer listLimit) {
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
		
        List<DT_SYS_ShipmentList__x> shipOrderList = new List<DT_SYS_ShipmentList__x>();
        String dformat = 'yyyy-MM-dd\'T\'hh:mm:ss\'.000+\'0000';
            
        try{
            String query = 'SELECT Carrier_Name__c,ShipFromLocDesc__c, ShipFromLoc__c, ShipmentCreationDate__c,'+
                               ' Shipment__c, StatusDesc__c, Status__c, TrackingNbr__c FROM DT_SYS_ShipmentList__x '+
                               ' where Customer__c = \'' + customerId + '\'' ;
          
            if(ShipmentNumber!=null && String.isNotBlank(ShipmentNumber))
            {
                query += ' AND Shipment__c like \'%' + ShipmentNumber.toUpperCase() + '%\'';
                
            }
            system.debug('ShipFromLoc '+shipFromLoc);
            if(shipFromLoc!=null && String.isNotBlank(shipFromLoc))
            {
                query += ' AND ShipFromLoc__c = \''+ shipFromLoc + '\'';
               
            }
            //if(shipFrom!=null && shipTo == null){
            if(String.isNotEmpty(shipFrom) && String.isEmpty(shipTo)){
               	system.debug('shipFrom is '+shipFrom);
                DateTime dt = Datetime.now();
                DateTime newdt = dt.addDays(1);
                string todate = newdt.formatGmt(dformat);
                String shipFromDate = String.valueOf(Date.valueOf(shipFrom)).remove(' 00:00:00');
                //string fromdate = shipFrom.formatGmt(dformat);
                query += ' AND ShipmentCreationDate__c >= \'' + shipFromDate + '\'';
                 
                //System.debug('5 '+'shipFrom'+shipFrom+'shipTo'+shipTo+ '&&&&&'+query);
            }
            //if(shipTo!=null && shipFrom == null){
            if(String.isNotEmpty(shipTo) && String.isEmpty(shipFrom)){
               	system.debug('shipTo is '+shipTo);
                //string todate = shipTo.formatGmt(dformat);
                String shipToDate = String.valueOf(Date.valueOf(shipTo)).remove(' 00:00:00');
                query += ' AND ShipmentCreationDate__c <= \'' + shipToDate + '\'';
               //System.debug('6 '+'shipFrom'+shipFrom+'shipTo'+shipTo+ '&&&&&'+query); 
            }
           	//if(shipTo!=null && shipFrom!=null){
           	if(String.isNotEmpty(shipFrom) && String.isNotEmpty(shipTo)){
                //string todate = shipTo.formatGmt(dformat);
               // string fromdate = shipFrom.formatGmt(dformat);
                String shipFromDate = String.valueOf(Date.valueOf(shipFrom)).remove(' 00:00:00');
                String shipToDate = String.valueOf(Date.valueOf(shipTo)).remove(' 00:00:00');
                query += ' AND ShipmentCreationDate__c >= \'' + shipFromDate + '\' AND ShipmentCreationDate__c <= \'' + shipToDate + '\'';
            //System.debug('7 '+'shipFrom'+shipFrom+'shipTo'+shipTo+ '&&&&&'+query);
            }          

           	query += ' ORDER BY ShipmentCreationDate__c DESC';
                if(listlimit > 0){
                    query += ' LIMIT '+listlimit;
                    System.debug('8 '+'&&&&&'+query);
                }
            System.debug('Query------>'+query);
            if(!Test.isRunningTest()){
            shipOrderList = Database.query(query);
            }else{
                //System.debug('mockallShipmentList&&'+mockallShipmentList);
                //System.debug('mockallShipmentLineList&&'+mockallShipmentLineList);
                shipOrderList.addall(mockallShipmentList);
            }
        }
        catch(Exception exp){
            System.debug('shipOrderList : An unexpected error has occurred: ' + exp.getMessage());
        }
             //System.debug('5 '+shipOrderList);
       return shipOrderList;
     }
        
        
        /*
        * Method Name: getCustomerId
        * Description: Method to get Customer Id
        * @param: Not Any
        * @return Customer Id
        */
        public static String getCustomerId(){
            String customerId;
            Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
            customerId = selectedAccount.DW_ID__c;
            system.debug('customerId'+customerId);
            return customerId;
        }
    }