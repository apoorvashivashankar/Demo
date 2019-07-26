// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getNewsRecord: function (component) {
		var self = this;
		var recordId = component.get("v.recordId");
		this.debug(component, 'Posted By called for ', recordId);

		var action = component.get("c.getNewsRecord");
		action.setParams({
			newsRecordId: recordId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				self.debug(component, 'Posted By Success...', response.getReturnValue());

				//var newsListWrapper = response.getReturnValue();
				var newsListWrapper = this.parseNamespace(component,response.getReturnValue());

				if (newsListWrapper.netMem !== null) {
					component.set("v.strDate", moment.utc(newsListWrapper.netMem.CreatedDate).format('LL'));
				}

				component.set("v.newsListWrapper", newsListWrapper);
			}
			else {
				self.debug(component, 'Action getNewsRecord failed...', response);
			}
		});

		$A.enqueueAction(action);
	},

	getIsNickNameEnabled : function (component) {
		var self = this;
		var action = component.get("c.isNicknameDisplayEnabled");

		action.setCallback(this, function (actionResult) {
			self.debug(component, 'Success - isNicknameDisplayEnabled...', actionResult.getReturnValue());
			self.debug(component, '           Show Nickname...' + component.get('v.showNickName'));
			component.set("v.isNicknameDisplayEnabled", actionResult.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	get_SitePrefix: function (component) {
		var action = component.get("c.getSitePrefix");
		action.setCallback(this, function (actionResult) {
			var sitePath = actionResult.getReturnValue();
			component.set("v.sitePath", sitePath);
			//component.set("v.sitePrefix", sitePath.replace("/s",""));
		});
		$A.enqueueAction(action);
	},

	debug: function (component, msg, variable) {

		var debugMode = component.get("v.debugMode");
		if (debugMode) {
			if (msg) {
				console.log(msg);
			}
			if (variable) {
				console.log(variable);
			}
		}
	}

})