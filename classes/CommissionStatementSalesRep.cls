public class CommissionStatementSalesRep{

    public String column { get; set; }

  
public CommissionStatementSalesRep(){
  List<Clear_Pay_Link__c> mc = Clear_Pay_Link__c.getAll().values();
  String urlClearPay = '';
  
  if(mc.size() > 0) {
      urlClearPay = mc[0].Clear_Pay_Link__c;
      clearPayLink = urlClearPay;
  }
  
    List<SecurityToken__c> token = SecurityToken__c.getAll().values();
    secureToken = '';
  
    if(token.size() > 0) {
        secureToken = token[0].SecurityToken__c;  
    }
}

public String secureToken{get;set;}
public String clearPayLink{get;set;}
List<User> listUserDetails ;
List<String> reverseNameList;
String LongDate = ' ';
public List<User> empID{get;set;}
public String employeeNum{get;set;}
public String Username{get;set;} 
public String UserID{get;set;}
public String reverseName{get;set;}
public List<List<String>> listPaymentCalculations{get;set;} 
//Flag
public boolean promotionFlag{get;set;}
public boolean paymentFlag{get;set;}
public boolean salesKickFlag{get;set;}
public boolean exceptionFlag{get;set;}
public boolean headerFlag {get;set;}

// for Promotions
public List<List<String>> listPromotion {get;set;}
public List<List<String>> listPromotionValue {get;set;}
public List<List<String>> listPromotionInv2 {get;set;}
public List<String> strKeyListInv2{get;set;}
public List<String> strValListInv2{get;set;}
public List<String> strKeyListInv1{get;set;}
public List<String> strValListInv1{get;set;} 
public List<String> strKeyList{get;set;}
public List<String> strValList{get;set;}
public List<List<String>> listPromotionInv {get;set;}
public List<List<String>> listPromotion1 {get;set;}
public List<List<String>> listKeyPromotion{get;set;}
public Integer promValueSize2{get;set;}

//for Sales Kicker
public List<List<String>> listSalesKickerSalesPerformColumn {get;set;}
//for header info
public List<String> listHeaderInfo{get;set;}
public List<String> listTotal{get;set;} 
//For Exception
public List<String> listExceptionMsg{get;set;}
public String  totalValue{get;set;}
public Integer dupVal{get;set;}
public Integer totalPay{get;set;}
public Integer salesKicker{get;set;}
public Integer colSpan{get;set;}
public Integer promoTotalSize{get;set;}
public Integer promValueSize{get;set;}
public String strBounty{get;set;}
public String toParse = null;
public String yearCommission;
public String monthCommission;
 /* parseIt() Method is used to read the XML String after invoking the webservice method */
public PageReference parseIt() {
    strBounty='0';
    promotionFlag=false;
    paymentFlag=false;
    salesKickFlag=false;
    exceptionFlag=false;
    headerFlag=false;
    boolean isResponseFound;
    empID = [select Name, EmployeeNumber from User where Id = :UserInfo.getUserId()]; //where EmployeeNumber '100066'];
     
    DOM.Document doc = new DOM.Document();  
    try{
         ClearPayCommissionStmtClient.BasicHttpBinding_IClearPayCommissionStmt stub = new ClearPayCommissionStmtClient.BasicHttpBinding_IClearPayCommissionStmt();
         
         //Configured the timeout seconds to 120000
         
         StubTimeout__c st= StubTimeout__c.getAll().values();
         Decimal timeoutInMilliSeconds = st.stubTimeout__c;
         stub.timeout_x = Integer.valueOf(timeoutInMilliSeconds); // timeout in milliseconds 
         empID = [select Name, EmployeeNumber from User where Id = :UserInfo.getUserId()]; //where EmployeeNumber '100066'];
         for(User us: empID){
            employeeNum = us.EmployeeNumber;
         }
       
         Datetime cDT = System.now();
         Date myDate = date.valueOf(cDT);
         String currentMonth = cDT.format('MMMM');
         if(currentMonth.equalsIgnoreCase('January')){
             Integer  month= myDate.month()-1;
             Integer  year = myDate.year()-1;
             monthCommission= month.format();
             yearCommission= year.format();
             String[] yearComm = yearCommission.split(',');
             yearCommission = yearComm[0]+yearComm[1] ;
         }
         else{
             Integer  month= myDate.month()-1;
             Integer  year = myDate.year();
             monthCommission= month.format();
             //Appending 0 with the single digit of month
              if(monthCommission=='1' || monthCommission=='2' || monthCommission=='3' || monthCommission=='4' || monthCommission=='5' || monthCommission=='6' || monthCommission=='7' || monthCommission=='8' || monthCommission=='9' ){
                monthCommission = '0'+monthCommission;
             }
             //yearCommission= year.format();
             yearCommission= year.format();
             String[] yearComm = yearCommission.split(',');
             yearCommission = yearComm[0]+yearComm[1] ;
         }
         /*String excelXMLString = stub.GetCommissionStmt('56202', monthCommission, yearCommission, secureToken);
          String excelXMLString = stub.GetCommissionStmt('59265','11','2011');
          String toParse = excelXMLString ;
          StaticResource sr = [select id,body from StaticResource Where Name = 'Report1'];// //Commission_Statement95004MARXPAUL//report_D08D8702_2B97_47BF_8A6C_A5BC33F7E76C
          String toParse = sr.body.toString();*/
         
         
         if(Test.isRunningTest()) {
            //StaticResource sr = [select id,body from StaticResource Where Name = 'Report1'];
            
            toParse = '<testDoc><!--this is a tes--><'+System.Label.Header+'><monthyearInfo>x</monthyearInfo></'+System.Label.Header+'>'+
                      '<'+System.Label.Exception+' param1="x" param2="y">x</'+System.Label.Exception+'>'+
                      '<'+System.Label.Payment+' attr1="z" attr2="y"><child1><Symbol>NA</Symbol><Symbol></Symbol><Dollar>1</Dollar><Percentage>1</Percentage></child1></'+System.Label.Payment+'>'+
                      '<'+System.Label.Promotion+' attr1="z" attr2="y"><'+System.Label.Inv1+'><Symbol>NA</Symbol><Symbol></Symbol><Dollar>1</Dollar><Percentage>1</Percentage></'+System.Label.Inv1+'></'+System.Label.Promotion+'>'+
                      '<'+System.Label.Promotion+' attr1="z" attr2="y"><'+System.Label.Inv2+'><Symbol>NA</Symbol><Symbol></Symbol><Dollar>1</Dollar><Percentage>1</Percentage></'+System.Label.Inv2+'></'+System.Label.Promotion+'>'+
                      '<'+System.Label.Promotion+' attr1="z" attr2="y"><else><Symbol>NA</Symbol><Symbol></Symbol><Dollar>1</Dollar><Percentage>1</Percentage></else></'+System.Label.Promotion+'>'+
                      '</testDoc>';//String.ValueOf(sr.body);
            
         }
        else {
            // String excelXMLString = stub.GetCommissionStmt(employeeNum, '11', '2011', secureToken);
             String excelXMLString = stub.GetCommissionStmt(employeeNum, monthCommission, yearCommission, secureToken);
             //String excelXMLString = stub.GetCommissionStmt('62511','10','2011');//'35636','07','2011'
             toParse = excelXMLString ;
         }
         
         doc.load(toParse);   
         DOM.XMLNode root = doc.getRootElement();
         parseData(root);
         return null;
        }catch(Exception eX){
            System.Debug(':::::::ERROR:::::> '+eX+toParse);
            isResponseFound = false;
            Apexpages.Message   exMessage   =   new APexpages.Message(ApexPages.Severity.ERROR, String.valueOf(eX));
            ApexPages.addMessage(exMessage);
        }  
          return null;
   }
   
   
  /* parseData() Method is used to  parse the XML elements */
  private void parseData(DOM.XMLNode node){
    String strKey = '';
    String strValue = '';
    String result = '\n';
      if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
        strKey = node.getName();
     }
     if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
        strValue = node.getText().trim();
     }
     if(node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
        String strNode = node.getName();
        String strParentNode = '';
        
        if(node.getParent() != null) {
            strParentNode = node.getParent().getName();   
        }
        strKey = node.getName();
        if (node.getText().trim() != '') {
            strValue = node.getText().trim();
        }
        
         if(strNode == System.Label.Header) {
            headerFlag=true;
            String monthyearInfo;
            listHeaderInfo = new List<String>();
            List<DOM.XMLNode> arr = node.getChildElements();
             for(DOM.XMLNode cnode : arr)
             {    
                monthyearInfo   = cnode.getText().trim();
                listHeaderInfo.add(monthyearInfo);
             }
        }
        
        if(strNode == System.Label.Exception){   
            exceptionFlag=true;    
            String strExceptionMsg ;
            listExceptionMsg = new List<String>();
            List<DOM.XMLNode> arra = node.getChildElements();
            if (node.getAttributeCount() > 0) {
                for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
                strExceptionMsg = node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
                listExceptionMsg.add(strExceptionMsg);
              } 
            }
        }
        
        if(strNode == System.Label.Payment){
            //String prevNode = '';
            paymentFlag=true;
            listPaymentCalculations = new List<List<String>>();
            List<DOM.XMLNode> arr = node.getChildElements();
            Integer it = 0;
            for(DOM.XMLNode cnode : arr)
            {
             List<String> strKeyList = new List<String>();
             List<String> strValList = new List<String>();
             List<DOM.XMLNode> arrcnode = cnode.getChildElements();
             //String currentNode = cnode.getName();
             Map<String, String> mapPaymentCalculation = new Map<String, String>();
             for(DOM.XMLNode gcnode : arrcnode )
             {
                String name  = gcnode.getName();
                name = name.replace('_', ' ');
                String value = gcnode.getText().trim();
                if(value.equalsIgnoreCase('NA')){
                        value = '';
                }
                 if(value.equalsIgnoreCase('0')){
                    value = '';
                }
                if(name.indexOf('Symbol') > -1){
                    name= '';
                }
                if(name.indexOf('Dollar') > -1){
                    name= name.replace('Dollar', '$');
                }
                if(name.indexOf('Percentage') > -1){
                    name= name.replace('Percentage', '%');
                }
                  strKeyList.add(name);
                  strValList.add(value);
                mapPaymentCalculation.put(name, value );
                totalValue   = mapPaymentCalculation.get('Curr. Mth Payment');
             } 
             if(it == 0)     
             {                         
               listPaymentCalculations.add(strKeyList);
             }
               listPaymentCalculations.add(strValList);
               it++;
        }
        totalPay = listPaymentCalculations.size();
     }

  if(strNode==System.Label.Promotion){
    promotionFlag=true;
    dupVal = 0;
    listPromotion  = new List<List<String>>();
    listPromotion1 = new List<List<String>>();
    listPromotionInv = new List<List<String>>();
    listPromotionInv2 = new List<List<String>>();
    listKeyPromotion = new List<List<String>>();
    List<DOM.XMLNode> arr = node.getChildElements();
    String prevNode = '';
        
    for(DOM.XMLNode cnode : arr)
    {     
    if(cnode.getName().endsWith(System.Label.Inv1)){
       
       //strBounty='1';
       strKeyListInv1 = new List<String>();
       strValListInv1 = new List<String>();            
       List<DOM.XMLNode> arrcnode = cnode.getChildElements();
       String currentNode = cnode.getName();
       String name ;
       String value ;
       for(DOM.XMLNode gcnode : arrcnode ){
            name = gcnode.getName();
            name = name.replace('_', ' ');
            value = gcnode.getText().trim();
            if(value.equalsIgnoreCase('NA')){
                value = '';
            }
            if(value.equalsIgnoreCase('0')){
                value = '';
            }
            if(name.indexOf('Symbol') > -1){
                name= '';
            }
            if(name.indexOf('Dollar') > -1){
                name= name.replace('Dollar', '$');
            }
            if(name.indexOf('Percentage') > -1){
                name= name.replace('Percentage', '%');
            }
            if(name.indexOf('Levels') > -1){
                name= name.replace('Levels', '');
            }
            strKeyListInv1.add(name);
            strValListInv1.add(value);
       }
       listPromotionInv.add(strValListInv1);
       promValueSize = listPromotionInv.size();
      
     }
     
       else if(cnode.getName().endsWith(System.Label.Inv2)){
       strKeyListInv2 = new List<String>();
       strValListInv2 = new List<String>();  
       List<DOM.XMLNode> arrcnode = cnode.getChildElements();
       String currentNode = cnode.getName();
       String name ;
       String value ;
       for(DOM.XMLNode gcnode : arrcnode ){
            name = gcnode.getName();
            name = name.replace('_', ' ');
            value = gcnode.getText().trim();
            if(value.equalsIgnoreCase('NA')){
                value = '';
            }
            if(value.equalsIgnoreCase('0')){
                value = '';
            }
            if(name.indexOf('Symbol') > -1){
                name= '';
            }
            if(name.indexOf('Dollar') > -1){
                name= name.replace('Dollar', '$');
            }
            if(name.indexOf('Percentage') > -1){
                name= name.replace('Percentage', '%');
            }
            if(name.indexOf('Levels') > -1){
                name= name.replace('Levels', '');
            }
            strKeyListInv2.add(name);
            strValListInv2.add(value);
       }
       listPromotionInv2.add(strValListInv2);
       promValueSize2 = listPromotionInv2.size();
      }
      
     
     
    else {  
        
        /*if(cnode.getName().endsWith(System.Label.Inv3)){
           strBounty='0';
           strKeyList = new List<String>();
           strValList = new List<String>();            
           List<DOM.XMLNode> arrcnode = cnode.getChildElements();
           String currentNode = cnode.getName();
           String name ;
           String value ;
           for(DOM.XMLNode gcnode : arrcnode ){
                name = gcnode.getName();
                name = name.replace('_', ' ');
                value = gcnode.getText().trim();
                if(value.equalsIgnoreCase('NA')){
                    value = '';
                }
                if(value.equalsIgnoreCase('0')){
                    value = '';
                }
                if(name.indexOf('Symbol') > -1){
                    name= '';
                }
                if(name.indexOf('Dollar') > -1){
                    name= name.replace('Dollar', '$');
                }
                if(name.indexOf('Percentage') > -1){
                    name= name.replace('Percentage', '%');
                }
                if(name.indexOf('Levels') > -1){
                    name= name.replace('Levels', '');
                }
                strKeyList.add(name);
                strValList.add(value);
           }
            
            if(!prevNode.equals(currentNode))
            {
              listPromotion.add(strKeyList);
            }
            else
            {
              dupVal++;
            }
             listPromotion.add(strValList);
             promoTotalSize=listPromotion.size();
             prevNode = currentNode;
            }*/
            
         // else {
           strBounty='3';
           List<String> strKeyList = new List<String>();
           List<String> strValList = new List<String>();            
           List<DOM.XMLNode> arrcnode = cnode.getChildElements();
           String currentNode = cnode.getName();
                
           for(DOM.XMLNode gcnode : arrcnode ){
                String name = gcnode.getName();
                name = name.replace('_', ' ');
                String value = gcnode.getText().trim();
                if(value.equalsIgnoreCase('NA')){
                    value = '';
                }
                if(value.equalsIgnoreCase('0')){
                    value = '';
                }
                if(name.indexOf('Symbol') > -1){
                    name= '';
                }
                if(name.indexOf('Dollar') > -1){
                    name= name.replace('Dollar', '$');
                }
                if(name.indexOf('Percentage') > -1){
                    name= name.replace('Percentage', '%');
                }
                if(name.indexOf('Levels') > -1){
                    name= name.replace('Levels', '');
                }
                strKeyList.add(name);
                strValList.add(value);
                
           }
            if(!prevNode.equals(currentNode))
            {
              listPromotion.add(strKeyList);
            }
            else
            {
              dupVal++;
            }
           
            listPromotion.add(strValList);
            
            
            promoTotalSize=listPromotion.size();
            prevNode = currentNode;
            //}
           } 
     }
}
        
  if(strNode == System.Label.Sales) {
      salesKickFlag=true;
      colSpan = 0;
      listSalesKickerSalesPerformColumn = new List<List<String>>();
      List<DOM.XMLNode> arr = node.getChildElements();
        
       for(DOM.XMLNode cnode : arr) {
        List<String> strKeyList = new List<String>();
        List<String> strValList = new List<String>();
        List<DOM.XMLNode> arrcnode = cnode.getChildElements();
        for(DOM.XMLNode gcnode : arrcnode ) {
        String name = gcnode.getName();
        name = name.replace('_', ' ');
        String value = gcnode.getText().trim();
        if(value.equalsIgnoreCase('NA')){
            value = '';
        }
         if(value.equalsIgnoreCase('0')){
            value = '';
        }
        if(name.indexOf('Symbol') > -1){
            name= '';
        }
        if(name.indexOf('Dollar') > -1){
            name= name.replace('Dollar', '$');
        }
        if(name.indexOf('Header') > -1){
            name= name.replace('Header', ' ');
        }
         if(name.indexOf('GreaterThan') > -1){
            name= name.replace('GreaterThan', '>');
        }
        
        if(name.indexOf('Percentage') > -1){
            name= name.replace('Percentage', '%');
        }
        if(name.equalsIgnoreCase('Weight')){
            name= '';
        }
        if(name.equalsIgnoreCase('OIPerformance')){
            name= 'O.I. Performance';
        }
        strKeyList.add(name);
        strValList.add(value);
  }
                
     Integer si = strKeyList.size();
    if(si > colSpan ) {
        colSpan = si;
    }
    listSalesKickerSalesPerformColumn.add(strKeyList); 
    listSalesKickerSalesPerformColumn.add(strValList); 
   }
   salesKicker = listSalesKickerSalesPerformColumn.size();
 }
   for (Dom.XMLNode child: node.getChildElements()) {
       parseData(child);           
    }
 }
 
}

