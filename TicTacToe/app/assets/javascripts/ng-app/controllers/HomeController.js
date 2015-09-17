function HomeController($scope){

	var TicTacToe = (function () {

		// CONSTANTS
		var HIDDEN_CLASS = 'hidden',
			SCORE_STEP = 1,
			INVALID_NAME_WARNING = 'Please enter valid names.',
			NOSTORAGE_WARNING = 'The game results will not be saved, because your browser does not support local storage';
				
		// VARIABLES
		var board,
				currentPlayer,
				currentSymbol,
				endgameFlag,
				fields = $('#fields > div'),
				innerFlag,
				purgedWinning,
				XName,
				OName,
				winning = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]];
		
		// METHODS
		var changePlayer,
				drawPlayer,
				initialize,
				isGameOver,
				message,
				newGame,
				render,
				resetBoard,
				setSymbol,
				getNames,
				show,
				hide,
				switchGameState,
				showInvalidNamesDialog,
				showNoStorageDialog,
				saveGameResults,
				getWinnerName;
		
		changePlayer = function () {
			currentPlayer = currentPlayer ? 0 : 1;
			setSymbol();
		};
		
		drawPlayer = function () {
			currentPlayer = Math.floor((Math.random() * 2));
			setSymbol();
		};
		
		isGameOver = function (elementIndex) {
			innerFlag = false;
			purgedWinning = winning.filter(function (v) { return v.indexOf(elementIndex) !== -1; });
			
			$.each(purgedWinning, function (i, v) {
				if (v.indexOf(elementIndex) !== -1) {
					if ((fields.eq(v[0]).text() === fields.eq(v[1]).text()) && (fields.eq(v[0]).text() === fields.eq(v[2]).text())) {
						$.each(fields, function (j, val) {
							if (v.indexOf(j) === -1) {
								$(val).addClass('other-field');
							}
						});
						
						innerFlag = true;
					}
				}
			});
			return innerFlag;
		};
		
		message = function (content) {
			$('p.left-para').html(content);
		};
		
		newGame = function () {
			endgameFlag = false;
			message('---');
			resetBoard();
			drawPlayer();
			switchGameState();
			render();
		};
		
		render = function () {
			$.each(board, function (i, v) {
				fields.eq(i).html(v).removeClass('cross-bg circle-bg other-field');
			});
		};
		
		resetBoard = function () {
			board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '];
		};
		
		setSymbol = function () {
			currentSymbol = currentPlayer ? 'X' : 'O';
		};

		getNames = function () {
			var areValid = false;

			OName = $('#onameholder').val();
			XName = $('#xnameholder').val();		

			if((OName.length != 0) && 
				(XName.length != 0)) {
				areValid = true;	
			}

			return areValid;
		};

		switchGameState = function () {
			var gamefield = $('#fields'),
				namesMenu = $('#names'),
				startGameButton = $('#start-game-button'),
				hiddenSections = [],
				visibleSections = [];

			if(gamefield.hasClass(HIDDEN_CLASS)) {
				hiddenSections.push(gamefield);
				hiddenSections.push(startGameButton);
				visibleSections.push(namesMenu);
			} else {
				visibleSections.push(gamefield);
				visibleSections.push(startGameButton);
				hiddenSections.push(namesMenu);
			}

			angular.forEach(hiddenSections, function (value, index) {
				show(value);
			});

			angular.forEach(visibleSections, function (value, index) {
				hide(value);	
			});
		};

		showInvalidNamesDialog = function () {
			alert(INVALID_NAME_WARNING);	
		};

		showNoStorageDialog = function () {
			alert(NOSTORAGE_WARNING);
		};

		show = function (elem) {
			$(elem).removeClass(HIDDEN_CLASS);
		};

		hide = function (elem) {
			$(elem).addClass(HIDDEN_CLASS);
		};

		saveGameResults = function () {
			var winner = getWinnerName(),
				existingMatch,
				score = SCORE_STEP;		

			if (typeof(Storage) !== "undefined") {
				existingMatch = localStorage.getItem(winner);

				score =
					existingMatch == undefined ?
					score	: (parseInt(existingMatch) + score);

				localStorage.setItem(winner, score);
			} else {
				showNoStorageDialog();
			}
		};

		getWinnerName = function () {
			var winner =
				currentSymbol == 'X' ? 
				XName : OName;

			return winner;
		};

		// INIT FUNCTION
		initialize = function () {
			newGame();
			
			$('#fields').on('click', 'div', function () {
				if (this.innerHTML === " " && !endgameFlag) {
					this.innerHTML = currentSymbol;
					if (currentSymbol === 'X') {
						$(this).addClass('cross-bg');
					} else {
						$(this).addClass('circle-bg');
					}
					
					if (isGameOver($(this).index())) {
						message('Player ' + getWinnerName() + ' wins!');
						endgameFlag = true;
						saveGameResults();
					} else {
						changePlayer();
					}
				}
			});
			
			$('#fields').on('mouseover', function () {
				currentPlayer === 0 ?
					$(this).addClass('circle-cursor').removeClass('cross-cursor') : 
					$(this).addClass('cross-cursor').removeClass('circle-cursor');
			});
			
			$('p.right-para').on('click', newGame);

			$('#names-filled').click(function () {
				var areNamesValid = getNames();
				
				if(areNamesValid) {
					switchGameState();	
				} else {
					showInvalidNamesDialog();
				}
			});
		};
		
		return {
			play: initialize
		};
	}());
	
	TicTacToe.play();
}
         
