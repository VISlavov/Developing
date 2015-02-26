// JavaScript Document
$(document).ready(function() {
	var source = {
		'main' : 'This is the webpage of a school project called Trippy Dino.Trippy Dino is a 2D Desktop game programmed on Ruby. More information about the game itself will be revealed at several sections of the website. You can access this section by clicking the buttons shown in the top panel of the page. Enjoy and do not forget to smile :)' ,
		'story' : 'Ones upon a time, there was this little dino. His name was Fred. He was very curious so he took LSD. Join him in his journey for survival. This.. the Trippy Dino' ,
		'models' : '<img src = "Enemy_1_Animated.gif" alt="" /> <img src = "Forward.gif" alt="" /> <img src = "Enemy_2_Animated.gif" alt="" />' ,
		'achv' : 'Achievement 1 : Black Spiderman Effect : Disables jumping <br></br> <br></br> Achievement 2 : The Bolt Effect : Speeds up gameplay <br></br> <br></br> Achievement 3 : The Angry Old Guy Effect : Slows down gameplay',
		'more' : 'Idea for the project : The idea for the game came from the effects on the human mind and in general the hallucinations, paranoia and paranormal events. <br></br> The characters in this gave are from improvisation and does not have any deeper meaning than to entertain the user and to make him laugh. <br></br> Tools used for creating the game : The tools used for the creation of this game are, Ruby programming language, online image editors (url of the editors used http://www.online-image-editor.com/ and http://pixlr.com/editor/ ), also used Pencil 2D for the making of the models inside the game, the game is Desktop only, has no mobile versions. <br></br> General features and extras : The game is a 2D side-screen with basic controls, W for jumping, A for direction left, D for direction right, with saving and highscore features. Some extras are hidden inside the game and when unlocked they change the gameplay (these extras a.k.a. achievements are explained in the website for the game). <br></br> <br></br>'
		};
	$('.home').html(source.main);
	$('.story').hide();
	$('.enem').hide();
	$('.docs').hide();
	$('.achv').hide();
	$('button').hide();
	$('button').delay(500).fadeIn('slow');
	$('#home').click(function() {
		$('.home').fadeIn('slow');
		$('.home').html(source.main);
		$('.story').hide();
		$('.enem').hide();
		$('.docs').hide();
		$('.achv').hide();
	});
	$('#story').click(function() {
		$('.story').fadeIn('slow');
		$('.story').html(source.story);
		$('.home').hide();
		$('.enem').hide();
		$('.docs').hide();
		$('.achv').hide();
	});
	$('#enem').click(function() {
		$('.enem').fadeIn('slow');
		$('.enem').html(source.models);
		$('.home').hide();
		$('.story').hide();
		$('.docs').hide();
		$('.achv').hide();
	});
	$('#docs').click(function() {
		$('.docs').fadeIn('slow');
		$('.docs').html(source.more);
		$('.home').hide();
		$('.enem').hide();
		$('.story').hide();
		$('.achv').hide();
	});
	$('#achv').click(function() {
		$('.achv').fadeIn('slow');
		$('.achv').html(source.achv);
		$('.home').hide();
		$('.enem').hide();
		$('.docs').hide();
		$('.story').hide();
	});
});