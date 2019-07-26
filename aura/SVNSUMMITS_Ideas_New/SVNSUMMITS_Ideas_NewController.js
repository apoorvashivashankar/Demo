// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    doInit : function(component, event, helper) {
        helper.getCommonSettings(component);

        if (component.get("v.allowThemes")) {
            helper.getThemesValues(component);
        }

        if (component.get("v.allowCategories")) {
            helper.getCategoryValues(component);
        }

        if (component.get("v.useTopics")) {
            helper.getTopicNamesList(component);
        }

        helper.getInstanceUrl(component);
        helper.getSessionId(component);
        helper.getZoneId(component);
        helper.getDefaultStatus(component);

        if (component.get("v.isEditing")) {
            helper.getStatusValues(component);
            helper.getIdeaRecord(component);
        }

        helper.hideSpinner(component);
    },

    check_DuplicateIdeas : function(component, event, helper) {
    	var showDuplicates = component.get('v.showDuplicates');

    	if (showDuplicates) {
		    var inputTitleCmp = component.find("title");

		    if (inputTitleCmp.get("v.value") && inputTitleCmp.get("v.value").trim() !== "") {
		    	helper.showSpinner(component);
			    helper.check_DuplicateIdeas(component);
		    }
	    }
    },

    chosenImage : function(component, event, helper) {
        var fileLabel = component.find("image-file-name").getElement();
        var fileInput = component.find("imageUpload").getElement();

        if (fileInput.files.length > 0) {
            fileLabel.innerHTML = fileInput.files[0].name;
        }
    },

    submitIdea : function(component, event, helper) {
        var isError   = false;
        var currIdea  = component.get("v.currIdea");

        var fileInput = component.find("imageUpload");

        if (fileInput) {
            fileInput = component.find("imageUpload").getElement();
        }

        var inputTitleCmp = component.find("title");
        inputTitleCmp.set("v.errors", null);

        if (!inputTitleCmp.get("v.value") || inputTitleCmp.get("v.value").trim() === "") {
            inputTitleCmp.set("v.errors", [{ message:component.get('v.errorTitle')}]);
            isError = true;
        }

        var inputDescriptionCmp = component.find("description");
        inputDescriptionCmp.set("v.errors", null);

        var isValid = true;
        if (!inputDescriptionCmp.get("v.value") || inputDescriptionCmp.get("v.value").trim() === "" ) {
        	isValid = false;
            isError = true;
        }
        component.set('v.validDescription', isValid);

        // Validate attachments
        component.set("v.isBrowseError", false);
        component.set("v.strError", null);

		if (fileInput) {
	        if (fileInput.files.length > 0) {
	            if (fileInput.files[0].type.indexOf("image") === -1) {
	                component.set("v.isBrowseError", true);
	                component.set("v.strError", component.get('v.errorImageType'));
	                isError = true;
	            }
	            if (fileInput.files[0].size > helper.MAX_FILE_SIZE) {
	                component.set("v.isBrowseError", true);
	                component.set("v.strError", component.get('v.errorImageSize') + helper.MAX_FILE_SIZE);
	                isError = true;
	            }
	        }
        }

        if (!isError) {
            currIdea.Title = inputTitleCmp.get("v.value");
            currIdea.Body = inputDescriptionCmp.get("v.value");

            var zoneId = component.get("v.zoneId");
            currIdea.CommunityId = zoneId;

            helper.debug(component,"zoneId: ", zoneId);
            helper.debug(component,"currIdea.CommunityId : ", currIdea.CommunityId);

            helper.submitIdea(component, currIdea);
        }
    },

	gotoRecord : function(component, event, helper){
    	helper.gotoRecord(component, $(event.currentTarget).data("id"));
	},

	goBack : function(component, event, helper){
		window.history.back();
	}
})