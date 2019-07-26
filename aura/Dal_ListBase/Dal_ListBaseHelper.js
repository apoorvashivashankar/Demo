/**
 * Created by 7Summits on 2/22/18.
 */
({

    /**
     * Calls doCallout method of base component, but before returning the results
     * to the calling child component, will check the response and set the loading
     * and error states of the component. Meaning that each child component that
     * extends this will have built in loading and error state messaging.
     * @param cmp
     * @param method
     * @param params
     * @returns {*}
     */
    doListCallout: function(cmp, method, params){
        cmp.set('v.isLoading', true); // set loading state

        // call actual do callout which does the work
        var promise = this.doCallout(cmp, method, params);

        // look at the response from doCallout and set loading and error states
        promise.then(function(response){
            cmp.set('v.isLoading', false); // set loading state
            // look at the peak response to see if it was successful, some requests
            // may not return a peak response for some reason but if that is the case
            // response.success will be undefined so just return it as successful
            if(response.success === true || response.success === undefined){
               // nothing to do successful request
            } else {
                cmp.set('v.hasGetDataError', true); // set error state
            }
        }, function(){
            cmp.set('v.isLoading', false); // set loading state
            cmp.set('v.hasGetDataError', true); // set error state
        });

        return promise;
    },

    /**
     * Takes column and data attributes, which should be set in the child
     * component that extends this component, and prepares/formats those objects
     * to be drawn to the view.
     * @param cmp
     */
    initTable: function(cmp){
        var self = this;

        // prepare the column to data mapping
        var columns = cmp.get('v.columns');
        var data = cmp.get('v.data');
        var hasPagination = cmp.get('v.hasPagination');
        var itemsPerPage = cmp.get('v.paginationItemsPerPage');
        var startPage = cmp.get('v.paginationStartPage');

        // iterate all the data rows
        data.forEach(function(row){
            row.columns = [];

            // iterate all the columns looking for data point matches
            columns.forEach(function(column){

                // if type actions we need to get a bit more information
                var actionData;
                if(column.type === 'action'){
                    row.onSelect = column.onSelect;
                } // end if action

                // check if type modal if so, set view
                // variable to true so we can load modal library
                else if(column.type === 'modal'){
                    cmp.set('v.hasModal', true);
                }

                // single cta action on click
                else if(column.type === 'singleAction'){
                    row.onClick = column.onClick;
                }

                row.columns.push(self.helpers.createViewRow(
                    row[column.fieldName],
                    column.fieldName,
                    column.label,
                    column.type,
                    column.actions,
                    column.menuAlignment,
                    row[column.urlName],
                    column.component,
                    column.detailViewOnly
                ));
            });

            //viewDataRows.push(row);
        });

        // check if pagination is enabled if it is we
        if(hasPagination === true){
            var pager = this.initPager(data, startPage, itemsPerPage);
            cmp.set('v.pager', pager);
            this.pagerNext(cmp);
        } else {
            cmp.set('v.data', data);
        }

    },

    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get('v.data');

        var reverse = sortDirection !== 'asc';

        // sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse));
        cmp.set('v.data', data);
    },

    sortPaginatedData: function(cmp, fieldName, sortDirection) {
        var pager = cmp.get('v.pager');
        var itemsPerPage = cmp.get('v.paginationItemsPerPage');
        var allResults = pager.getAllResults();

        var reverse = sortDirection !== 'asc';

        // sorts the rows based on the column header that's clicked
        allResults.sort(this.sortBy(fieldName, reverse));

        // initialize the pager with the sorted results
        var sortedPager = this.initPager(allResults, 0, itemsPerPage);
        cmp.set('v.pager', sortedPager);
        this.pagerNext(cmp);
    },

    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },

    setCheckedStateAllData: function(cmp, checked){
        var data = cmp.get('v.data');
        data.forEach(function(item){
            item.checked = checked;
        });

        cmp.set('v.data', data);
        cmp.set('v.allDataChecked', checked);
    },

    initPager: function(results, currentPage, pageLength) {
        results = (results !== undefined && Array.isArray(results)) ? results : [];
        currentPage = currentPage !== undefined ? currentPage : 0;
        pageLength = pageLength !== undefined ? pageLength : 30;

        function Pager(results, currentPage, pageLength) {
            this.results = results;
            this.pageLength = pageLength;
            this.currentPage = currentPage;
            this.totalPages = Math.ceil(results.length / pageLength);
        }

        Pager.prototype.getNextPage = function() {
            if (this.currentPage < this.totalPages) {
                const startIndex = this.currentPage * this.pageLength;
                const endIndex = ((startIndex + this.pageLength) <= this.results.length - 1) ? (startIndex + this.pageLength - 1) : (this.results.length - 1);
                this.currentPage++;
                return this.results.slice(startIndex, endIndex + 1);
            }
        };

        Pager.prototype.getPrevPage = function() {
            if (this.currentPage > 1) {
                const startIndex = ((this.currentPage - 1) * this.pageLength) - this.pageLength;
                const endIndex = (this.currentPage - 1) * this.pageLength;
                this.currentPage--;
                return this.results.slice(startIndex, endIndex);
            }
        };

        Pager.prototype.shouldShowPrev = function() {
            return (this.currentPage > 1);
        };

        Pager.prototype.shouldShowNext = function() {
            return (this.currentPage !== this.totalPages);
        };

        Pager.prototype.getTotalCount = function() {
            return this.results.length;
        };

        Pager.prototype.getCurrentPage = function() {
            return this.currentPage;
        };

        Pager.prototype.getTotalPages = function() {
            return this.totalPages;
        };

        Pager.prototype.getAllResults = function(){
          return this.results;
        };


        return new Pager(results, currentPage, pageLength);
    },

    pagerNext: function pagerNext(cmp) {
        var pager = cmp.get('v.pager');
        var results = pager.getNextPage();
        this.pagerUpdateResults(cmp, pager, results);
    },

    pagerPrev: function pagerPrev(cmp) {
        var pager = cmp.get('v.pager');
        var results = pager.getPrevPage();
        this.pagerUpdateResults(cmp, pager, results);
    },

    pagerUpdateResults: function(cmp, pager, results) {
        var pagerShowPrev = pager.shouldShowPrev();
        var pagerShowNext = pager.shouldShowNext();
        var pagerTotalCount = pager.getTotalCount();
        var pagerCurrentPage = pager.getCurrentPage();
        var pagerTotalPages = pager.getTotalPages();

        cmp.set('v.data', results);
        cmp.set('v.pagerShowPrev', pagerShowPrev);
        cmp.set('v.pagerShowNext', pagerShowNext);
        cmp.set('v.pagerTotalCount', pagerTotalCount);
        cmp.set('v.pagerCurrentPage', pagerCurrentPage);
        cmp.set('v.pagerTotalPages', pagerTotalPages);
    },

    helpers: {

        createViewRow: function(value, fieldName, label, type, actions, menuAlignment, url, component, detailViewOnly){
            var data = {
                value: value || '',
                fieldName: fieldName || '',
                label: label || '',
                type: type || '',
                url: url || '',
                detailViewOnly: detailViewOnly || false
            };
            
            if(type === 'action'){
                data.actions = actions || [];
                data.menuAlignment = menuAlignment || '';
            }

            if(type === 'modal'){
                data.component = component || '';
            }

            return data;
        }

    } // end helpers

})