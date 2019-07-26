public without sharing class Order_TrackingHandler 
    implements ITrigger
    {

    List<Map<List<FeedItem>, List<ConnectApi.FeedItemInput>>>  insertOrderTrackingPost = new List<Map<List<FeedItem>, List<ConnectApi.FeedItemInput>>> ();
    Map<List<FeedItem>, List<ConnectApi.FeedItemInput>> mapFeedToInput = new Map<List<FeedItem>, List<ConnectApi.FeedItemInput>>();
    List<FeedItem> listKeys = new List<FeedItem>(); 

    public void bulkBefore()
    {
    }
 
    public void bulkAfter()
    {       
        if (Trigger.isInsert || Trigger.isUpdate) 
        {
	        insertOrderTrackingPost = Order_TrackingGateway.newChatterTrackingUpdate(Trigger.newMap.keySet()); 
	        for (Map<List<FeedItem>, List<ConnectApi.FeedItemInput>> ot : insertOrderTrackingPost) {
	            	for (List<FeedItem> bi : ot.keySet()) {
	                listKeys.addAll(bi);    
	            }
                mapFeedToInput.putAll(ot);
	        }
        }
    }
 
    public void beforeInsert(SObject so)
    {
    }
 
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }
 
    public void beforeDelete(SObject so)
    {
    }

    public void afterInsert(SObject so) 
    {
    }
 
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
 
    public void afterDelete(SObject so)
    {
    }
 
    public void andFinally()
    {      
        if(insertOrderTrackingPost.size()>0){
            for (Map<List<	FeedItem>, List<ConnectApi.FeedItemInput>> fe:insertOrderTrackingPost) {
                for (List<FeedItem> listBatch : fe.keySet()) {
                    List <ConnectApi.FeedItemInput> listInput = mapFeedToInput.get(listBatch);
                    for (FeedItem post:listBatch) {
                        try{
                            insert post;	
                            System.debug('SUCCESS + post: ' + post);  
                            FeedItem feed = listKeys.get(0);
                            if (listInput != null && listInput.size() > 0) {
                                for (ConnectApi.FeedItemInput input : listInput) {
                                    ConnectApi.ChatterFeeds.updateFeedElement( Network.getNetworkId(), feed.id, input );
                                }
                            }
                        } catch (ListException e) {
                            System.debug('FAILURE: ' + e);
                        }
                    }
                }
            }                 
        }
    }
}