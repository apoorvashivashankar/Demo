@isTest
global class WebServiceMockImpl implements WebServiceMock {

    ClearPayCommissionStmtClient.GetCommissionStmtResponse_element response_x;
    Map<String, ClearPayCommissionStmtClient.GetCommissionStmtResponse_element> response_map_x = new Map<String, ClearPayCommissionStmtClient.GetCommissionStmtResponse_element>();
    
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            response_x = response_map_x.get('response_x');
            response_map_x.put('response_x', response_x);
        }
}