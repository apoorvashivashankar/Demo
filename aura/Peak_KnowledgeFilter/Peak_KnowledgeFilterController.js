/**
 * peak_knowledgefilter - Generates the assets used for Peak Knowledge Filter
 * @version 1.0.0
 * @author 7Summits
 *
 * COMPILED FILE DO NOT DIRECTLY EDIT
 */
({

    doInit: function doInit(cmp, evt, helper) {
        // initialize data store
        helper.initStore();

        // check the url hash to see if we are going to pre-filter the results or not
        var preFilterTopicName = helper.helpers.getUrlHashByName('topicFilter');

        // get the topic list and pre-filter if needed
        helper.getTopics(cmp, preFilterTopicName);
    },

    searchChange: function searchChange(cmp, evt, helper) {
        var timer = cmp.get('v.searchDebounce');
        clearTimeout(timer);

        timer = setTimeout($A.getCallback(function () {
            var value = evt.getSource().get('v.value');
            helper.setSearchText(cmp, value);
        }), 250);

        cmp.set('v.searchDebounce', timer);
    },

    filterChange: function filterChange(cmp, evt, helper) {
        var value = evt.getSource().get('v.value');
        var name = evt.getSource().get('v.name');
        helper.setFilterSelected(cmp, name, value);
    },

    pagerNext: function pagerNext(cmp, evt, helper) {
        helper.pagerNext(cmp);
    },

    pagerPrev: function pagerPrev(cmp, evt, helper) {
        helper.pagerPrev(cmp);
    },

    handleTopicsLoaded: function handleTopicsLoaded(cmp, evt, helper) {
        helper.search(cmp);
    }

});