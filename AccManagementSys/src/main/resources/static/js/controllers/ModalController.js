app.controller("ModalController", function ($scope, $modalInstance, $timeout, DomUtil, MessagesUtil){
	$timeout(function () {
		var mainMessagesWidgetParent = document.querySelector('#main-messages-widget-container'),
			modalMessagesWidgetParent = document.querySelector('#modal-messages-widget-container');

		DomUtil.changeParent(mainMessagesWidgetParent, modalMessagesWidgetParent, 0); 	
		MessagesUtil.clearMessagesList();

		$scope.$on('$destroy', function () {
			document.querySelector('body *[modal-trigger=""]:focus').blur();

			if(MessagesUtil.hasErrorMessages()) {
				MessagesUtil.clearMessagesList();
			}
		});

		$scope.closeModal = function(data) {
			DomUtil.changeParent(modalMessagesWidgetParent, mainMessagesWidgetParent, 0); 	
			$modalInstance.close(data);
		};
  });
});
