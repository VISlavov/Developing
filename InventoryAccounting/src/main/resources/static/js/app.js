var app = angular.module(
		'InventoryAccounting',
		['ngRoute',
		'ui.bootstrap']);

app.run(function (SettingsData, $rootElement) {
	SettingsData.messagesList = [];
	SettingsData.successStatusCode = 200;
	SettingsData.getStocksUrl = 'getStocks/';
	SettingsData.getStockUrl = 'getStock/';
	SettingsData.alertTypes = {
			success: "success",
			error: "danger"
		};
	SettingsData.allowedStatusCodes = {
			forbidden: 403,
			ok: 200
		};
	SettingsData.stockManipulationTypes = {
			post: "create",
			delete: "delete",
			put: "update"
		};
});
