(function () {
	var initialHorizontalOffset,
		initialLastExtremumPosition,
		isLeftFrequencyManipulated,
		isRightFrequencyManipulated,
		bottomExtremumBoundary,
		topExtremumBoundary,
		leftDemandedFrequency,
		rightDemandedFrequency,
		initialFrequency,
		timeChangeStep,
		canvas,
		context,
		height,
		width,
		xAxis,
		yAxis,
		draw;
	
	var SINE_WAVE_VOFFSET = 20,
		SIN_WAVE_COLOR = '#00f',
		SIN_WAVE_LINE_WIDTH = 1,
		SIN_WAVE_SEGMENT_LENGTH = 1,
		AXIS_HEIGHT_DIVISOR_FOR_POS = 2,
		CIRCLE_RADIUS = 10,
		DRAW_FREQUENCY = 5;
	
	function init() {
		canvas = document.getElementById("sine-canvas");
		context = canvas.getContext("2d");
		context.strokeStyle = SIN_WAVE_COLOR;
		context.lineWidth = SIN_WAVE_LINE_WIDTH;
	
		height = canvas.height;
		width = canvas.width;
		
		xAxis = Math.floor(height / AXIS_HEIGHT_DIVISOR_FOR_POS);
		yAxis = 0;

		amplitude = xAxis - SINE_WAVE_VOFFSET * 2;
		bottomExtremumBoundary = amplitude * 2 + SINE_WAVE_VOFFSET * 2;
		topExtremumBoundary = SINE_WAVE_VOFFSET * 2;
		initialHorizontalOffset = 0;
		initialLastExtremumPosition = topExtremumBoundary;
		initialFrequency = rightDemandedFrequency;
		timeChangeStep = width / 20000;

		draw();
	}

	draw = function () {
		context.clearRect(0, 0, width, height);

		context.beginPath();
		drawSine(draw.t);
		context.stroke();

		draw.seconds = draw.seconds + timeChangeStep;
		draw.t = draw.seconds * Math.PI;
		setTimeout(draw, DRAW_FREQUENCY);
	};
	draw.seconds = 0;
	draw.t = 0;

	function drawSine(t) {
		if(typeof initialFrequency === 'undefined') {
			initialFrequency = rightDemandedFrequency;
		}

		var freq = initialFrequency,
			i2 = handleFrequencyManipulation(freq, 
																			initialHorizontalOffset,
																			f(t + initialHorizontalOffset),
																			t),
			y = f(t + i2),
			initialY = Math.round(y),
			demandedFrequency,
			lastExtremumPosition = initialLastExtremumPosition,
			isFirstPeakPassed = false,
			isCircleDrawn = false;

		context.moveTo(yAxis, y);

		for(var i = 0; i < width; i += SIN_WAVE_SEGMENT_LENGTH) {
			y = f(t + i2);

			isCircleDrawn = drawCircle(isCircleDrawn, i, y);

			context.lineTo(i, y);
		//	context.stroke();
		//	alert(freq + ' ' + rightDemandedFrequency);
			
			/*if(i/10 % 1 === 0 && t > 50) {
				console.log(y);
				console.log(i);
				console.log(i2);
				console.log(t);
				alert('peak');
			}*/
			
			if(isExtremeCrossed(y)) {
				lastExtremumPosition = 
					lastExtremumPosition == topExtremumBoundary ?
					bottomExtremumBoundary : topExtremumBoundary;

				manageFirstExtremum();
				adjustFrequency();
			}

			i2 += SIN_WAVE_SEGMENT_LENGTH;
		}

		function manageFirstExtremum() {
			if(!isFirstPeakPassed) {
				var roundedY = Math.floor(y);
				if(Math.round(y) == initialY) {
					initialHorizontalOffset = 0;

					initialFrequency =
						initialFrequency == rightDemandedFrequency ?
						leftDemandedFrequency : rightDemandedFrequency;

					initialLastExtremumPosition =
						initialLastExtremumPosition == topExtremumBoundary ?
						bottomExtremumBoundary : topExtremumBoundary;

					initialHorizontalOffset = changeFrequency(initialFrequency, initialHorizontalOffset, y, t);
				}
				isFirstPeakPassed = true;
			}
		}

		function adjustFrequency() {
			var roundedY = Math.floor(y);
			demandedFrequency = getDemandedFrequency(y);

			if(!isFrequencyReached(freq, demandedFrequency)) {
				i2 = changeFrequency(demandedFrequency, i2, y, t);
				freq = demandedFrequency;
			}
		}

		function handleFrequencyManipulation(currentFreq, x, y, t) {
			if((isLeftFrequencyManipulated && (currentFreq != rightDemandedFrequency)) ||
				(isRightFrequencyManipulated && (currentFreq != leftDemandedFrequency))) {

				x = changeFrequency(currentFreq, x, y, t);

				if(isLeftFrequencyManipulated) {
					isLeftFrequencyManipulated = false;
				} else if(isRightFrequencyManipulated) {
					isRightFrequencyManipulated = false;
				}
			}

			return x;
		}

		function changeFrequency(demandedFreq, x, y, t) {
			var roundedY = Math.floor(y);
			if(Math.floor(f(t + x, demandedFreq)) > roundedY) {
				while(Math.floor(f(t + x, demandedFreq)) > roundedY) {
					x -= SIN_WAVE_SEGMENT_LENGTH;
				}
			} else {
				while(Math.floor(f(t + x, demandedFreq)) < roundedY) {
					x += SIN_WAVE_SEGMENT_LENGTH;
				}
			}

			return x;
		}

		function drawCircle(isCircleDrawn, x, y) {
			var center = width / 2;
			if(!isCircleDrawn &&
				(x > center - SIN_WAVE_SEGMENT_LENGTH) &&
				(x < center + SIN_WAVE_SEGMENT_LENGTH)) {
				context.arc(x, y, CIRCLE_RADIUS, 0, 2*Math.PI);			
				isCircleDrawn = !isCircleDrawn;
			}

			return isCircleDrawn;
		}

		function isExtremeCrossed(y) {
			var roundedY = Math.round(y),
				isCrossed; 

			isCrossed = ((roundedY == topExtremumBoundary) ||
				(roundedY == bottomExtremumBoundary));

			isCrossed = isCrossed && (roundedY != lastExtremumPosition);

			return isCrossed;
		}

		function isFrequencyReached(freq, demanded) {
			return (freq == demanded);
		}

		function getDemandedFrequency(y) {
			var demanded;
			switch(Math.ceil(y)) {
				case bottomExtremumBoundary:
					demanded = leftDemandedFrequency;
					break;
				case topExtremumBoundary:
				default:
					demanded = rightDemandedFrequency;
					break;
			}
			
			return demanded;
		}

		function f(x, frequency) {
			frequency = 
				typeof frequency == 'undefined' ?
				freq : frequency;	

			var y = amplitude * Math.sin(frequency * x) + xAxis;

			return y;
		}
	}

	var sliders = $('#slider-left-sin, #slider-right-sin');

	sliders.waitUntilExists(function() {
		sliders.on('change', function (e) {
			var value = $(this).val(),
				label;
			if($(this).attr('id').indexOf('left') != -1) {
				label = $('#slider-value-label-left');

				if(initialFrequency == leftDemandedFrequency) {
					initialFrequency = value;
				}
				leftDemandedFrequency = value;
				isLeftFrequencyManipulated = true;
			} else {
				label = $('#slider-value-label-right');

				if(initialFrequency == rightDemandedFrequency) {
					initialFrequency = value;
				}
				rightDemandedFrequency = value;
				isRightFrequencyManipulated = true;
			}

			label.text(value);
		}).change();

		sliders.on('input', function () {
			$(this).trigger('change');
		});

		init();
	});
})();

