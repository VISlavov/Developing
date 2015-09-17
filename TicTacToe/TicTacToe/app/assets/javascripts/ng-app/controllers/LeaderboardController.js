function LeaderboardController($scope){
	$scope.scores = fetchScores();

	function fetchScores() {
		var scores;

		console.log(localStorage);

		return localStorage;
	}
}
         
