// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	submitVote: function (component, event, ideaId, voteType) {
		var action = component.get("c.submitVote");

		action.setParams({
			ideaId: ideaId,
			voteType: voteType
		});

		action.setCallback(this, function (actionResult) {
			var currIdea = actionResult.getReturnValue();
			if (currIdea) {
				if (currIdea.Categories) {
					currIdea.Categories = currIdea.Categories.split(";");
				}

				var ideaListWrapper = component.get("v.wrappedIdeasObj");

				for (var i = 0; i < ideaListWrapper.ideaList.length; i++) {
					if (ideaListWrapper.ideaList[i].Id === ideaId) {
						ideaListWrapper.ideaList[i] = currIdea;
						break;
					}
				}
				component.set("v.wrappedIdeasObj", ideaListWrapper);
			}
		});

		$A.enqueueAction(action);
	},

	initializeCarousel: function (component) {
		if (component.get("v.displayMode") === 'Tile Carousel View') {

			var carouselViewer = component.find("carouselViewer").getElement();

			window.setTimeout(
				$A.getCallback(function () {
					$(carouselViewer).slick({
						dots: true,
						arrows: true,
						infinite: false,
						speed: 300,
						slidesToShow: 4,
						slidesToScroll: 4,
						responsive: [
							{
								breakpoint: 1024,
								settings: {
									slidesToShow: 3,
									slidesToScroll: 3,
									infinite: true,
									dots: true
								}
							},
							{
								breakpoint: 600,
								settings: {
									slidesToShow: 2,
									slidesToScroll: 2
								}
							},
							{
								breakpoint: 480,
								settings: {
									slidesToShow: 1,
									slidesToScroll: 1
								}
							}
							// You can unslick at a given breakpoint now by adding:
							// settings: "unslick"
							// instead of a settings object
						]
					});
				}), 1000);
		}
	},

	debug: function (component, msg, variable) {
		if (component.get("v.debugMode")) {
			if (msg) {
				console.log(msg);
			}
			if (variable) {
				console.log(variable);
			}
		}
	}
})