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
//= require turbolinks
//= require bootstrap
//= require_tree .

var ready;
ready = function() {


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
		var nextHole = parseFloat(holeNum) + 1;
		var parValue = $(this).val();
		if( parValue >= 3 && parValue <= 5)
			if (nextHole < 19)
				$("#tee_par_hole_" + nextHole).focus();
			else
				$("#create_tee_button").focus();
		else
			$(this).val('');

		console.log("Next Hole:  " + nextHole);
	});


	//
	//  On the new score page, populate the tees dropdown after a course is picked.
	//
	$("#course_select_box").change(function(){
		var courseId = $(this).find(":selected").attr("value");
		if (courseId.length > 0)
		{
			$('#tee_select_box').empty();
			$('#tee_select_box').append('<option value="">Select a tee</option>');
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
					        	$('#tee_select_box').append('<option value="' + data[i].id + '">' + data[i].name + '</option>');
				        }
				        $('#tee_select_box').append('<option value="Add a tee">...Add a tee</option>');
				    }        
				});
			}
		}
	})



	//
	//  On the new score page, populate the par values on the scorecard after a tee is picked.
	//
	$("#tee_select_box").change(function(){
		var teeId = $(this).find(":selected").attr("value");
		if (teeId.length > 0)
		{
			console.log(teeId);
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
				    }        
				});
			}
		}
	})

};

$(document).ready(ready);
$(document).on('page:load', ready);