public void handleWS(HttpResponse res){
      StaticResource sr = [select id,body from StaticResource Where Name = 'Report1'];
    //String excelXMLString = stub.GetCommissionStmt(employeeNum, monthCommission, yearCommission, secureToken);
   // toParse = excelXMLString();
}         

//Getting The User Details & Spliting the Username
Public List<String> getUserDetails(){
String[] temp;
String fullName;
String id;
String delimiter ;

try{
   listUserDetails = new List<User>();
   reverseNameList = new List<string>();
   listUserDetails = [select Name, EmployeeNumber from User where Id = :UserInfo.getUserId()]; //where EmployeeNumber '100066']; 
     for(User us: listUserDetails ){
      id = us.EmployeeNumber;
      fullName = us.Name; 
      delimiter = ' ';
      temp = fullName.split(delimiter);
      reverseName = temp[1] + ', ' + temp[0];
      reverseNameList.add(reverseName);
    }      
  }
catch(Exception e){
  System.Debug(e);
}
  return reverseNameList;
}

    static testMethod void testSave() {
        List<SecurityToken__c> token = SecurityToken__c.getAll().values();  
        String secureToken = '';
        
        if(token.size() > 0) {
            secureToken = token[0].SecurityToken__c;
        }
        CommissionStatementSalesRep  cc_obj= new CommissionStatementSalesRep();
        String strNode = 'Exception';
        cc_obj.parseIt();
        cc_obj.getUserDetails();
        
        /*HttpResponse res = new HttpResponse();
        cc_obj.handleWS(res);*/
       
        
        ClearPayCommissionStmtClient.GetCommissionStmtResponse_element stub1 
                 = new ClearPayCommissionStmtClient.GetCommissionStmtResponse_element();
        ClearPayCommissionStmtClient.GetCommissionStmt_element stub2 
                 = new ClearPayCommissionStmtClient.GetCommissionStmt_element();  
            stub2.strEmployeeId = '56202';
            stub2.strMonth = '10';
            stub2.strYear = '2011';
            stub2.strToken = secureToken;
    }
}