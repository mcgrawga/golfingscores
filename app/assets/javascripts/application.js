// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/datepicker
//= require turbolinks
//= require bootstrap
//= require_tree .

var ready;
ready = function() {
	$( "#date_played_scorecard" ).datepicker();


	$('#new_user').submit(function(event) {
		// Devise names the forms for different things the same name.
		// We only want to do this when creating a new user, not recovering a password
		// or something else.
		if (window.location.pathname == '/users/sign_up' || window.location.pathname == '/settings/renew_subscription')
		{
			// Disable the submit button to prevent repeated clicks:
			$(this).find('.submit').prop('disabled', true);

			// Request a token from Stripe:
			Stripe.card.createToken($(this), stripeResponseHandler);

			// Prevent the form from being submitted:
			return false;
		}
	});

	function stripeResponseHandler(status, response) {
		// Grab the form:
		var $form = $('#new_user');

		if (response.error) { // Problem!

		// Show the errors on the form:
		$form.find('.payment-errors').text(response.error.message);
		$form.find('.submit').prop('disabled', false); // Re-enable submission

		} else { // Token was created!

		// Get the token ID:
		var token = response.id;

		// Insert the token ID into the form so it gets submitted to the server:
		$form.append($('<input type="hidden" name="stripeToken">').val(token));

		// Submit the form:
		$form.get(0).submit();
		}
	};

	//
	//	Move the cursor to the next tee input box if user enters a 3,4,5.
	//  Blank and clear the input if user enters anything other than 3,4,5.
	//  This is only for entering or updating tees, not scores.
	//
	$("[id^=tee_par_hole_]").keyup(function(){
		var inputId = $(this).attr("id");
		var holeNum = 0;
		if (inputId.length == 14)
			holeNum = inputId.slice(-1);
		else
			holeNum = inputId.slice(-2);;
		var nextHole = parseInt(holeNum) + 1;
		var parValue = $(this).val();
		if( parValue >= 3 && parValue <= 5)
			if (nextHole < 19)
				$("#tee_par_hole_" + nextHole).focus();
			else
				$("#create_tee_button").focus();
		else
			$(this).val('');
	});



	//
	//	Move the cursor to the next score input box if user enters an appropriate score (2, 3, 4, 5).
	//  If they enter a 1, do nothing.  Might be a hole in one, might be entering a 10.
	//  If they enter 6, 7, 8, 9, check their course handicap and adjust for equitable stroke control if necessary (esc)
	//  9 or less:     Double bogey
	//  10-19:         7
	//  20-29:         8
	//  30-39:         9
	//  40 and above:  10
	//  If they enter a 10-19, adjust for esc.
	//


	$("[id^=score_score_hole_]").keyup(function(e){
		if ((e.keyCode <= 57 && e.keyCode >= 48) || (e.keyCode <= 105 && e.keyCode >= 96) )  // only react to numbers
		{
			console.log("key code:  " + e.keyCode);
			var inputId = $(this).attr("id");
			var holeNum = 0;
			if (inputId.length == 18)
				holeNum = inputId.slice(-1);
			else
				holeNum = inputId.slice(-2);
			var par = $("#par_hole_" + holeNum).html();
			var courseHandicap = 9;
			var nextHole = parseInt(holeNum) + 1;
			var score = $(this).val();
			if (score == 1)
				return;
			var escScore = GetESCScore(courseHandicap, par);
			if (score > escScore)
				score = escScore;
			$(this).val(score);
			if (nextHole == 19)
				$("#score_putts_hole_10").focus();
			else if (nextHole == 10)
				$("#score_putts_hole_1").focus();
			else
				$("#score_score_hole_" + nextHole).focus();

			//
			//  Calculate total scores
			//
			var frontNineScore = 0;
			var backNineScore = 0;
			var totalScore = 0;
			for (i = 1; i <= 18; i++)
			{
				var holeVal = parseInt($("#score_score_hole_" + i).val());
				if (!isNaN(holeVal))
				{
					if (i <= 9)
						frontNineScore += holeVal;
					if (i >= 10 && i <= 18)
						backNineScore += holeVal;
					totalScore += holeVal;
				}
			}
			if (frontNineScore > 0)
				$('#front_nine_total').val(frontNineScore);
			if (backNineScore > 0)
				$('#back_nine_total').val(backNineScore);
			if (totalScore > 0)
				$('#total_score').val(totalScore);
		}
		else
		{
			e.preventDefault();
			return;
		}
	});


	$("[id^=score_putts_hole_]").keyup(function(e){
		if ((e.keyCode <= 57 && e.keyCode >= 48) || (e.keyCode <= 105 && e.keyCode >= 96) )  // only react to numbers
		{
			var inputId = $(this).attr("id");
			var holeNum = 0;
			if (inputId.length == 18)
				holeNum = inputId.slice(-1);
			else
				holeNum = inputId.slice(-2);
			var nextHole = parseInt(holeNum) + 1;
			var score = $(this).val();
			$(this).val(score);
			if (nextHole == 19)
				$("#score_greens_in_regulation").focus();
			if (nextHole == 10)
				$("#score_score_hole_" + nextHole).focus();
			else
				$("#score_putts_hole_" + nextHole).focus();

			//
			//  Calculate total scores
			//
			var frontNineScore = 0;
			var backNineScore = 0;
			var totalScore = 0;
			for (i = 1; i <= 18; i++)
			{
				var holeVal = parseInt($("#score_putts_hole_" + i).val());
				if (!isNaN(holeVal))
				{
					if (i <= 9)
						frontNineScore += holeVal;
					if (i >= 10 && i <= 18)
						backNineScore += holeVal;
					totalScore += holeVal;
				}
			}
			if (frontNineScore > 0)
				$('#front_nine_putts_total').val(frontNineScore);
			if (backNineScore > 0)
				$('#back_nine_putts_total').val(backNineScore);
			if (totalScore > 0)
				$('#total_putts').val(totalScore);
		}
		else
		{
			e.preventDefault();
			return;
		}
	});




	function GetESCScore(courseHandicap, par)
	{
		if (courseHandicap <= 9)
			return (parseInt(par) + 2);
		else if (courseHandicap <= 19)
			return 7;
		else if (courseHandicap <= 29)
			return 8;
		else if (courseHandicap <= 39)
			return 9;
		else 
			return 10;
	}

	//
	//  On the new score page, show the course dropdown after a date is selected
	//
	$("#date_played_scorecard").change(function(){
		$("#course_select_div").show();
	})


	//
	//  On the new score page, populate the tees dropdown after a course is picked, then display it
	//
	$("#course_select_box").change(function(){
		var courseId = $(this).find(":selected").attr("value");
		if (courseId.length > 0)
		{
			$('#tee_select_control').empty();
			$('#tee_select_control').append('<option value="">Select a tee</option>');
			if (courseId == "Add a course")
				window.location.href = "/courses/new";
			else
			{
				$.ajax({
				    type: "GET",
				    url: "/scores/get_tees_for_course/" + courseId,
				    dataType: "json",
				    success: function(data){
				    	if (data.length > 0)
				    	{
					        for (i = 0; i < data.length; i++)
					        	$('#tee_select_control').append('<option value="' + data[i].id + '">' + data[i].name + '</option>');
				        }
				        $('#tee_select_control').append('<option value="Add a tee">...Add a tee</option>');
				        $('#tee_select_div').show();
				    }        
				});
			}
		}
	})



	//
	//  On the new score page, populate the par values on the scorecard after a tee is picked.
	//
	$("#tee_select_control").change(function(){
		var teeId = $(this).find(":selected").attr("value");
		if (teeId.length > 0)
		{
			if (teeId == "Add a tee")
			{
				var courseId = $("#course_select_box").find(":selected").attr("value");
				window.location.href = "/courses/" + courseId + "/tees/new";
			}
			else
			{
				$.ajax({
				    type: "GET",
				    url: "/scores/get_tee/" + teeId,
				    dataType: "json",
				    success: function(data){
				    	for (i=1; i<19; i++)
				    		$("#par_hole_" + i).html(data["par_hole_" + i]);
				    	$('#scorecard_holes_table').show();
				    	$('#create_score_button').show();
				    	$('#score_score_hole_1').focus();
				    }        
				});
			}
		}
	})

	//
	//  On the edit score page, unhide all the elements on the scorecard
	//
	var title = $(document).attr('title');
	if (title == 'Statgolf Edit Score')
	{
		$("#course_select_div").show();
		$("#tee_select_div").show();
		$("#scorecard_holes_table").show();
		$("#create_score_button").show();
	}

};

// $(document).ready(ready);
// $(document).on('page:load', ready);

$(document).on('turbolinks:load', ready);



