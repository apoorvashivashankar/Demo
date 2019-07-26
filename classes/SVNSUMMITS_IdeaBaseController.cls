/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

global with sharing class SVNSUMMITS_IdeaBaseController {
	public SVNSUMMITS_IdeaBaseController() {

	}

	@AuraEnabled
	global static BaseModel getModel(){
		return new BaseModel();
	}

	global with sharing class BaseModel{
		@AuraEnabled
		global String namespacePrefix{get;set;}

		global BaseModel(){
			try{
					this.namespacePrefix = [
							SELECT NamespacePrefix
							FROM ApexClass
							WHERE Name = 'SVNSUMMITS_IdeaBaseController'].NamespacePrefix;
					// this.namespacePrefix = 'ideaslc';
			}catch(QueryException e){}
		}
	}
}