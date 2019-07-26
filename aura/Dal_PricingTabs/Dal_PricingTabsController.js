/**
 * Created by abdoundure on 4/9/18.
 */
({
    init: function(cmp, evt, helper){
          cmp.set("v.isSSC", ((window.location.href.indexOf('SSC') > -1) || (window.location.href.indexOf('tradeproexchange') > -1)));
          console.log('isSSC', cmp.get("v.isSSC"));
    },
    handleActive: function(cmp, evt){
        var tab = evt.getSource();
        var activeTabId = tab.get('v.id');
        cmp.set('v.activeTab', activeTabId);
    }
})