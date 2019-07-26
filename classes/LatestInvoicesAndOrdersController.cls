/* This is the controller class for the VF page LatestInvoicesAndOrders and contains logic to get the Last 5 Invoices
and orders for a given account from webservice developed by Daltile.*/
public class LatestInvoicesAndOrdersController {
	public List<wrapOrder> orders {get;set;}
	public List<wrapInvoice> invoices {get;set;}
	public Account account {get;set;}
	
	/*This is method to detrmine if there are any orders received from the webservice for the account in context. 
	It Returns true if there are any orders and false otherwise.*/
	public boolean getHasOrders()
	{
		return orders.size()>0;
	}
	
	/*This is method to detrmine if there are any invoices received from the webservice for the account in context. 
	It Returns true if there are any invoices and false otherwise.*/
	public boolean getHasInvoices()
	{
		return invoices.size()>0;
	}
	
	/*This is the calss constructor and queries the account table to get Customer_Base__c and Customer_Suffix__C
	for the account in context. If one of these fields is null, the constructor adds an error message to the page.*/
	public LatestInvoicesAndOrdersController (ApexPages.StandardController stdController)
	{
		try
		{
			this.orders=new List<wrapOrder>();
			this.invoices=new List<wrapInvoice>();
			this.account = (Account)stdController.getRecord();
			this.account=[select id,Name,Customer_Base__C,Customer_Suffix__C from Account where id=:account.Id];
			if(account.Customer_Base__c==null || account.Customer_Suffix__C==null)
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Customer Base and Customer Suffix are required!'));				
			}			
		}
		catch(Exception ex)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Failed to Load Orders/Invoices! You Might not have access to the Account. '+ex));
		}
	}
	/*This method prepares a list of Invoices and orders by parsing the XML response received from the webservice.*/
	private void prepareInvoiceAndOrderList(string responseXML)
	{
		//initilize XML reader
		XmlStreamReader reader = new XmlStreamReader(responseXML);
     	wrapOrder currentOrder=null;
     	wrapInvoice currentInvoice=null;
     	boolean insideOrder;
         	
     	while(reader.hasNext())
		{
			if (reader.getEventType() == XmlTag.START_ELEMENT) 	
			{
				if ('Invoice'.equalsIgnoreCase(reader.getLocalName())) 
				{
					if(currentInvoice!=null)
					{							
						invoices.add(currentInvoice);							
					}				
					currentInvoice = new wrapInvoice();	
					insideOrder=false;												
				}		
				if ('Order'.equalsIgnoreCase(reader.getLocalName())) 
				{
					if(currentOrder!=null)
					{							
						orders.add(currentOrder);							
					}				
					currentOrder = new wrapOrder();	
					insideOrder=true;												
				}				
				else
				{	
					if('Invoice_Date'.equalsIgnoreCase(reader.getLocalName()))
					{
						currentInvoice.invoiceDate=getInnerXml(reader);
					}
					else if('Invoice_Number'.equalsIgnoreCase(reader.getLocalName()))
					{
						currentInvoice.invoiceNumber=getInnerXml(reader);
					}
					else if('Sales_Slip_Number'.equalsIgnoreCase(reader.getLocalName()))
					{
						currentInvoice.salesSlipNumber=getInnerXml(reader);
					}
					else if('Order_Date'.equalsIgnoreCase(reader.getLocalName()))
					{
						currentOrder.orderDate=getInnerXml(reader);
					}
					else if('Order_Number'.equalsIgnoreCase(reader.getLocalName()))
					{
						currentOrder.orderNumber=getInnerXml(reader);
					}
					else if('Location_Name'.equalsIgnoreCase(reader.getLocalName()))
					{
						currentOrder.locationName=getInnerXml(reader);
					}
					
					if('Job_Name'.equalsIgnoreCase(reader.getLocalName()))
					{
						if(insideOrder)
						{
							currentOrder.jobName=getInnerXml(reader);
						}
						else
						{
							currentInvoice.jobName=getInnerXml(reader);
						}
					}
					if('Total_Amount'.equalsIgnoreCase(reader.getLocalName()))
					{
						if(insideOrder)
						{
							currentOrder.totalAmount=getInnerXml(reader);
						}
						else
						{
							currentInvoice.totalAmount=getInnerXml(reader);
						}							
					}					
				}
			}
			reader.next();
		}
		//add last invoice
		if(currentInvoice!=null)
		{							
			invoices.add(currentInvoice);							
		}	
		
		//add last order
		if(currentOrder!=null)
		{							
			orders.add(currentOrder);							
		}
	}
	/*This method gets a response XML from the webservice by passing the Customer Base, Customer Suffix and a token. The 
	method also calls the prepareInvoiceAndOrderList by passing the raw XML to prepare the order and invoice list. If the
	method is running under a test context, it returns a predefined XML from a static resource as SFDC doesn't do actual 
	webservice callouts during testing context.*/
	public PageReference getInvoicesAndOrders() 
	{
		if(account!=null)
		{
			if(account.Customer_Base__c!=null && account.Customer_Suffix__C!=null)
			{
				try
				{
					String webServiceToken=Invoice_and_Order_Webservice_Token__c.getInstance('Invoice_and_Order_Webservice_Token').Token__c;
					InvoicesAndOrdersWebServiceStub.BasicHttpBinding_IInvoicesAndOrders  orderinvoiceservice=new InvoicesAndOrdersWebServiceStub.BasicHttpBinding_IInvoicesAndOrders();
		         	orderinvoiceservice.timeout_x=120000;		         	
		         	String responseXML=null;
		         	if(Test.isRunningTest()) 
		         	{
		         		StaticResource sampleResponse = [select id,body from StaticResource Where Name = 'SampleLast5InvoiceOrderResponse'];
            			responseXML = sampleResponse.body.toString();
		         	}	
		         	else
		         	{
		         		responseXML=orderinvoiceservice.GetTLastFiveInvoiceAndOrders(account.Customer_Base__C ,
		         		account.Customer_Suffix__C,webServiceToken);		         		
		         	}		         		         	
		         	prepareInvoiceAndOrderList(responseXML);		         			         	
				}
				catch(Exception ex)
				{
					if(ex.getMessage().contains('Read timed out'))
					{
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'The network is busy, please retry shortly...'));
					}
					else
					{					
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Failed to call Invoice/Order Webservice! Please contact Your System Administrator with the following error: '+ex));
					}
				}
			}         	         
		}
        return null;
    }
    /*This method is used to extract the character value inside an XML element.*/
	private static string getInnerXml(XmlStreamReader r)
	{
		while(r.hasNext())
		{
			if(r.getEventType() == XmlTag.CHARACTERS)
			{
				return r.getText().trim();
			}
			if(r.getEventType() == XmlTag.END_ELEMENT)
			{
				break;
			}
			r.next();
		}		
		return null;
	}	
	/*This is a class used to represent an Order returnd from the webservice.*/
	public class wrapOrder
	{
		public string orderDate {get;set;}
		public string orderNumber {get;set;}
		public string locationName {get;set;}
		public string jobName {get;set;}
		public string totalAmount {get;set;}
		public boolean getIsNegative()
		{			
			return getDecimalIsNegative(totalAmount);
		} 
		public Decimal getFormattedTotal()
		{
			return  getDecimalFromText(totalAmount);
		}
	}
	/*This is a class used to represent an invoice returnd from the webservice.*/
	public class wrapInvoice
	{
		public string invoiceDate {get;set;}
		public string invoiceNumber {get;set;}
		public string salesSlipNumber {get;set;}
		public string jobName {get;set;}
		public string totalAmount {get;set;}
		public boolean getIsNegative()
		{			
			return getDecimalIsNegative(totalAmount);
		} 
		public Decimal getFormattedTotal()
		{
			return  getDecimalFromText(totalAmount);
		}
	}
	/*This method converts the text value of any decimal to a decimal type. If the text doesn't represent a valid decimal, 
	a 0.0 value is returned. If the decimal value is negative, the postive value of the decimal is returned.*/
	public static Decimal getDecimalFromText(string textValue)
	{
		Decimal decimalValue=0.0;
		try
		{
			decimalValue=Decimal.valueof(textValue);
			if(decimalValue<0)
			{
				decimalValue=-1*decimalValue;					
			}
		}
		catch(Exception ex)
		{//do noting
		}
		return decimalValue;
	}
	/*This method detrmines if the text value of a decimal is positive or negative. If the text doesn't represent a valid decimal, 
	a 0.0 value is considered.The method returns true if the resulting decimal is negative and false otherwise.*/
	public static boolean getDecimalIsNegative(string textValue)
	{
		boolean isNegative=false;		
		try
		{
			Decimal decimalValue=Decimal.valueof(textValue);
			if(decimalValue<0)
			{
				isNegative=true;					
			}
		}
		catch(Exception ex)
		{//do noting
		}
		return isNegative;
	}
}