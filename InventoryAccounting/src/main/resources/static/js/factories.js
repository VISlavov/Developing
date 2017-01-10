app.factory('ScopeApplier', function($q, $timeout){
	var factory = {};

	factory.apply = function (scope, scopeVar, data) {
		var deferred = $q.defer();

		$timeout(function () {
			scope.$apply(function () {
				if(typeof scopeVar != 'undefined' &&
					typeof data != 'undefined') {

					scope[scopeVar] = data;
				}
				deferred.resolve();
			});
		});

		return deferred.promise;
	};

	factory.applyPush = function (scope, scopeVar, data) {
		scope[scopeVar].push(data);

		return factory.apply(scope, scopeVar, scope[scopeVar]);
	};
		
	return factory;
});

app.factory('RequestUtil', function($timeout, $q, $http, $filter, SettingsData, MessagesUtil, ScopeApplier){
	var factory = {};

	factory.commonFormRequest = function(settings) {
		var deferred = $q.defer(),
			callback = function (response) {
				var data = response.data,
					status = response.status;

				if(factory.isResponseStatusAllowed(status)) {
					var message = MessagesUtil.getMessageForStatus(data, status);
					MessagesUtil.clearMessagesList();
					MessagesUtil.updateMessagesList(message);

					deferred.resolve(response);
				} else {
					deferred.reject(data);
				}
			};

		$http(settings).then(callback, callback);

		return deferred.promise;
	};

	factory.isResponseStatusAllowed = function(status) {
		var isAllowed = false;

		for(var statusCode in SettingsData.allowedStatusCodes) {
			if(SettingsData.allowedStatusCodes[statusCode] == status) {
				isAllowed = true;
			}
		}

		return isAllowed;
	};

	factory.assembleFormSettings = function(scope, attr) {
		var settings = {
			url: attr.url,
			method: attr.method,
			params: scope.formData
		};

		return settings;
	};

	factory.getStock = function(scope, name) {
		$http.get(SettingsData.getStockUrl, {
			params: {
				name: name
			}
		}).then(function(response) {
			var data = response.data;
			ScopeApplier.applyPush(scope, "stocks", data);
		});
	};

	factory.getStocks = function(scope) {
		$http.get(SettingsData.getStocksUrl).success(function(data) {
			ScopeApplier.apply(scope, "stocks", data);
		});
	};

	factory.getFullPath = function(path) {
		return window.location.pathname + path;
	};
		
	return factory;
});

app.factory('MessagesUtil', function(SettingsData, $q, $rootScope, ScopeApplier){
	var factory = {};

	factory.refreshMessages = function () {
		$rootScope.$broadcast("messagesUpdated", {
			messages: SettingsData.messagesList
		});
	};

	factory.clearMessagesList = function() {
		SettingsData.messagesList = [];
		factory.refreshMessages();
	};

	factory.clearMessage = function(msg) {
		var index = SettingsData.messagesList.indexOf(msg);
		
		SettingsData.messagesList.splice(index, 1);
		factory.refreshMessages();
	};

	factory.updateMessagesList = function(message) {
		SettingsData.messagesList.push(message);
		factory.refreshMessages();
	};

	factory.getMessageForStatus = function(messageText, currentStatus) {
		var messageStatus,
			message;

		if(currentStatus == SettingsData.successStatusCode) {
			messageStatus = SettingsData.alertTypes.success;
		} else {
			messageStatus = SettingsData.alertTypes.error;
		}

		message = {
			text: messageText,
			status: messageStatus
		}

		return message;
	};

	factory.hasErrorMessages = function() {
		var hasErrorMessages = false;

		for(var i = 0; i < SettingsData.messagesList.length; i += 1) {
			if(SettingsData.messagesList[i].status == SettingsData.alertTypes.error) {
				hasErrorMessages = true;
			}
		}
		
		return hasErrorMessages;
	};

	factory.hasMessages = function() {
		return SettingsData.messagesList.length > 0;
	};
		
	return factory;
});

app.factory('DomUtil', function() {
	var factory = {};
	
	factory.changeParent = function(currentParent, newParent, position) {
		if(currentParent != undefined && newParent != undefined) {
			var children = angular.element(currentParent).children(),
				child = children[position];

			if(child != undefined) {
				angular.element(newParent).append(child);
			}
		}
	};

	return factory;
});

app.factory('SettingsData', function() {
	return {};
});
