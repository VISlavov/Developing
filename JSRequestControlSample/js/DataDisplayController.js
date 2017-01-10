var DataDisplayController = function () {
	this.prepareDisplay = function() {
		this.hideLoadingNotification();
	};

	this.clearOldData = function () {
		$('#content').empty();
	};

	this.showLoadingNotification = function() {
		$('#loading-notification').show();
	};

	this.hideLoadingNotification = function() {
		$('#loading-notification').hide();
	};

	this.displayLoadedData = function(data) {
		this.hideLoadingNotification();

		data.forEach(function(dataElement) {
			var img = document.createElement('img');
			img.src = dataElement.url;
			img.className = 'thumbnail';
			document.querySelector('#content').appendChild(img);
		});
	};
};
