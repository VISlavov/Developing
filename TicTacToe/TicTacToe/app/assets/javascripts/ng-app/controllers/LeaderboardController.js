function LeaderboardController($scope){
	$scope.scores = fetchScores();

	function fetchScores() {
		return localStorage;
	}
}
         
