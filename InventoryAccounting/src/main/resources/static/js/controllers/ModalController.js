app.controller("ModalController", function ($scope, $modalInstance, formData, $timeout, DomUtil, MessagesUtil, ScopeApplier){
	if(typeof formData != 'undefined') {
		formData = JSON.parse(formData);
		$scope.formData = formData;
	}

	$timeout(function () {
		var mainMessagesWidgetParent = document.querySelector('#main-messages-widget-container'),
			modalMessagesWidgetParent = document.querySelector('#modal-messages-widget-container');

		DomUtil.changeParent(mainMessagesWidgetParent, modalMessagesWidgetParent, 0); 	
		MessagesUtil.clearMessagesList();

		$scope.$on('$destroy', function () {
			var focusedButton = document.querySelector('body *[modal-trigger=""]:focus');
			if(focusedButton) {
				focusedButton.blur();
			}

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
