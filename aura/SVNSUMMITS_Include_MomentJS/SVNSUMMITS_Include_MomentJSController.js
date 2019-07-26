/**
  * Copyright ©2016-2017 7Summits Inc. All rights reserved.
  *
  * Created by francois korb on 3/3/17.
  */
({
	afterScriptsLoaded: function () {
		var currentLocale = moment.locale();
		console.debug('Current locale ' + currentLocale);
		var browserLocale = navigator.languages && navigator.languages.length
			? navigator.languages[0]
			: navigator.language;
		console.debug('Browser locale ' + browserLocale);
		moment.locale(browserLocale);
	}
})