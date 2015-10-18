app.controller("MessagesListController", function ($scope, SettingsData, ScopeApplier, MessagesUtil){
	$scope.messagesList = [];	

	$scope.$on("messagesUpdated", function (event, args) {
		ScopeApplier.apply($scope, "messagesList", args.messages);
	});

	$scope.clearMessage = function(msg) {
		return MessagesUtil.clearMessage(msg);
	};

	$scope.hasMessages = function() {
		return MessagesUtil.hasMessages();
	};
});
