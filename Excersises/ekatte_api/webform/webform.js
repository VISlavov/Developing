var searchForm = $("#search-form"),
	resultsDiv = $("#results"),
	keywordField = searchForm.find("#keyword");

searchForm.submit(function() {
	var keyword = keywordField.val();

	if(keyword != '') {
		extraData = {
			'path': 'ekatte_api/main.rb',
			'keyword': keyword,
			'directories_back': 1,
		};

		commonFormRequest($(this), extraData)
			.then(function(response) {
				updateResults(response);
			})
			.fail(function (error) {
				console.log(error);
			});
	} else {
		alert("Please enter a keyword for your search");
	}

	return false;
});

function updateResults(results) {
	resultsDiv.html(results);	
}

function commonFormRequest($form, extra_data) {
	extra_data = (typeof extra_data === "undefined") ? {} : extra_data;

	var deferred = Q.defer(),
		method = $form.attr('method'),
		settings = {};

	settings.success = function (data) {
		deferred.resolve(data);
	};

	settings.error = function (err) {
		deferred.reject(err);
	}

	settings.data = extra_data;

	$form.ajaxSubmit({
		data: settings.data,
		success: settings.success,
		error: settings.error,
	});

	return deferred.promise;
}

