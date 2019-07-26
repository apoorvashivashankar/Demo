// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		var nameSpace = helper.getNameSpacePrefix(component);
		component.set('v.nameSpace', nameSpace);

		//helper.parseNewsNamespace(component);

		$('.targetButton').attr('disabled', 'disabled');
		var url = window.location.href;
		var splitUrl = url.split("/s/");
		component.set("v.sfInstanceUrl", splitUrl[0]);

		helper.hideSpinner(component);
		helper.getTopics(component);
		helper.getAuthors(component);

		var handlingGroups = component.get("v.limitToSpecificGroups");

		if (handlingGroups) {
			helper.getGroups(component);
			helper.getGroupPostAll(component);
		}
		helper.get_SitePrefix(component);
		helper.get_SessionId(component);

		if (component.get('v.isEdit') === true) {
			helper.getNewsRecord(component, event, helper);
		} else {
			if (!component.get("v.newsAuthor")) {
				helper.setDefaultAuthor(component, event, helper);
			}
		}

		/*020616 - Safari fixes for input type file*/
		$(function () {
			var nAgt = navigator.userAgent;
			if (nAgt.indexOf("Safari") !== -1) {
				if (nAgt.indexOf("Version") !== -1) {
					$('.attachEdit').addClass("attachEditSafari");
				}
			}
			else if (nAgt.indexOf("Firefox") !== -1) {
				$('.attachEdit').addClass("attachEditMozilla");
			}
			else if (nAgt.match("CriOS") !== -1) {
				$('.attachEdit').addClass("attachEditMozilla");
			}
		});
		/*020616 - Safari fixes for input type file*/
	},

	notifyFileSelected: function (component) {

		var fileInput = component.find("image").getElement();
		if (fileInput.files.length > 0) {
			component.set('v.isFileSelected', true);
		} else {
			component.set('v.isFileSelected', false);
			component.set("v.attachmentName", 'No File Chosen');
		}
	},

	showAuthorDropdown: function (component, event, helper) {
		helper.showHideAuthors(component);
	},

	handleSearch: function (component, event, helper) {
		// prevent searching during the search
		if (!component.get('v.searchFlag')) {
			helper.showSpinner(component);
			helper.searchAuthors(component);
		}
	},

	submitNews: function (component, event, helper) {
		var nameSpace = component.get('v.nameSpace');

		helper.showSpinner(component);

		component.set("v.strError", null);
		component.set("v.isBrowseError", false);


		var fileInput = component.find("image").getElement();
		var pbdt = component.find("publishDate").get("v.value");
		var ardt = component.find("archiveDate").get("v.value");

		// Input validation
		var isError = false;

		var inputTitleCmp = component.find("newsName");
		if (!inputTitleCmp.get("v.value") || inputTitleCmp.get("v.value").trim() === "") {
			inputTitleCmp.set("v.errors", [{message: "Please fill out the Title field."}]);
			isError = true;
		}
		else {
			if (inputTitleCmp.get("v.value").length > 80) {
				inputTitleCmp.set("v.errors", [{message: "Event Title cannot exceed 80 characters. Please enter a title less than 80 characters."}]);
				isError = true;
			}
			else {
				inputTitleCmp.set("v.errors", null);
			}
		}

		var fullArticleCmp = component.find("newsDetail");
		if (!fullArticleCmp.get("v.value") || fullArticleCmp.get("v.value").trim() === "") {
			component.set('v.detailValid', false);
			isError = true;
		}
		else {
			component.set('v.detailValid', true);
		}

		var filterByTopicCmp = component.find("filterByTopic");
		if (!filterByTopicCmp.get("v.value") || filterByTopicCmp.get("v.value").trim() === "") {
			filterByTopicCmp.set("v.errors", [{message: "Please Select Topics."}]);
			isError = true;
		}
		else {
			filterByTopicCmp.set("v.errors", null);
		}

		var publishDateCmp = component.find("publishDate");
		if (!publishDateCmp.get("v.value") || publishDateCmp.get("v.value").trim() === "") {
			publishDateCmp.set("v.errors", [{message: "Please Select Publication Date."}]);
			isError = true;
		}
		else {
			publishDateCmp.set("v.errors", null);
			if (ardt !== null && ardt && moment(pbdt).isAfter(moment(ardt))) {
				publishDateCmp.set("v.errors", [{message: "Publication date must be before archive date."}]);
				isError = true;
			}
			else {
				publishDateCmp.set("v.errors", null);
			}
		}

		if (fileInput.files.length > 0 && fileInput.files[0].type.indexOf("image") === -1) {
			isError = true;
			component.set("v.isBrowseError", true);
			component.set("v.strError", "Error : Selected file must be an image.");
		} else if (fileInput.files.length > 0 && fileInput.files[0].size > 25000000) {
			isError = true;
			component.set("v.isBrowseError", true);
			component.set("v.strError", "Error : Image size must be less than 25MB.");
		} else {
			if (component.get("v.isEdit") && component.get("v.attachmentName") === 'No File Chosen' && component.get("v.isAttachment")) {
				component.set('v.isFileDelete', true);
			}
			component.set("v.isBrowseError", false);
			component.set("v.strError", null);
		}

		if (isError === true) {
			helper.hideSpinner(component);
			helper.debug(component, "Error occurred", null);
		} else {
			var newsObj = component.get("v.newsObj");

			newsObj['Name'] = component.get('v.newsName');
			newsObj[nameSpace + 'Details__c'] = component.get("v.newsDetails");
			newsObj[nameSpace + 'GroupId__c'] = component.get('v.newsGroup') || '';
			newsObj[nameSpace + 'Private_Group__c'] = component.get('v.newsPrivate');
			newsObj[nameSpace + 'Show_Author__c'] = component.get('v.newsShowAuthor');
			newsObj[nameSpace + 'Author__c'] = component.get('v.newsAuthor');
			newsObj[nameSpace + 'Publish_DateTime__c'] = component.get('v.newsPublishDate');
			newsObj[nameSpace + 'Archive_DateTime__c'] = component.get('v.newsArchiveDate');

			helper.submitNews(component, newsObj);
		}
	},

	setSubmitButtonState: function (component, event, helper) {
		//console.log("setSubmitButtonState called");
		helper.setSubmitButtonStateCheck(component, event);
	}
});