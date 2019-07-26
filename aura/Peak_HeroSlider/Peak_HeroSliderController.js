({
    doInit : function(component, event, helper) {
        var showDots = component.get('v.showDots');
        var showArrows = component.get('v.showArrows');
        var speed = component.get('v.speed');
        var transition = component.get('v.transition');
        var doAutoplay = true;
        var doFade = false;
        
        if(speed == 0)
            doAutoplay = false;
        
        if(transition == 'Fade')
            doFade = true;
        
        setTimeout(function() {
            $(component.find("slider").getElement()).slick({
                dots: showDots,
                autoplay: doAutoplay,
                autoplaySpeed: speed,
                arrows: showArrows,
                fade: doFade,
                mobileFirst: true
            });
        });
        // prevent default "pull-to-refresh" behavior when running in S1
        $(component.find("slider").getElement()).on("touchmove", function() {
            return false;
        });

    }
})