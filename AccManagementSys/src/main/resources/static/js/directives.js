app.directive('userManipulationForm', function ($rootScope, SettingsData, MessagesUtil, RequestUtil) {
	return {
		link: function (scope, el, attr) {
			scope.submitForm = function() {
				var settings = RequestUtil.assembleFormSettings(scope, attr);

				RequestUtil.commonFormRequest(settings)
					.then(function() {
						if(!MessagesUtil.hasErrorMessages()) {
							var emailField = document.querySelector('#email'),
								email = angular.element(emailField).val(),
								manipulationType = attr.method;

							$rootScope.$broadcast("usersUpdated", {
								email: email,
								manipulationType: SettingsData.userManipulationTypes[manipulationType]
							});

							scope.closeModal();
						}
					});
			};
		}
	};
});

app.directive('modalTrigger', function ($modal) {
	return {
		link: function (scope, el, attr) {
			var template = attr.template,
				controller = attr.controller || 'ModalController';

			el.bind('click', function() {
				$modal.open({
					templateUrl: template,
					controller: 'ModalController as ctrl'
				});
      });
		}
	};
});
