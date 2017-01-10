var MainService = function(displayController) {
	this.MIN_COUNT_BOUNDARY = 1;
	this.MAX_COUNT_BOUNDARY = 1000;

	this.getDesiredDataCount = function() {
		var desiredDataCount = $('input#count-field').val();
		desiredDataCount = parseInt(desiredDataCount);

		return desiredDataCount;
	};

	this.checkRequestConcurrency = function() {
		var isConcurrencyFound = false;
		
		if(displayController.isLoadingNotificationShown()) {
			var alertUtil = new AlertUtil(this);
			
			alertUtil.alertConcurrentRequest();

			isConcurrencyFound = true;
		}

		return isConcurrencyFound;
	};

	this.isDataCountValid = function(count) {
		var alertUtil = new AlertUtil(this);
		var isValid = false;

		if(isNaN(count)) {
			alertUtil.alertInvalidData();
		} else if(count < this.MIN_COUNT_BOUNDARY 
							|| count > this.MAX_COUNT_BOUNDARY) {
			alertUtil.alertNumberOutOfRange();
		} else {
			isValid = true;
		}

		return isValid;
	};
}
