app.directive('userManipulationForm', function ($rootScope, SettingsData, MessagesUtil, RequestUtil, ScopeApplier) {
	return {
		link: function (scope, el, attr) {
			scope.submitForm = function() {
				var settings = RequestUtil.assembleFormSettings(scope, attr);

				RequestUtil.commonFormRequest(settings)
					.then(function() {
						if(!MessagesUtil.hasErrorMessages()) {
							var manipulationType = attr.method,
								email,
								id;

							if(typeof scope.formData != 'undefined') {
								email = scope.formData.email;
								id = scope.formData.id;
							}

							$rootScope.$broadcast("usersUpdated", {
								email: email,
								id: id,
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
				controller = attr.controller || 'ModalController',
				fillData = attr.fill || false;

			el.bind('click', function() {
				$modal.open({
					templateUrl: template,
					controller: 'ModalController as ctrl',
					resolve: {
						formData: function () {
							var formData;

							if(fillData) {
								formData = fillData;
							}
							
							return formData;
						}
					}
				});
      });
		}
	};
});
