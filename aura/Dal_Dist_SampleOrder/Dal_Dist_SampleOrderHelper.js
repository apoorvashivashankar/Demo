/**
 * Created by ranja on 23-08-2018.
 */
({
    initLoadData : function (cmp) {
        //console.log('INIT HELPER METHOD OF 3rd Page');

        //Set Todays Date
        this.setTodaysDate(cmp);

        //Set Shipping Info
        this.setShippingInfo(cmp);

        // set order info
        this.setOrderInfo(cmp);

        // set products list
        this.setProductInfo(cmp);

        //set spinner for base class to false
        cmp.set('v.isSampleOrderBaseLoading' , false);
    },

    setProductInfo : function (cmp) {
        var products = cmp.get('v.productOrderLines');
        //console.log('In product Info');
        var tempProducts = [];

        for(var x=0; x<products.length; x++){
            products[x].estimatedAvailabilityDate = cmp.get('v.today');
            //products[x].unitOfMeasureSelected = cmp.get();
            if((typeof(products[x].sku) != undefined && products[x].sku != null && products[x].sku != '') &&
                (typeof(products[x].availableQty) != undefined && products[x].availableQty != null && products[x].availableQty != '')){
                //console.log('in IF');
                tempProducts.push(products[x]);
            }
        }

        //console.log('tempProducts:', tempProducts);
        cmp.set('v.products', tempProducts);

    },

    setOrderInfo : function (cmp) {

        var orderInfo = cmp.get('v.orderInfo');
        orderInfo.poNumber = cmp.get('v.poNumber');
        orderInfo.jobName = cmp.get('v.jobName');
        orderInfo.cumulativeOrderWeight = cmp.get('v.cumulativeOrderWeight');
        //console.log('orderInfo:', JSON.parse(JSON.stringify(orderInfo)));
        cmp.set('v.orderInfo', orderInfo);

    },

    setShippingInfo : function (cmp) {
        var selectedAddress = cmp.get('v.selectedAddress');
        var shippingInfo = cmp.get('v.shippingInfo');

        shippingInfo.shipToName =  selectedAddress.name;
        shippingInfo.shipToCareOf = selectedAddress.careOf;
        shippingInfo.shipToStreet1 = selectedAddress.street1;
        shippingInfo.shipToStreet2 = selectedAddress.street2;
        shippingInfo.shipToCity = selectedAddress.city;
        shippingInfo.shipToState = selectedAddress.state;
        shippingInfo.shipToZipcode = selectedAddress.zipcode;
        shippingInfo.shipToCountry = selectedAddress.country;
        shippingInfo.freightTerms = cmp.get('v.freightTerms');
        shippingInfo.carrier = cmp.get('v.carrier');
        shippingInfo.isShipComplete = cmp.get('v.isShipComplete');
        shippingInfo.isSmallPackage = cmp.get('v.isSmallPackage');
        shippingInfo.cumulativeOrderWeight = cmp.get('v.cumulativeOrderWeight');

        if(shippingInfo.freightTerms === '1A1'){
            shippingInfo.freightTerms = 'Prepaid';
        }

        //console.log('shippingInfo JSON:', JSON.parse(JSON.stringify(shippingInfo)));
        cmp.set('v.shippingInfo', shippingInfo);
    },

    setTodaysDate : function (cmp) {
        var _currentDate = new Date();
        var _month = _currentDate.getMonth() + 1;
        var _date = _currentDate.getDate();
        var _year = _currentDate.getFullYear().toString();
        //console.log('_year: ',_year);
        _year = _year.substr(2,2);
        //console.log('_year: ',_year);
        if(_month < 10)
            _month = '0' + _month;
        if(_date < 10)
            _date = '0' + _date;


        var _newDate =  _month  + '/' + _date + '/' + _year ;
        //console.log('NEW DATE: ' , _newDate);
        cmp.set('v.today', _newDate);

    },

    fireAnEvent : function(cmp,currentPosition) {
        //console.log('FIre Event method');

       var orderProcessStepEvt = $A.get('e.c:Dal_Dist_OrderProcessStepEvt');
       orderProcessStepEvt.setParams({
            'currentPos': currentPosition
       });
       orderProcessStepEvt.fire();
       //console.log('EVENT FIRED');
    },

    submitOrder : function(cmp,event,helper) {
        //console.log('handleSubmit helper');

        var products = cmp.get('v.products');
        var wrapperData = cmp.get('v.wrapperData');
        var shippingInfo = cmp.get('v.shippingInfo');
        var orderInfo = cmp.get('v.orderInfo');

        wrapperData.productOrderLines = cmp.get('v.productOrderLines');

        //console.log('done until');
        //console.log('Wrapper Data: ' , wrapperData);
        wrapperData.cumulativeOrderWeight = cmp.get('v.cumulativeOrderWeight');
        wrapperData.orderDetails.selectedAddress = cmp.get('v.selectedAddress');
        wrapperData.orderDetails.freightTerms = shippingInfo.freightTerms;
        wrapperData.orderDetails.isShipComplete = shippingInfo.isShipComplete;
        wrapperData.orderDetails.carrier = shippingInfo.carrier;
        wrapperData.orderDetails.isSmallPackage = shippingInfo.isSmallPackage;
        wrapperData.orderDetails.poNumber = orderInfo.poNumber;
        wrapperData.orderDetails.jobName = orderInfo.jobName;
        //console.log('Wrapper Data: ' , wrapperData.cumulativeOrderWeight);
        //console.log('Wrapper Data: ' , wrapperData.productOrderLines);
        //console.log('Wrapper Data: ' , wrapperData.orderDetails);

        cmp.set('v.wrapperData',wrapperData);
        var wrapperDataInString = JSON.stringify(wrapperData);

        var params = {
                       wrapperDataForOrder :  wrapperDataInString
                     };
        //console.log('Params' , wrapperDataInString);
        cmp.set('v.isSaving',true);
        helper.doCalloutForSampleOrder(cmp,'c.createSampleOrder',params,function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                //console.log('Success Calling method');
                //console.log('Resp: ' , response.getReturnValue());
                var data = response.getReturnValue();
                if(data) {
                if(products.length > 0) {
                     for (var i=0;i<products.length;i++) {
                        products[i].cartonCount = data.orderLineList[i].cartonCount;
                        products[i].color = data.orderLineList[i].color;
                        products[i].size = data.orderLineList[i].size;
                        products[i].quantityCancelled = data.orderLineList[i].quantityCancelled;
                        products[i].quantityShippedInvoiced = data.orderLineList[i].quantityShippedInvoiced;
                        products[i].sourceOfSupply = data.orderLineList[i].sourceOfSupply;
                        products[i].pieceCount = data.orderLineList[i].pieceCount;
                        products[i].sellingUOM = data.orderLineList[i].sellingUOM;
                        products[i].sellingQTY = data.orderLineList[i].sellingUOM;
                     }
                }
                orderInfo.salesOrderTypeDesc = data.salesOrderTypeDesc;
                shippingInfo.shipFromStreet = data.Account_From_Address_Line1;
                shippingInfo.shipFromName = data.Account_From_Address_Name;
                shippingInfo.shipFromCity = data.Account_From_Address_City;
                shippingInfo.shipFromState = data.Account_From_Address_StateProvince;
                shippingInfo.shipFromZipcode = data.Account_From_Address_PostalCode;
                shippingInfo.shipFromCountry = data.Account_From_Address_Country;
                //shippingInfo.isShipComplete = data.isShipComplete;
                cmp.set('v.shippingInfo',shippingInfo);
                cmp.set('v.products',products);
                cmp.set('v.orderInfo',orderInfo);
                cmp.set('v.ordernumber',data.ordernumber);
                cmp.set('v.isSaving',false);
                helper.doGotoURL('/order-detail?ordernumber=' +data.ordernumber );
                } else {
                    cmp.set('v.isSaving',false);
                }
            } else if (state === "ERROR") {
                  var errors = response.getError();
                  if (errors) {
                      if (errors[0] && errors[0].message) {
                          //console.log("Error message: " + errors[0].message);
                           cmp.set('v.isSaving',false);
                      }
                  } else {
                      helper.showtoast('Error occured while submitting sample order','error');
                      cmp.set('v.isSaving',false);
                  }
              }
        });
    },

    checkWeight : function (cmp) {
        var productOrderLines = cmp.get('v.productOrderLines');
        var weight = 0;
        var diffSourcesSOS = new Map();

        for(var i=0;i<productOrderLines.length;i++) {
            if(diffSourcesSOS.has(productOrderLines[i].sourceOfSupply)) {
                weight = diffSourcesSOS.get(productOrderLines[i].sourceOfSupply);
                weight = parseFloat(weight) + (parseFloat(productOrderLines[i].ExtendedWeight) * parseFloat(productOrderLines[i].selectedQuantity));
                weight = weight.toFixed(2);
                diffSourcesSOS.set(productOrderLines[i].sourceOfSupply,weight);
                if(weight > 150) {
                    cmp.set('v.isMore', true);
                    break;
                } else {
                     cmp.set('v.isMore', false);
                }

            } else {
                weight = diffSourcesSOS.get(productOrderLines[i].sourceOfSupply);
                if(!weight) {
                    weight = 0;
                    diffSourcesSOS.set(productOrderLines[i].sourceOfSupply, weight);
                }
                weight = diffSourcesSOS.get(productOrderLines[i].sourceOfSupply);
                weight = parseFloat(weight) + (parseFloat(productOrderLines[i].ExtendedWeight) * parseFloat(productOrderLines[i].selectedQuantity));
                weight = weight.toFixed(2);
                diffSourcesSOS.set(productOrderLines[i].sourceOfSupply, weight);
                if(weight > 150) {
                    cmp.set('v.isMore', true);
                    break;
                } else {
                     cmp.set('v.isMore', false);
                }
            }
        }
    }

})