// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getTopics: function (component) {
		var action = component.get("c.getTopics");

		action.setCallback(this, function (response) {

			var values = response.getReturnValue();
			var valuesTemp = [];

			for (var value in values) {
				if (values.hasOwnProperty(value)) {
					valuesTemp.push({
						key: value,
						value: values[value]
					});
				}
			}

			component.set("v.topicValues", valuesTemp);
		});

		$A.enqueueAction(action);
	},

	getGroups: function (component) {
		var action = component.get("c.getGroups");

		action.setCallback(this, function (response) {
			var values = response.getReturnValue();
			var valuesTemp = [];

			for (var value in values) {
				if (values.hasOwnProperty(value)) {
					valuesTemp.push({
						key: value,
						value: values[value]
					});
				}
			}

			component.set("v.groupValues", valuesTemp);

			var groupIdCmp = component.find("filterByGroup");
			groupIdCmp.set('v.value', valuesTemp[0].key);
		});

		$A.enqueueAction(action);
	},

	getGroupPostAll: function (component) {
		var action = component.get("c.userAuthorizedToPost");

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				component.set("v.canPostToAll", response.getReturnValue());
			}
		});

		$A.enqueueAction(action);
	},

	getAuthors: function (component) {
		var action = component.get("c.getUsers");

		action.setCallback(this, function (response) {
			var values = response.getReturnValue();
			var valuesTemp = [];

			for (var value in values) {
				if (values.hasOwnProperty(value)) {
					valuesTemp.push({
						key: value,
						value: values[value]
					});
				}
			}

			// the => arrow function may not work in older browsers
			// var sortedUsers = valuesTemp.sort((a, b) => a.value.localeCompare(b.value));
			var sortedUsers = valuesTemp.sort(function (a, b) {
				return a.value.localeCompare(b.value)
			});

			component.set("v.authorValues", sortedUsers);
		});

		$A.enqueueAction(action);
	},

	searchAuthors: function (component) {
		var self = this;
		var action = component.get('c.searchUsers');
		var search = component.get("v.searchString");

		action.setParams({
			searchString: search
		});

		action.setCallback(this, function (response) {
			// ready for another search
			component.set('v.searchFlag', false);

			var values = response.getReturnValue();
			var valuesTemp = [];

			for (var value in values) {
				if (values.hasOwnProperty(value)) {
					valuesTemp.push({
						key: value,
						value: values[value]
					});
				}
			}
			component.set("v.authorValues", valuesTemp);
			self.hideSpinner(component);
		});

		$A.enqueueAction(action);
	},

	setDefaultAuthor: function (component) {
		var action = component.get("c.getCurrentUser");

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				component.set('v.newsAuthor', response.getReturnValue().Id);
			}
		});

		$A.enqueueAction(action);
	},

	addAuthorToSelection: function(component, id, name) {
		var authorList= component.get('v.authorValues');
		var found = false;

		// wanted to use the find() function but it is not supported in older browsers
		// found = authorList.find( x => return x.id === id);
		for (var i = 0; i < authorList.length; ++i) {
			if (authorList[i].key === id) {
				found = true;
				break;
			}
		}

		if (!found) {
			authorList.push({
				key: id,
				value: name
			});

			component.set('v.authorValues', authorList);
		}
	},

	initializeDropdown: function (component) {
		try {
			$(".topic")
				.addClass("ui fluid search")
				.dropdown({
					placeholder: "Select Topics"
				});

			$(".author")
				.addClass("ui fluid search")
				.dropdown({
					placeholder: "Select Author"
				});

			var topics = component.get("v.selectedTopics");

			if (topics !== '') {
				var topicsSelected = JSON.parse(topics);
				var tp = [];
				for (var t = 0; t < topicsSelected.length; t++) {
					tp.push(topicsSelected[t].TopicId);
				}
				window.setTimeout(
					$A.getCallback(function () {
						$(".topic").dropdown('set selected', tp);
					}), 1000
				);
			}

			var nameSpace = component.get('v.nameSpace');
			var author = component.get('v.newsAuthor');
			if (author !== '') {

				window.setTimeout(
					$A.getCallback(function () {
						$(".author").dropdown('set selected', author);
					}), 1000
				);
			}
		} catch (e) {
			this.debug(component, null, e);
		}
	},

	showHideAuthors: function (component) {
		var showAuthor = component.get('v.newsShowAuthor');
		var cmpTarget  = component.find('authorSelection');

		if (showAuthor === true) {
			$A.util.removeClass(cmpTarget, 'hideDropdown');
			$A.util.addClass(cmpTarget, 'showDropdown');
		} else {
			$A.util.removeClass(cmpTarget, 'showDropdown');
			$A.util.addClass(cmpTarget, 'hideDropdown');
		}

		return showAuthor;
	},

	//  Record detail for editing
	getNewsRecord: function (component, event, helper) {
		var self = this;
		this.debug(component, "get News Record for detail called from news create ", null);

		var action = component.get("c.getNewsRecord");

		action.setParams({
			newsRecordId: component.get("v.sObjectId"),
		});

		component.set('v.attachmentName', 'No File Chosen');

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var newsListWrapper = response.getReturnValue();
				//var newsListWrapper = this.parseNamespace(component, response.getReturnValue());

				helper.debug(component, "News Record : ", response.getReturnValue());

				if (newsListWrapper.newsList[0].Attachments && newsListWrapper.newsList[0].Attachments.length > 0) {
					component.set('v.isAttachment', true);
					component.set('v.attachmentName', newsListWrapper.newsList[0].Attachments[0].Name);
				}

				var nameSpace = component.get('v.nameSpace');

				var newsObj = newsListWrapper.newsList[0];
				component.set("v.newsObj", newsObj);
				component.set('v.newsName', newsObj.Name);
				component.set('v.newsDetails', newsObj[nameSpace + 'Details__c']);
				component.set('v.newsShowAuthor', newsObj[nameSpace + 'Show_Author__c']);
				component.set('v.newsAuthor', newsObj[nameSpace + 'Author__c']);
				component.set('v.newsPublishDate', newsObj[nameSpace + 'Publish_DateTime__c']);
				component.set('v.newsArchiveDate', newsObj[nameSpace + 'Archive_DateTime__c']);

				if (component.get('v.limitToSpecificGroups')) {
					if (newsObj[nameSpace + 'GroupId__c'] &&
						newsObj[nameSpace + 'GroupId__c'].length > 0) {
						component.set('v.newsGroup',   newsObj[nameSpace + 'GroupId__c']);
						component.set('v.newsPrivate', newsObj[nameSpace + 'Private_Group__c']);
					}
				}
				/*
				var groupIdCmp = component.find("filterByGroup");

				if (groupIdCmp) {
					if (newsObj[nameSpace + 'GroupId__c'] &&
						newsObj[nameSpace + 'GroupId__c'].length > 0) {

						groupIdCmp.set("v.value", newsObj[nameSpace + 'GroupId__c']);
					} else {
						groupIdCmp.set('v.value', '0');
					}
				}
				*/

				var showAuthor = self.showHideAuthors(component, event, helper);

				// make sure the current author is in the drop down list and selected
				if (showAuthor) {
					var itemAuthor = newsObj[nameSpace + 'Author__r'];
					self.addAuthorToSelection(component, itemAuthor.Id, itemAuthor.Name);
					component.set('v.newsAuthor', newsObj[nameSpace + 'Author__c']);
				}

				$("document").ready(function () {
					$("#upload").change(function () {
						var a = document.getElementById('upload');
						if (a.value === "") {
							fileLabel.innerHTML = "No file Chosen";
						}
						else {
							var theSplit = a.value.split('\\');
							fileLabel.innerHTML = theSplit[theSplit.length - 1];
							jQuery('<div/>',
								{
									class: 'myCls',
									text: theSplit[theSplit.length - 1]
								}).appendTo('body');
							$('.myCls').html('');
						}
					});
				});
			}
		});

		$A.enqueueAction(action);
	},

	submitNews: function (component, newsObj) {
		var self = this;

		var strFilterByTopic = component.find("filterByTopic").get("v.value");
		var fileInput = component.find("image").getElement();
		var pathToDetail = component.get("v.pathToDetail");

		if (component.get("v.isFileSelected") || component.get("v.isFileDelete")) {
			this.deleteAttachment(component);
		}
		var action = component.get("c.saveNews");

		action.setParams({
			"newsObj": newsObj,
			"strfilterByTopic": strFilterByTopic,
		});

		action.setCallback(this, function (response) {
			this.debug(component, "response : ", response.getState());
			self.hideSpinner(component);

			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var resId = response.getReturnValue().Id;
				this.debug(component, "response Id : ", resId);

				if (fileInput.files.length > 0 && resId !== null && resId.length > 0) {
					self.uploadImage(component, resId, fileInput.files);
				}
				else if (resId !== null && resId.length > 0) {
					self.goToURL(pathToDetail + resId);
				}
			}
			if (state === "ERROR") {
				var errors = response.getError();
				this.debug(component, "Page Error : ", errors);

				if (errors[0] && errors[0].fieldErrors) {

					if (errors[0].fieldErrors.EntityId[0].message.length > 0) {
						component.set("v.strError", errors[0].fieldErrors.EntityId[0].message);
					}
				}
				if (errors[0] && errors[0].pageErrors) {
					component.set("v.strError", errors[0].pageErrors[0].message);
				}
				if (errors[0] && errors[0].message) {
					component.set("v.strError", errors[0].message);
				}
			}
		});

		$A.enqueueAction(action);
	},

	deleteAttachment: function (component) {
		var action = component.get("c.deleteAttachment");

		action.setParams({
			newsRecordId: component.get("v.sObjectId"),
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				this.debug(component, "Attachment Deleted", response.getReturnValue());
			}
		});

		$A.enqueueAction(action);
	},

	uploadImage: function (component, resId, files) {
		var self = this;

		this.debug(component, 'uploading image', files[0]);

		var sessionId = component.get("v.sessionId");
		var pathToDetail = component.get("v.pathToDetail");

		var sfInstanceUrl = component.get("v.sfInstanceUrl");
		var client = new forcetk.Client();
		client.setSessionToken(sessionId, 'v36.0', sfInstanceUrl);
		client.proxyUrl = null;

		client.instanceUrl = sfInstanceUrl;
		var file = files[0];

		client.createBlob('Attachment', {
			'ParentId': resId,
			'Name': file.name,
			'ContentType': file.type,
		}, file.name, 'Body', file, function (response) {
			if (response.id !== null) {
				self.debug(component, 'success');
				self.hideSpinner(component);
				self.goToURL(pathToDetail + resId);
			} else {
				self.debug(component, 'error', response.errors);
				self.hideSpinner(component);
				component.set("v.strAttachmentError", 'Error : ' + response.errors[0].message);
			}
		}, function (request, status, response) {
			self.hideSpinner(component);
			var res = JSON.parse(response);
			component.set("v.strAttachmentError", 'Error : ' + res[0].message);
			self.debug(component, 'error', res);
		});
	},

	goToURL: function (url) {
		var urlEvent = $A.get("e.force:navigateToURL");
		urlEvent.setParams({
			"url": url,
		});
		urlEvent.fire();
	},

	get_SessionId: function (component) {
		var action = component.get("c.getSessionId");

		action.setCallback(this, function (actionResult) {
			component.set("v.sessionId", actionResult.getReturnValue());
		});
		$A.enqueueAction(action);
	},

	get_SitePrefix: function (component) {
		var action = component.get("c.getSitePrefix");

		action.setCallback(this, function (actionResult) {
			var sitePath = actionResult.getReturnValue();
			this.debug(component, "sitePath", sitePath);
			component.set("v.sitePath", sitePath);
			component.set("v.sitePrefix", sitePath.replace("/s", ""));
		});
		$A.enqueueAction(action);
	},

	showSpinner: function (component) {
		var spinnerSubmit = component.find("spinnerSubmit");
		$A.util.removeClass(spinnerSubmit, 'hide');
	},

	hideSpinner: function(component) {
		var spinnerSubmit = component.find("spinnerSubmit");
		$A.util.addClass(spinnerSubmit, 'hide');
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
	},

	setSubmitButtonStateCheck: function (component, event) {
		component.set("v.disableButton", false);

		var toggleText = component.find("FillHeader");

		$A.util.removeClass(toggleText, 'show');
		$A.util.addClass(toggleText, 'hide');
		$('#FillHeader').hide(); //Working with Lightning Locker

		this.debug(component, '=Button Status-01', component.get('v.disableButton'));

		var name    = component.get('v.newsName');
		var details = component.get('v.newsDetails');
		var topics  = component.find('filterByTopic').get('v.value');
		var time    = component.find('publishDate').get('v.value');
		var group   = component.get('v.newsGroup');
		var author  = component.get('v.newsAuthor');

		this.debug(component, "performing setSubmitButtonStateCheck:");
		this.debug(component, "    Name    = " + name);
		this.debug(component, "    Details = " + details);
		this.debug(component, "    Topics  = " + topics);
		this.debug(component, "    Group   = " + group);
		this.debug(component, "    Author  = " + author);
		this.debug(component, "    Publish = " + time);

		//undefined can be overridden. Safer to use 'in' keyword
		// if ((name === '' || name in window) ||
		// 	(details === '' || details in window) ||
		// 	(topics === '' || topics in window) ||
		// 	(time === '' || !(time in window))) {
		if (!name || !details || !topics || !time) {
			this.debug(component, '    -- NOT valid');

			component.set("v.disableButton", true);

			$('#FillHeader').show(); //Working with Lightning Locker
			$A.util.removeClass(toggleText, 'hide');
			$A.util.addClass(toggleText, 'show');
		}
		else {
			this.debug(component, '    -- valid');
		}

		$A.util.toggleClass(toggleText, "toggle");
	},

	calenderScroll: function () {
		$('#pbDt').click(function () {
			if ($(window).scrollTop() > 700)
				$(window).scrollTop(900);
		});

		$('#arDt').click(function () {
			if ($(window).scrollTop() > 700)
				$(window).scrollTop(1010);
		});
	}
})