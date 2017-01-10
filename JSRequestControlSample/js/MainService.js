var MainService = function() {
	this.getDesiredDataCount = function() {
		var desiredDataCount = $('input#count-field').val();
		desiredDataCount = parseInt(desiredDataCount);

		return desiredDataCount;
	};

	this.isDataCountValid = function(count) {
		var alertUtil = new AlertUtil();
		var isValid = false;

		if(isNaN(count)) {
			alertUtil.alertInvalidData();
		} else if(count < 1 || count > 1000) {
			alertUtil.alertNumberOutOfRange();
		} else {
			isValid = true;
		}

		return isValid;
	};
}
