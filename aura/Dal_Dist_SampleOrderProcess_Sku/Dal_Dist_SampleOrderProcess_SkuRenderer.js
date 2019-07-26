/**
 * Created by ranja on 16-08-2018.
 */
({
    render : function(cmp, helper) {
        var ret = this.superRender();

        return ret;
    },


    afterRender : function(cmp,helper) {
        this.superAfterRender();

        window.onscroll = function() {
            //console.log('SCROLL RENDER')
            var navbar = document.getElementById('navbar');
            //console.log('1');
                    //console.log('IN RENDER: ' , navbar);
                    //console.log(navbar.offsetTop)
                    var sticky = navbar.offsetTop;
             		var navSticky = document.getElementById('navbavSticky');
                    if (window.pageYOffset >= sticky) {
                        //console.log('2');
                        //navbar.classList.add(" sticky");
                        //console.log('NAVBAR: ' , navbar);
                        //console.log('cmp.find(navbar): ' , cmp.find('navbar'));
                        //if(navSticky.classList.contains('sticky')){
                            navSticky.classList.add("sticky");
                        //}
                        //console.log('Add STICKY');
                    } else {
                        //console.log('3');
                        //navbar.classList.remove(cmp.find('navbar'), 'sticky');
                        //$A.util.removeClass(cmp.find('navbavSticky'), 'sticky');
                        navSticky.classList.remove("sticky");
                        //console.log('REMOVE STICKY');
                    }
        }


    }
})