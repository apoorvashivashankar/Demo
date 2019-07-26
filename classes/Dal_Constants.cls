/**
        * Created by 7Summits on 2/12/18.
        */

public with sharing class Dal_Constants {

    // Custom Profile Names
    public static final string PROFILE_COMMUNITY_MANAGER = 'Community Manager';
    public static final string PROFILE_DISTRIBUTOR = 'Distributor';
    public static final string PROFILE_SSCEMPLOYEE = 'SSC Employee';
    public static final string PROFILE_INTEGRATIONUSER = 'Integration User';
    public static final string COMMUNITY_TYPE_DIST = 'Distributor';
    public static final string COMMUNITY_TYPE_SSC = 'SSC';
    public static final string SESSION_ORDER_NAME = 'CurrentOrder';
    public static final string DISTRIBUTOR_COMMUNITY = 'Distributor Community';
    public static final string SSC_COMMUNITY = 'SSC Community';
    public static final string SAP_Plant = 'SAP_Plant';

    public static final List<String> DISTRIBUTOR_ALL_ORDER_STATUSES = new List<String>{'Order Received','Order Received - Awaiting Date',
            'Pick Scheduled', 'Pick in Progress','Shipped','Invoiced','Cancelled','Review'};

    public static final List<String> DISTRIBUTOR_OPEN_ORDER_STATUSES = new List<String>{'Order Received',/*'Delivery Created',*/
            'Order Received - Awaiting Date', 'Pick Scheduled', 'Pick in Progress','Review'};

    public static final List<String> DISTRIBUTOR_ORDER_HISTORY_STATUSES = new List<String>{'Shipped', 'Invoiced','Cancelled '};

    //using community friendly status and not actual OASIS status to query order list in search function. Also DT is sending Community friendly name back in Statusdesc2 field. - AP
    public static final List<String> SSC_All_ORDER_STATUSES = new List<String>{
            'Accepted','Arrived - Unloading Truck','Backorder','In Progress','In Transit To SSC','Packing In Progress','Picked Up',
            'Ready For Delivery','Ready For Pickup','Return Requested','Return Processed',
            'Scheduled for Delivery','Scheduled for Pick Up','Shipped'};

    //using community friendly status and not actual OASIS status to query order list in search function. Also DT is sending Community friendly name back in Statusdesc2 field. - AP
    public static final List<String> SSC_OPEN_ORDER_STATUSES = new List<String>{
            'Accepted','Arrived - Unloading Truck','Backorder','In Progress','In Transit To SSC','Packing In Progress',
            'Ready For Delivery','Ready For Pickup','Return Requested',
            'Scheduled for Delivery','Scheduled for Pick Up'};

    public static final List<String> SSC_COMPLETED_ORDER_STATUSES = new List<String>{'Shipped','Picked Up','Return Processed'};
    public static final List<String> SSC_ORDERS_FOR_PICKUP_STATUSES = new List<String>{'Arrived - Unloading Truck','Ready For Pickup','Ready For Delivery'};
    public static final List<String> SSC_PICKUPS_DELIVERIES_TO_BE_SCHEDULED_ORDER_STATUSES = new List<String>{'Accepted - Inventory Assigned'};
    public static final List<String> SSC_SCHEDULED_PICKUP_ORDER_STATUSES = new List<String>{'Scheduled for Pick Up','Packing In Progress','Ready Pending Pick Up'};
    public static final List<String> SSC_SCHEDULED_DELIVERY_ORDER_STATUSES = new List<String>{'Scheduled for Delivery','Ready Pending Delivery','Packing In Progress'};


    //Frieght Terms Mapping
    public static final Map<String,String> COMMUNITY_FRIEGHT_TERMS = new Map<String, String>{
            '1A1' => 'Prepaid',
            '1A2' => 'Prepaid & Add',
            '1A3' => 'Collect'
    };
    public static final Map<String,String> SHIPFROM_LOCATION = new Map<String, String>{
            '4005' => 'Lewisport',
            '4009' => 'Fayette',
            '4101' => 'Sunnyvale',
            '4140' => 'Pembroke Park',
            '4170' => 'Gettysburg',
            '4200' => 'Monterrey - Mexico',
            '4238' => 'El Paso',
            '4349' => 'Ontario',
            '4351' => 'Eldersburg',
            '4600' => 'Muskogee',
            '4630' => 'Dickson',
            '4660' => 'Clay Rd',
            '4661' => 'Florence',
            '4662' => 'Davenport'
    };

    //Webservices parameters
    public static final string LEGACY = 'Legacy';
    public static final string LEGACY_CUSTOMER = 'LegacyCustomer';
    public static final string FULFILMENT_HOST_TYPE = 'Salesforce';
    public static final string LEGACY_CUSTOMER_SHIP_TO = 'Legacy CustomerShipTo';
    public static final Set<String> SSC_DIVISION = new Set<String>{'40','41'};

    //External objects query limit params
    public static final Integer ORDERQUERYLIMIT = 500;

    public static final Map<String,String> CARRIER = new Map<String, String>{
            'UPS' => 'UPS Ground',
            'UPSS' => 'UPS Residential Ground',
            'UP1S' => 'UPS Next Day Air 3PM',
            'UP2' => 'UPS 2nd Day Air',
            'UP3' => 'UPS 3rd Day Air',
            'UP1' => 'UPS Next Day Air 10AM',
            'UPS4' => 'UPS Thursday for Saturday Delivery',
            'UPS5' => 'UPS Friday for Saturday Delivery'
    };

    // Distributor Community Profile Names
    public static final string DIST_CUST_SERVICE = 'Distributor Customer Service';
    public static final string DIST_PURCHASER = 'Distributor Purchaser';
    public static final string DIST_ACCOUNTING = 'Distributor Accounting';
    public static final string DIST_SALES_REP = 'Distributor Sales Rep';
    public static final string DIST_SALES_REP_1 = 'Distributor Sales Rep1';
    public static final string DIST_LEADER_PRINCIPLE = 'Distributor Leadership/Principle';

    // SSC Community Profile Names
    public static final string SSC_CUST_SERVICE = 'SSC Customer Service';
    public static final string SSC_PURCHASER = 'SSC Purchaser';
    public static final string SSC_PURCHASER_II = 'SSC Purchaser II';
    public static final string SSC_ACCOUNTING = 'SSC Accounting';
    public static final string SSC_SALES_REP = 'SSC Sales Rep';
    public static final string SSC_LEADER_PRINCILPLE = 'SSC Leadership/Principle';
    public static final string SSC_DEALER_SALES_REP = 'SSC Statement Dealer Sales Rep';
    public static final string SSC_DEALER_LEADER_PRINCILPLE = 'SSC Statement Dealer Leadership / Principle';

    public static set<string> SSC_TEAM_SET_40 = new Set<String>{
            'GLAZED WALL TILE (0001)',
            'CERAMIC MOSAICS (0002)',
            'QUARRY (0003)',
            'GLAZED FLOOR TILE (0004)',
            'COLORBODY PORCELAIN (0006)',
            'NATURAL STONE TILE (0009)',
            'STONE SLAB (0014)',
            'INSTALLATION PRODUCT (0005)'};

    public static set<string> SSC_TEAM_SET_41 = new Set<String>{
            'GLAZED WALL TILE (0001)',
            'CERAMIC MOSAICS (0002)',
            'QUARRY (0003)',
            'GLAZED FLOOR TILE (0004)',
            'COLORBODY PORCELAIN (0006)',
            'NATURAL STONE TILE (0009)'};

    public static final string SSC_ALLIED_PRODUCTS = '0005';

    public static set<string> UOM_Set = new Set<String>{
            'RL','EA','PC','PK','ST','CD','SP','SH'
    };

    public static final Map<String,String> FRIEGHTTERMS = new Map<String, String>{
            'Prepaid' => '1A1',
            'Prepaid & add' => '1A2',
            'Collect' => '1A3'

    };

}