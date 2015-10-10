var app = angular.module(
		'AccManagementSys',
		['ngRoute',
		'ui.bootstrap']);

app.run(function (SettingsData) {
	SettingsData.messagesList = [];
	SettingsData.dateFormat = 'dd/MM/yyyy';
	SettingsData.successStatusCode = 200;
	SettingsData.alertTypes = {
			success: "success",
			error: "danger"
		};
	SettingsData.allowedStatusCodes = {
			forbidden: 403,
			ok: 200
		};
	SettingsData.userManipulationTypes = {
			post: "create",
			delete: "delete",
			put: "update"
		};
});
