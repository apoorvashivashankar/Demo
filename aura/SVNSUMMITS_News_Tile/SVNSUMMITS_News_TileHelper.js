// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	get_SitePrefix: function (component) {
		var action = component.get("c.getSitePrefix");

		action.setCallback(this, function (actionResult) {
			var sitePath = actionResult.getReturnValue();

			component.set("v.sitePath", sitePath);
			component.set("v.sitePrefix", sitePath.replace("/s", ""));
		});

		$A.enqueueAction(action);
	},

	overflowChecker: function (el) {
		var curOverflow = el.style.overflow;

		if (!curOverflow || curOverflow === "visible") {
			el.style.overflow = "hidden";
		}
		var isOverflowing = el.clientWidth < el.scrollWidth || el.clientHeight < el.scrollHeight;

		el.style.overflow = curOverflow;

		return isOverflowing;
	},

	topicsCheck: function (component) {
		var topics = $('.topics');
		if (topics.length > 0) {
			for (var i = 0; i < topics.length; i++) {
				isoverflowing = this.overflowChecker(topics[i]);
				if (isoverflowing == true) {
					ellipses = topics[i].getElementsByTagName('span');
					ellipses[0].className += " visible";
				}

			}
		}
	},

	doInitialization: function (component) {
		var listSize = component.get("v.numberOfNewsPerPage");

		window.setTimeout(
			$A.getCallback(function () {
				var totalNews = component.get("v.totalNews");
				if (totalNews !== undefined && totalNews > 0) {
					if (totalNews % 2 === 0) {
					}
					else {
						component.set("v.isOdd", true);
					}
				}

			}), 5000
		);

		// List view logic for search and topic pages
		if (listSize > 0) {
			if (listSize % 3 === 0) {
			} else {
				component.set("v.isTotalOdd", true);
				if (listSize % 3 === 1) {
					component.set("v.isAddCol", true);
				}
				else if (listSize % 3 === 2) {
					component.set("v.isAddCol", false);
				}

			}
		}

		//List view addition div logic
		if (listSize > 0) {
			if (listSize % 2 === 0) {
			}
			else {
				component.set("v.isOdd", true);
			}
		}
	}
})