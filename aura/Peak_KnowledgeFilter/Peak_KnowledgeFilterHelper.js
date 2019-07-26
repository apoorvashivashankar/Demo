/**
 * peak_knowledgefilter - Generates the assets used for Peak Knowledge Filter
 * @version 1.0.0
 * @author 7Summits
 *
 * COMPILED FILE DO NOT DIRECTLY EDIT
 */
({
    store: null,
    pager: null,

    /**
     *
     */
    initStore: function initStore() {

        function Store() {
            this.search = '';
            this.filters = {};
        }

        Store.prototype.setSearch = function () {
            var value = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : '';

            this.search = value.trim();
        };

        Store.prototype.getSearch = function () {
            return this.search;
        };

        Store.prototype.setFilters = function () {
            var filters = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};

            this.filters = filters;
        };

        Store.prototype.setFilterSelected = function (filterKey, value) {
            // find the filterKey if it exists
            if (this.filters.hasOwnProperty(filterKey)) {
                var filter = this.filters[filterKey];

                if (filter.childTopicList !== undefined && Array.isArray(filter.childTopicList)) {
                    filter.childTopicList.forEach(function (option) {
                        option.selected = option.value === value;

                        // iterate through all children
                        if (option.childTopicList !== undefined && Array.isArray(option.childTopicList)) {
                            option.childTopicList.forEach(function (option) {
                                option.selected = option.value === value;
                            });
                        }
                    });
                }
            }
        };

        Store.prototype.setFilterSelectedByName = function (name) {
            var _this = this;

            // iterate each of the filter groups looking for a match
            Object.keys(this.filters).forEach(function (filter) {
                var filterItem = _this.filters[filter];

                // does the filter have a first level set of child topics
                if (filterItem.childTopicList !== undefined && Array.isArray(filterItem.childTopicList)) {

                    // iterate the first level child topics
                    filterItem.childTopicList.forEach(function (option) {

                        // compare label to name to set selected value
                        option.selected = option.label === name;

                        // does the filter have a second level of child topics
                        if (option.childTopicList !== undefined && Array.isArray(option.childTopicList)) {

                            // iterate the second level child topics
                            option.childTopicList.forEach(function (option) {

                                // compare label to name to set selected value
                                option.selected = option.label === name;
                            }); // end for each topic list item
                        } // end child topic list check
                    }); // end for each topicList item
                } // end outer child topic list check
            }); // end filter iterate
        };

        Store.prototype.getFilterIdsBySelected = function () {
            var includeChildren = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : false;

            var filtersSelected = [];

            // iterate all the available filters
            for (var key in this.filters) {
                if (this.filters.hasOwnProperty(key)) {
                    var filter = this.filters[key];

                    // make sure the array we are going to be iterating is actually there
                    if (filter.childTopicList !== undefined && Array.isArray(filter.childTopicList)) {

                        // we are setting a variable on the outer loop so we can break all the way
                        // back out from the inner loop to here.
                        outerLoop: for (var x = 0; x < filter.childTopicList.length; x++) {
                            var childTopic = filter.childTopicList[x];
                            var itemsSelectedInThisFilter = [];

                            // check if childTopic is selected or not
                            if (childTopic.selected === true && childTopic.value !== '') {
                                itemsSelectedInThisFilter.push(childTopic.value);

                                // there is still a possibility of one level of children
                                // below, check to see if we have to include those
                                if (includeChildren === true && childTopic.childTopicList !== undefined && Array.isArray(childTopic.childTopicList)) {
                                    for (var _x4 = 0; _x4 < childTopic.childTopicList.length; _x4++) {
                                        itemsSelectedInThisFilter.push(childTopic.childTopicList[_x4].value);
                                    }
                                }

                                filtersSelected.push(itemsSelectedInThisFilter);
                                break outerLoop;
                            } // end found selected value outer

                            // childTopic wasn't a selected value but lets see if it has children to check
                            else if (childTopic.childTopicList !== undefined && Array.isArray(childTopic.childTopicList)) {
                                    for (var _x5 = 0; _x5 < childTopic.childTopicList.length; _x5++) {
                                        var childTopicChild = childTopic.childTopicList[_x5];

                                        // check if childTopicChildren is selected or not
                                        if (childTopicChild.selected === true && childTopicChild.value !== '') {
                                            itemsSelectedInThisFilter.push(childTopicChild.value);
                                            filtersSelected.push(itemsSelectedInThisFilter);
                                            break outerLoop;
                                        }
                                    }
                                } //  end child topic list check
                        } // outer for loop
                    } // end if check
                } // end prop check
            } // end each filter for loop

            return filtersSelected;
        };

        Store.prototype.getFilters = function () {
            return this.filters;
        };

        this.store = new Store();
    },

    initPager: function initPager() {
        var results = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];


        function Pager() {
            var results = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
            var currentPage = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 0;
            var pageLength = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : 10;

            this.results = results;
            this.pageLength = pageLength;
            this.currentPage = currentPage;
            this.totalPages = Math.ceil(results.length / pageLength);
        }

        Pager.prototype.getNextPage = function () {
            if (this.currentPage < this.totalPages) {
                var startIndex = this.currentPage * this.pageLength;
                var endIndex = startIndex + this.pageLength <= this.results.length - 1 ? startIndex + this.pageLength - 1 : this.results.length - 1;
                this.currentPage++;
                return this.results.slice(startIndex, endIndex + 1);
            }
        };

        Pager.prototype.getPrevPage = function () {
            if (this.currentPage > 1) {
                var startIndex = (this.currentPage - 1) * this.pageLength - this.pageLength;
                var endIndex = (this.currentPage - 1) * this.pageLength;
                this.currentPage--;
                return this.results.slice(startIndex, endIndex);
            }
        };

        Pager.prototype.shouldShowPrev = function () {
            return this.currentPage > 1;
        };

        Pager.prototype.shouldShowNext = function () {
            return this.currentPage !== this.totalPages;
        };

        Pager.prototype.getTotalCount = function () {
            return this.results.length;
        };

        Pager.prototype.getCurrentPage = function () {
            return this.currentPage;
        };

        Pager.prototype.getTotalPages = function () {
            return this.totalPages;
        };

        this.pager = new Pager(results);
    },

    /**
     *
     * @param cmp
     * @param preFilterTopicName - topic name which will be selected in order to
     * filter the results.
     */
    getTopics: function getTopics(cmp, preFilterTopicName) {
        var _this2 = this;

        var action = cmp.get('c.getNavigationalTopics');

        // set config options
        var config = this.helpers.createGetTopicsConfig(cmp);
        action.setParams(config);
        action.setStorable();

        action.setCallback(this, function (response) {
            var state = response.getState();

            // check if the request was successful or not
            if (cmp.isValid() && state === 'SUCCESS') {

                // get the topicWrappers returned from the controller
                var topicWrappers = response.getReturnValue();

                // format the topics for FE use
                var preparedTopicFilters = _this2.helpers.prepareTopicFilters(topicWrappers);

                // set the formatted filters array to the view
                cmp.set('v.topicFiltersList', preparedTopicFilters);

                // create filter object and place it in the store
                var filterGroups = _this2.helpers.createFilterGroup(preparedTopicFilters);

                // set filters to the store
                _this2.store.setFilters(filterGroups);

                // are we pre-filtering or not? If so set the selected filter
                if (preFilterTopicName !== null && preFilterTopicName !== '') {
                    _this2.store.setFilterSelectedByName(preFilterTopicName);
                }

                // fire topicsLoaded event
                var cmpLoadedEvent = cmp.getEvent('cmpEventTopicsLoaded');
                cmpLoadedEvent.fire();
            } else {
                console.log('getNavigationalTopics:Error:');
            }
        });

        // make the request
        $A.enqueueAction(action);
    },

    /**
     * 
     */
    search: function search(cmp) {
        var _this3 = this;

        // set searching to init loader
        cmp.set('v.isSearching', true);
        cmp.set('v.pagerShow', false);

        // get filters topicIDs from filters selected
        var filtersSelected = this.store.getFilterIdsBySelected(true);
        var searchTerm = this.store.getSearch();
        var action = cmp.get('c.doSearch');

        // apparently you can't pass complex objects into APEX from a
        // controller so couldn't pass a List<List<String>> so doing
        // it this way
        action.setParams({
            searchTerm: searchTerm,
            topicFilterOne: filtersSelected[0] !== undefined ? filtersSelected[0] : undefined,
            topicFilterTwo: filtersSelected[1] !== undefined ? filtersSelected[1] : undefined,
            topicFilterThree: filtersSelected[2] !== undefined ? filtersSelected[2] : undefined,
            topicFilterFour: filtersSelected[3] !== undefined ? filtersSelected[3] : undefined
        });

        action.setStorable();

        action.setCallback(this, function (response) {
            // set searching to turn off loader
            cmp.set('v.isSearching', false);

            var state = response.getState();

            // check if the request was successful or not
            if (cmp.isValid() && state === 'SUCCESS') {

                var searchResults = response.getReturnValue();

                // set the search results to the view
                if (searchResults.results !== undefined && Array.isArray(searchResults.results)) {
                    // initialize the pager
                    _this3.initPager(searchResults.results);
                    _this3.pagerNext(cmp);
                    cmp.set('v.pagerShow', searchResults.results.length > 0);
                } // search results if check
            } // end success / component valid check
        }); // end callback

        $A.enqueueAction(action);
    },

    /**
     *
     * @param filterKey
     * @param value
     */
    setFilterSelected: function setFilterSelected(cmp, filterKey, value) {
        this.store.setFilterSelected(filterKey, value);
        this.search(cmp);
    },

    /**
     *
     * @param value
     */
    setSearchText: function setSearchText(cmp, searchTerm) {
        // if the search string is less than 2 characters we don't want
        // to execute a search, but if the the search string is less than
        // 2 characters and the previous search term is larger than the current
        // it means we are deleting characters so we do want to make a search
        // with an empty search string to return the default results.
        var previousSearchTerm = this.store.getSearch();

        if (searchTerm.length > 2 || previousSearchTerm.length > searchTerm.length) {
            var newSearchTerm = searchTerm.length > 2 ? searchTerm : '';
            this.store.setSearch(newSearchTerm);
            cmp.set('v.searchValue', newSearchTerm);
            this.search(cmp);
        }
    },

    /**
     *
     * @param cmp
     */
    pagerNext: function pagerNext(cmp) {
        var results = this.pager.getNextPage();
        this.helpers.pagerUpdateResults(cmp, this.pager, results);
    },

    /**
     *
     * @param cmp
     */
    pagerPrev: function pagerPrev(cmp) {
        var results = this.pager.getPrevPage();
        this.helpers.pagerUpdateResults(cmp, this.pager, results);
    },

    /**
     *
     */
    helpers: {

        /**
         *
         * @param filtersArray
         * @returns {*}
         */
        prepareTopicFilters: function prepareTopicFilters() {
            var filtersArray = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];

            // create copy of array
            var results = JSON.parse(JSON.stringify(filtersArray));

            // iterate all the filters
            results.forEach(function (filter) {

                // check if there is a childTopicList and if it is not empty
                if (Array.isArray(filter.childTopicList) && filter.childTopicList.length > 0) {

                    // iterate the childTopics
                    filter.childTopicList.forEach(function (option, index, theArray) {

                        // format the child topic object
                        theArray[index] = {
                            value: option.topicId,
                            label: option.topicName,
                            selected: false
                        };

                        // check if the child topic has children if it does format those as well
                        if (Array.isArray(option.childTopicList) && option.childTopicList.length > 0) {
                            var parentItem = theArray[index];

                            // add a childTopicList to the topic
                            parentItem.childTopicList = [];

                            // iterate children adding them to child topic list
                            option.childTopicList.forEach(function (childOption, childIndex, childTheArray) {
                                parentItem.childTopicList[childIndex] = {
                                    value: childOption.topicId,
                                    label: childOption.topicName,
                                    selected: false
                                };
                            });
                        } // end If
                    }); // end outer child topic filter

                    // add default options
                    filter.childTopicList.unshift({
                        value: '',
                        label: 'FILTER by ' + filter.topicName,
                        selected: true
                    });
                } // end if check
            });

            return results;
        }, // end prepareTopicFilters

        /**
         *
         * @param filtersArray
         * @returns {{}}
         */
        createFilterGroup: function createFilterGroup() {
            var filtersArray = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];

            var filterGroup = {};

            filtersArray.forEach(function (filter) {
                filterGroup[filter.topicId] = filter;
            });

            return filterGroup;
        }, // end createFilterGroup

        createGetTopicsConfig: function createGetTopicsConfig(cmp) {
            var config = {};

            // --------------------
            // prepare  topicIds
            // --------------------
            var topicIds = [];
            var articleFilter1 = cmp.get('v.articleFilter1');
            var articleFilter2 = cmp.get('v.articleFilter2');
            var articleFilter3 = cmp.get('v.articleFilter3');
            var articleFilter4 = cmp.get('v.articleFilter4');

            if (articleFilter1 !== '') {
                topicIds.push(articleFilter1);
            }

            if (articleFilter2 !== '') {
                topicIds.push(articleFilter2);
            }

            if (articleFilter3 !== '') {
                topicIds.push(articleFilter3);
            }

            if (articleFilter4 !== '') {
                topicIds.push(articleFilter4);
            }

            config.topicIds = topicIds;
            // --------------------
            // end prepare  topicIds
            // --------------------

            return config;
        },

        pagerUpdateResults: function pagerUpdateResults(cmp, pager) {
            var results = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : [];

            var pagerShowPrev = pager.shouldShowPrev();
            var pagerShowNext = pager.shouldShowNext();
            var pagerTotalCount = pager.getTotalCount();
            var pagerCurrentPage = pager.getCurrentPage();
            var pagerTotalPages = pager.getTotalPages();

            cmp.set('v.searchResults', results);
            cmp.set('v.pagerShowPrev', pagerShowPrev);
            cmp.set('v.pagerShowNext', pagerShowNext);
            cmp.set('v.pagerTotalCount', pagerTotalCount);
            cmp.set('v.pagerCurrentPage', pagerCurrentPage);
            cmp.set('v.pagerTotalPages', pagerTotalPages);
        },

        getUrlHashByName: function getUrlHashByName(name) {
            var url = window.location.href;
            var regex = new RegExp('[#]' + name + '(=(.+))');
            var results = regex.exec(url);

            // The name was not a query string param
            if (!results) {
                return null;
            }

            // The name was a query string param but didn't have a value
            if (!results[2]) {
                return '';
            }

            // success return the value
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        } // end helpers

    } });