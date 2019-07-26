// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({

	getInstanceUrl: function (component) {
		var action = component.get("c.getInstanceUrl");

		action.setCallback(this, function (actionResults) {
			var instanceUrl = actionResults.getReturnValue();

			component.set("v.sfInstanceUrl", instanceUrl);
		});

		$A.enqueueAction(action);
	},

	getSessionId: function (component) {
		var action = component.get("c.getSessionId");

		action.setCallback(this, function (actionResult) {
			component.set("v.sessionId", actionResult.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	getZoneId: function (component) {
		var action = component.get("c.getZoneId");

		action.setParams({
			nameValue: component.get("v.zoneName")
		});

		action.setCallback(this, function (actionResult) {
			component.set("v.zoneId", actionResult.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	getCommonSettings: function (component) {
		var action = component.get("c.getCommonSettings");

		action.setCallback(this, function (actionResult) {
			var common = actionResult.getReturnValue();
			component.set("v.debugMode", common.debugMode);
		});

		$A.enqueueAction(action);
	},

	getThemesValues: function (component) {
		var action = component.get("c.getThemeList");

		action.setParams({
			zoneName: component.get("v.zoneName")
		});

		action.setCallback(this, function (actionResult) {
			component.set("v.themeSet", actionResult.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	getTopicNamesList: function (component) {
		var action = component.get("c.getTopicNamesList");

		action.setCallback(this, function (actionResult) {
			component.set("v.topicNamesList", actionResult.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	getCategoryValues: function (component) {
		var action = component.get("c.getPicklistValues");

		action.setParams({
			objName: "Idea",
			fieldName: "Categories"
		});

		action.setCallback(this, function (actionResult) {
			component.set("v.categoriesSet", actionResult.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	getStatusValues: function (component) {
		var action = component.get("c.getPicklistValues");

		action.setParams({
			objName: "Idea",
			fieldName: "Status"
		});

		action.setCallback(this, function (actionResult) {
			if (actionResult.getState() === 'SUCCESS') {
				component.set("v.statusSet", actionResult.getReturnValue());
			}
		});

		$A.enqueueAction(action);
	},

	getDefaultStatus: function (component) {
		var action = component.get("c.getDefaultStatus");

		action.setCallback(this, function (actionResult) {
			if (actionResult.getState() === 'SUCCESS') {
				component.set("v.defaultStatus", actionResult.getReturnValue());
			}
		});

		$A.enqueueAction(action);
	},

	initializeDropdown: function (component) {
		this.debug(component, "Initializing drop downs");

		this.debug(component, "Categories : ", component.get("v.categoriesSet"));
		this.debug(component, "Topics     : ", component.get("v.topicNamesList"));

		try {
			if (component.get("v.allowCategories")) {
				var catCmp = component.find("selectedCategory");
				$A.util.removeClass(catCmp, "slds-hide");
				$A.util.addClass(catCmp, "ui fluid search");
				$(catCmp.getElement()).dropdown({placeholder: "Select Categories"});
			}

			if (component.get("v.useTopics")) {
				var topicCmp = component.find("selectedTopic");
				$A.util.removeClass(topicCmp, "slds-hide");
				$A.util.addClass(topicCmp, "ui fluid search");
				$(topicCmp.getElement()).dropdown({placeholder: "Select Topics"});
			}
		} catch (e) {
			this.debug(component, null, e);
		}
	},

	check_DuplicateIdeas: function (component) {
		var self = this;
		var action = component.get("c.checkDuplicateIdeas");
		var inputTitleCmp = component.find("title");

		action.setParams({
			"title": inputTitleCmp.get("v.value").trim(),
			"zoneId": component.get("v.zoneId"),
			"simIdeasLimit": component.get("v.simIdeasLimit")
		});

		action.setCallback(this, function (actionResult) {
			var ideasList = actionResult.getReturnValue();
			component.set("v.ideasList", ideasList);

			self.hideSpinner(component);
		});

		$A.enqueueAction(action);
	},

	submitIdea: function (component, currIdea) {
		this.debug(component, "Submit idea", currIdea);
		var self = this;

		var editingMode = component.get("v.isEditing");
		var action = editingMode
			? component.get("c.updateIdea")
			: component.get("c.createIdeaNew");

		if (component.get("v.allowCategories")) {
			var category = component.find("selectedCategory").get("v.value");

			if (category) {
				currIdea.Categories = category;
			}
		}

		if (component.get("v.useTopics")) {
			var topic = component.find("selectedTopic").get("v.value");

			if (topic) {
				currIdea.Related_Topic_Name__c = topic;
				this.debug(component, "Topic = " + currIdea.Related_Topic_Name__c);
			}
		}

		if (editingMode) {
			var selectedStatus = component.find("selectedStatus").get("v.value");

			if (selectedStatus) {
				currIdea.Status = selectedStatus;
			}
		} else if (component.get("v.defaultStatus")) {
			currIdea.Status = component.get("v.defaultStatus");
		}

		var newIdea = this.setNamespace(component, currIdea);
		this.debug(component, "Set namespace", newIdea);

		action.setParams({
			"currIdeaList": new Array(newIdea)
		});

		var fileInput = component.find("imageUpload");

		if (fileInput) {
			fileInput = component.find("imageUpload").getElement();
		}

		var pathToDetail = component.get("v.ideaDetailURL");

		var spinnerSubmit = component.find("spinnerSubmit");
		$A.util.removeClass(spinnerSubmit, "hide");

		var newIdeaForm = component.find("newIdeaForm");
		$A.util.addClass(newIdeaForm, "hide");

		action.setCallback(this, function (actionResult) {
			var resId = actionResult.getReturnValue();
			var resultId = component.find("resultId");
			var state = actionResult.getState();

			if (state === 'SUCCESS' && resId.length < 19) {
				if (fileInput && fileInput.files.length > 0) {
					self.uploadAttachment(component, resId, fileInput.files);
				} else {
					self.gotoRecord(component, resId);
				}
			} else {
				self.hideSpinner(component);

				var newIdeaForm = component.find("newIdeaForm");
				$A.util.removeClass(newIdeaForm, "hide");

				var resultsDiv = component.find("resultsDiv");
				resultsDiv.getElement().scrollIntoView(false);

				if (state === 'SUCCESS' && resId.length >= 19) {
					resultId.set("v.value", "Apex Error: " + resId);
				} else {
					var errorMessages = '<ul>';

					var errors = actionResult.getError();
					for (var i = 0; i < errors.length; i++) {
						errorMessages += '<li>' + errors[i].message + '</li>';
					}
					errorMessages += '</ul>';
					resultId.set("v.value", errorMessages);
				}
			}
		});

		$A.enqueueAction(action);
	},

	/* 1 000 000 * 3/4 to account for base64 */
	MAX_FILE_SIZE: 750000,

	uploadAttachment: function (component, parentId, files) {
		var self = this;
		var file = files[0];
		var reader = new FileReader();

		reader.onload = function (e) {
			var fileContent = reader.result;

			if (fileContent.indexOf("image") > -1) {
				self.debug(component, "image upload started");
				self.uploadFile(component, parentId, file, fileContent);
			}
		};

		reader.readAsDataURL(file);
	},

	uploadFile: function (component, parentId, file, fileContent) {
		var self = this;

		component.set("v.parentId", parentId);

		var sessionId = component.get("v.sessionId");
		var sfInstanceUrl = component.get("v.sfInstanceUrl");

		var client = new forcetk.Client();

		client.setSessionToken(sessionId, 'v39.0', sfInstanceUrl);
		client.instanceUrl = sfInstanceUrl;
		client.proxyUrl = null;

		client.update(
			'Idea', parentId, {
				'attachmentContentType': file.type,
				'attachmentName': file.name.length > 40 ? file.name.substring(0, 40) : file.name,
				'attachmentBody': fileContent.split(",")[1]
			},
			function (response) {
				self.debug(component, 'Upload success');
				self.hideSpinner(component);
				self.gotoRecord(component, component.get("v.parentId"));
			},
			function (request, status, response) {
				self.debug(component, 'Upload failed', response);
				self.debug(component, status, request);
				self.hideSpinner(component);

				var resultId = component.find("resultId");
				var errorMsg = "Error: " + status + " " + request + ". Please check the following items:<br/><ul>";

				errorMsg += "<li>Check that the SF Instance URL is correct. Current Value: " + sfInstanceUrl + "</li>";
				errorMsg += "<li>Check that CORS configuration is setup properly.</li>";
				errorMsg += "</ul>";
				self.debug(component, errorMsg, null);

				resultId.set("v.value", status + ", Please contact your system administrator.");
				document.getElementById('resultsDiv').scrollIntoView(false);
			}
		);
	},

	getIdeaRecord: function (component) {
		var self = this;
		var action = component.get("c.getIdea");

		action.setParams({
			zoneId: component.get("v.zoneId"),
			recordId: component.get("v.sObjectId")
		});

		action.setCallback(this, function (actionResult) {
			var idea = self.parseNamespace(component, actionResult.getReturnValue());

			if (idea.Status &&
				component.get("v.isEditing")) {
				component.find("selectedStatus").set("v.value", idea.Status);
			}
			if (idea.Categories) {
				idea.Categories = idea.Categories.split(";");
				if (component.get("v.allowCategories")) {
					component.find("selectedCategory").set("v.value", idea.Categories[0]);
				}
			}

			if (idea.Related_Topic_Name__c &&
				idea.Related_Topic_Name__c.length > 0 &&
				component.get("v.useTopics")) {
				component.find("selectedTopic").set("v.value", idea.Related_Topic_Name__c);
			}

			if (idea.AttachmentName &&
				idea.AttachmentName.length > 0 &&
				component.get("v.allowImages")) {
				var fileLabel = component.find("image-file-name").getElement();
				fileLabel.innerHTML = idea.AttachmentName;
			}

			idea.fromNow = moment.utc(idea.CreatedDate).fromNow();

			component.set("v.currIdea", idea);
		});

		$A.enqueueAction(action);
	},

	showSpinner: function (component) {
		var spinnerSubmit = component.find("spinnerSubmit");
		$A.util.removeClass(spinnerSubmit, 'slds-hide');
	},

	hideSpinner: function (component) {
		var spinnerSubmit = component.find("spinnerSubmit");
		$A.util.addClass(spinnerSubmit, 'slds-hide');
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