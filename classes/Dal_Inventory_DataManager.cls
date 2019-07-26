public class Dal_Inventory_DataManager {
    public class PubEndpoint {
        public String endpoint_x = 'callout:DT_SYS_Inventory';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://schemas.nevatech.com/services/', 'Dal_Inventory_DataManager', 'http://schemas.datacontract.org/2004/07/DAL_Canonical_Inventory.OM', 'Dal_Inventory_DataContract', 'http://schemas.microsoft.com/2003/10/Serialization/', 'Dal_InventoryMicrosoft', 'http://schemas.daltile.com/Integration/Inventory', 'Dal_Inventory_DataController'};
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtSourcesOfSupply(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupplyRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupplyRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupplyResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupplyResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupplyResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtSourcesOfSupply',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupplyResponse',
                            'Dal_Inventory_DataController.GetInventoryAtSourcesOfSupplyResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtNearbySSCS_ByMileRadius_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadius_ctxRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadius_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadius_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadius_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadius_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtNearbySSCS_ByMileRadius_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtNearbySSCS_ByMileRadius_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtNearbySSCS_ByMileRadius_ctxResponse',
                            'Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadius_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtSourcesOfSupply_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_ctxRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtSourcesOfSupply_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_ctxResponse',
                            'Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtSourcesOfSupply_TimePhased(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhasedRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhasedRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhasedResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhasedResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhasedResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtSourcesOfSupply_TimePhased',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_TimePhased',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_TimePhasedResponse',
                            'Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhasedResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtSourcesOfSupply_TimePhased_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhased_ctxRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhased_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhased_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhased_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhased_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtSourcesOfSupply_TimePhased_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_TimePhased_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_TimePhased_ctxResponse',
                            'Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhased_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtLocation_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetInventoryAtLocation_ctxRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtLocation_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetInventoryAtLocation_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtLocation_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_ctxResponse',
                            'Dal_Inventory_DataController.GetInventoryAtLocation_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtLocation(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetInventoryAtLocationRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtLocationRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetInventoryAtLocationResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtLocationResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtLocationResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtLocation',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocationResponse',
                            'Dal_Inventory_DataController.GetInventoryAtLocationResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtSourcesOfSupply_AvailabilityDate_Price(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtSourcesOfSupply_AvailabilityDate_Price',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_AvailabilityDate_Price',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceResponse',
                            'Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtLocation_AvailabilityDate_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDate_ctxRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDate_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDate_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDate_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDate_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtLocation_AvailabilityDate_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_AvailabilityDate_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_AvailabilityDate_ctxResponse',
                            'Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDate_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtLocation_TimePhased_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetInventoryAtLocation_TimePhased_ctxRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtLocation_TimePhased_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetInventoryAtLocation_TimePhased_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_TimePhased_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_TimePhased_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtLocation_TimePhased_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_TimePhased_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_TimePhased_ctxResponse',
                            'Dal_Inventory_DataController.GetInventoryAtLocation_TimePhased_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtSourcesOfSupply_AvailabilityDate_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtSourcesOfSupply_AvailabilityDate_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_AvailabilityDate_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxResponse',
                            'Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtLocation_ByShade_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetInventoryAtLocation_ByShade_ctxRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtLocation_ByShade_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetInventoryAtLocation_ByShade_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_ByShade_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_ByShade_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtLocation_ByShade_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_ByShade_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_ByShade_ctxResponse',
                            'Dal_Inventory_DataController.GetInventoryAtLocation_ByShade_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtLocation_AvailabilityDate(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDateRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDateRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDateResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDateResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDateResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtLocation_AvailabilityDate',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_AvailabilityDate',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_AvailabilityDateResponse',
                            'Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDateResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxResponse',
                            'Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetSourcesOfSupply_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetSourcesOfSupply_ctxRequestBody request_x = new Dal_Inventory_DataController.GetSourcesOfSupply_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetSourcesOfSupply_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetSourcesOfSupply_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetSourcesOfSupply_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetSourcesOfSupply_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetSourcesOfSupply_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetSourcesOfSupply_ctxResponse',
                            'Dal_Inventory_DataController.GetSourcesOfSupply_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtSourcesOfSupply_AvailabilityDate(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDateRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDateRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDateResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDateResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDateResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtSourcesOfSupply_AvailabilityDate',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_AvailabilityDate',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtSourcesOfSupply_AvailabilityDateResponse',
                            'Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDateResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtLocation_ByShade(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtLocation_ByShade',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_ByShade',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_ByShadeResponse',
                            'Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtLocation_TimePhased(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtLocation_TimePhased',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_TimePhased',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtLocation_TimePhasedResponse',
                            'Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtNearbySSCS_ByMileRadius(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtNearbySSCS_ByMileRadius',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtNearbySSCS_ByMileRadius',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtNearbySSCS_ByMileRadiusResponse',
                            'Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetSourcesOfSupply(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetSourcesOfSupplyRequestBody request_x = new Dal_Inventory_DataController.GetSourcesOfSupplyRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetSourcesOfSupplyResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetSourcesOfSupplyResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetSourcesOfSupplyResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetSourcesOfSupply',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetSourcesOfSupply',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetSourcesOfSupplyResponse',
                            'Dal_Inventory_DataController.GetSourcesOfSupplyResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtNearbySSCS_ctx(Dal_Inventory_DataController.InventoryRequest request,Dal_Inventory_DataController.ServiceContext context) {
            Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ctxRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ctxRequestBody();
            request_x.request = request;
            request_x.context = context;
            Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ctxResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ctxResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ctxResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtNearbySSCS_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtNearbySSCS_ctx',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtNearbySSCS_ctxResponse',
                            'Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ctxResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
        public Dal_Inventory_DataController.InventoryResponse GetInventoryAtNearbySSCS(Dal_Inventory_DataController.InventoryRequest request) {
            Dal_Inventory_DataController.GetInventoryAtNearbySSCSRequestBody request_x = new Dal_Inventory_DataController.GetInventoryAtNearbySSCSRequestBody();
            request_x.request = request;
            Dal_Inventory_DataController.GetInventoryAtNearbySSCSResponseBody response_x;
            Map<String, Dal_Inventory_DataController.GetInventoryAtNearbySSCSResponseBody> response_map_x = new Map<String, Dal_Inventory_DataController.GetInventoryAtNearbySSCSResponseBody>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            'http://schemas.daltile.com/Integration/Inventory/ICanonicalInventoryService/GetInventoryAtNearbySSCS',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtNearbySSCS',
                            'http://schemas.daltile.com/Integration/Inventory',
                            'GetInventoryAtNearbySSCSResponse',
                            'Dal_Inventory_DataController.GetInventoryAtNearbySSCSResponseBody'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.Response;
        }
    }
}