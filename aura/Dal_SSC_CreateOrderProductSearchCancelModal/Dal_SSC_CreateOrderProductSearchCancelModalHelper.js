({
    handleMyTeamSuccess: function(cmp, response){
        
        if(response !== Array.isArray(response)
           && response[0] !== undefined && response[0].success === true
           && response[0].results !== undefined && Array.isArray(response[0].results)
           && response[1] !== undefined && response[1].success === true
           && response[1].results !== undefined && Array.isArray(response[1].results)){
            
            var myReps = [];
            
            // My Credit rep
            if(response[0].results[0] !== undefined){
                myReps.push(this.getMyCreditRep(response[0].results[0]));
            } 
            
            // My Sales rep
            if(response[1].results[0] !== undefined){
                myReps.push(this.getMySalesRep(response[1].results[0]));
            }
            
            console.log('MY RESP: ', myReps);
            // set the view attributes
            cmp.set('v.myReps', myReps);
        }
    },
    
    /**
     * Create my credit rep
     * @param rep
     * @returns {*|{firstName, lastName, title, phone, email}}
     */
    getMyCreditRep: function(rep){
        return this.createRep(
            (rep.Customer_Credit_Rep_Position__r !== undefined) ? rep.Customer_Credit_Rep_Position__r.First_Name__c : '',
            (rep.Customer_Credit_Rep_Position__r !== undefined) ? rep.Customer_Credit_Rep_Position__r.Last_Name__c : '',
            (rep.Customer_Credit_Rep_Position__r !== undefined) ? rep.Customer_Credit_Rep_Position__r.Type__c : '',
            (rep.Customer_Credit_Rep_Position__r !== undefined) ? rep.Customer_Credit_Rep_Position__r.Phone__c : '',
            (rep.Customer_Credit_Rep_Position__r !== undefined) ? rep.Customer_Credit_Rep_Position__r.Email__c : '',
            'creditRep'
        );
    },
    
    /**
     * Create my sales rep
     * @param rep
     * @returns {*|{firstName, lastName, title, phone, email}}
     */
    getMySalesRep: function(rep){
        return this.createRep(
            (rep.Salesman__r !== undefined && rep.Salesman__r.User__r !== undefined) ? rep.Salesman__r.User__r.FirstName : '',
            (rep.Salesman__r !== undefined && rep.Salesman__r.User__r !== undefined) ? rep.Salesman__r.User__r.LastName : '',
            (rep.Salesman__r !== undefined && rep.Salesman__r.User__r !== undefined) ? rep.Salesman__r.User__r.Title : '',
            (rep.Salesman__r !== undefined && rep.Salesman__r.User__r !== undefined) ? rep.Salesman__r.User__r.MobilePhone : '',
            (rep.Salesman__r !== undefined && rep.Salesman__r.User__r !== undefined) ? rep.Salesman__r.User__r.Email : '',
            'salesRep'
        );
    },
    
    /**
     *  Rep model
     * @param firstName
     * @param lastName
     * @param title
     * @param phone
     * @param email
     * @returns {{firstName: *|string, lastName: *|string, title: *|string, phone: *|string, email: *|string}}
     */
    createRep: function(firstName, lastName, title, phone, email, type) {
        return {
            firstName: firstName || '',
            lastName: lastName || '',
            title: title || '',
            phone: phone || '',
            email: email || '',
            type: type || ''
        };
    }
})