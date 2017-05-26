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
	$("[id^=tee_par_hole_]").keyup(function(e){
		if ((e.keyCode <= 57 && e.keyCode >= 48) || (e.keyCode <= 105 && e.keyCode >= 96) )  // only react to numbers
		{
			var inputId = $(this).attr("id");
			var holeNum = 0;
			if (inputId.length == 14)
				holeNum = inputId.slice(-1);
			else
				holeNum = inputId.slice(-2);
			var nextHole = parseInt(holeNum) + 1;
			var parValue = $(this).val();

			if( parValue >= 3 && parValue <= 5)
				if (nextHole < 19)
					$("#tee_par_hole_" + nextHole).focus();
				else
					$("#create_tee_button").focus();
			else
				$(this).val('');


			//
			//  Calculate total scores
			//
			var frontNineScore = 0;
			var backNineScore = 0;
			var totalScore = 0;
			for (i = 1; i <= 18; i++)
			{
				var holeVal = parseInt($("#tee_par_hole_" + i).val());
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
			var inputId = $(this).attr("id");
			var holeNum = 0;
			if (inputId.length == 18)
				holeNum = inputId.slice(-1);
			else
				holeNum = inputId.slice(-2);
			var par = $("#par_hole_" + holeNum).html();
			var nextHole = parseInt(holeNum) + 1;
			var score = $(this).val();
			if (score == 1)
				return;
			var escScore = GetESCScore($("#handicap").attr("value"), par);
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
			$(this).val("");
			e.preventDefault();
			return;
		}
	});

	//
	//  Move the cursor to the next putt input box if user enters a numeric value.
	//  Calculate total putts also.
	//
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
			{
				if ($("#score_score_hole_" + nextHole).is(":visible"))
					$("#score_score_hole_" + nextHole).focus();
				else
					$("#score_greens_in_regulation").focus();		// skip back 9 if there are only 9 holes on course
			}
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
			$(this).val("");
			e.preventDefault();
			return;
		}
	});




	function GetESCScore(courseHandicap, par)
	{
		if (courseHandicap >= -9)
			return (parseInt(par) + 2);
		else if (courseHandicap >= -19)
			return 7;
		else if (courseHandicap >= -29)
			return 8;
		else if (courseHandicap >= -39)
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

				    	// hide back 9 if it is only a 9 hole course
				    	if (data["par_hole_10"] == null)
				    	{
							$("#back_9_hole_label_row").hide();
							$("#back_9_par_label_row").hide();
							$("#back_9_scores_row").hide();
							$("#back_9_putts_row").hide();
						}
						else
						{
							$("#back_9_hole_label_row").show();
							$("#back_9_par_label_row").show();
							$("#back_9_scores_row").show();
							$("#back_9_putts_row").show();
						}	
				    }    
				});
			}
		}
	})

	//
	//  On the edit score page, unhide all the elements on the scorecard
	//
	var title = $(document).attr('title');
	if (title == 'Golfingscores Edit Score' || $(".errors").is(":visible"))
	{
		$("#course_select_div").show();
		$("#tee_select_div").show();
		$("#scorecard_holes_table").show();
		$("#create_score_button").show();

		// hide back 9 if it is only a 9 hole course
    	if ($("#par_hole_10").html() == "")
    	{
			$("#back_9_hole_label_row").hide();
			$("#back_9_par_label_row").hide();
			$("#back_9_scores_row").hide();
			$("#back_9_putts_row").hide();
		}
		else
		{
			$("#back_9_hole_label_row").show();
			$("#back_9_par_label_row").show();
			$("#back_9_scores_row").show();
			$("#back_9_putts_row").show();
		}	
	}

	//
	//  On the edit tee page, hide back 9 if it is a 9 hole tee.
	//
	if (title == 'Golfingscores Edit Tee')
	{
		// hide back 9 if it is only a 9 hole tee
    	if ($("#tee_par_hole_10").val() == "")
    	{
			$("#back_9_hole_label_row").hide();
			$("#back_9_par_nums").hide();
		}
	}


	//
	//  On scores page, muck with some CSS so the handicap displays correctly.
	//
	if (title == 'Golfingscores Scores')
    	$(".page-header").attr("style", "width: 75%; float: left;");



	//
	//  On the charts page, load the google charts stuff.
	//
	if (title == 'Golfingscores Charts')
	{
	    google.charts.load('current', { 'packages': ['corechart'] });
	    google.charts.setOnLoadCallback(drawCharts);
    }


    // Callback that creates and populates a data table,
    // instantiates the pie chart, passes in the data and
    // draws it.
    function drawCharts() 
    {
    	// draw18HoleHistoryChart();
    	// draw9HoleHistoryChart();
    	drawScoreHistoryChart(18);
    	drawScoreHistoryChart(9);
    	drawAveragePuttsPerGreenPerRoundChart();
    	drawPuttDistributionChart();
    	drawPuttDistributionPieChart();
    	drawGIRPieChart();
    	drawFairwaysHitPieChart();
    	drawPenaltiesPerNineChart();
    }

};


$(document).on('turbolinks:load', ready);


function drawScoreHistoryChart(historyType)  // 9 or 18 holes
{
	var chartData = new google.visualization.DataTable();
    chartData.addColumn('datetime', 'Date');
    chartData.addColumn('number', 'Score');
    chartData.addColumn({ type: 'string', role: 'tooltip', 'p': {'html': true} });
    chartData.addColumn('number', 'id');
	$.ajax({
	    type: "GET",
	    url: "/charts/get_recent_scores_" + historyType,
	    dataType: "json",
	    success: function(data){
	    	if (data.length > 0)
	    	{
		        for (i = 0; i < data.length; i++)
		        {
		        	// subtract 1 from month b/c js date uses zero based month for some stupid reason
		        	var dt = new Date(data[i].year, data[i].month - 1, data[i].day);  
		        	chartData.addRow([dt, data[i].total, genToolTip(dt, data[i].total, data[i].course), data[i].id]);
		        }
		        // Set chart options
		        var options = {
		            'title': historyType + ' Hole Score History',
		            tooltip: { isHtml: true },
		            pointSize: 10,
		            curveType: 'function',
		            dataOpacity: 0.3,
		            titleTextStyle: {
				        fontSize: 24, // 12, 18 whatever you want (don't specify px)
				        bold: false
				    },
				    chartArea:{left: 50, right: 100}
		        };

		       	// Create view from dataTable so can hide the id column, don't want to display it
		        var view = new google.visualization.DataView(chartData);
    			view.setColumns([0, 1, 2]);

		        // Instantiate and draw our chart, passing in some options.
		        var scoreHistoryChart = new google.visualization.LineChart(document.getElementById('score_history_chart_' + historyType + '_hole'));
		        scoreHistoryChart.draw(view, options);

		        var selectHandler = function(e) {
		        	if (scoreHistoryChart.getSelection().length > 0)
		        	{
			        	var item = scoreHistoryChart.getSelection()[0];
			        	if (item.row != null && item.column != null) {
      						score_id = chartData.getValue(scoreHistoryChart.getSelection()[0]['row'], 3 )
      						window.location.href = '/scores/' + score_id + '/edit';
      					}
  					}
		        }

		        // Add our selection handler.
		        google.visualization.events.addListener(scoreHistoryChart, 'select', selectHandler);
	        }
	    }        
	});
}


function drawAveragePuttsPerGreenPerRoundChart()
{
	var chartData = new google.visualization.DataTable();
    chartData.addColumn('datetime', 'Date');
    chartData.addColumn('number', 'Avg Putts');
    chartData.addColumn({ type: 'string', role: 'tooltip', 'p': {'html': true} });
    chartData.addColumn('number', 'id');
	$.ajax({
	    type: "GET",
	    url: "/charts/get_average_putts_per_green_per_round",
	    dataType: "json",
	    success: function(data){
	    	if (data.length > 0)
	    	{
		        for (i = 0; i < data.length; i++)
		        {
		        	// subtract 1 from month b/c js date uses zero based month for some stupid reason
		        	var dt = new Date(data[i].year, data[i].month - 1, data[i].day);  
		        	chartData.addRow([dt, data[i].avg_putts_per_green, genToolTipPuttAvg(dt, data[i].total, data[i].avg_putts_per_green, data[i].course), data[i].id]);
		        }
		        // Set chart options
		        var options = {
		            'title': 'Average Putts per Green per Round',
		            tooltip: { isHtml: true },
		            pointSize: 10,
		            curveType: 'function',
		            dataOpacity: 0.3,
		            titleTextStyle: {
				        fontSize: 24, // 12, 18 whatever you want (don't specify px)
				        bold: false
				    },
				    chartArea:{left: 50, right: 100},
				    interpolateNulls: true
		        };

		       	// Create view from dataTable so can hide the id column, don't want to display it
		        var view = new google.visualization.DataView(chartData);
    			view.setColumns([0, 1, 2]);

		        // Instantiate and draw our chart, passing in some options.
		        var avgPuttsChart = new google.visualization.LineChart(document.getElementById('average_putts_per_green_per_round'));
		        avgPuttsChart.draw(view, options);

		        var selectHandler = function(e) {
		        	if (avgPuttsChart.getSelection().length > 0)
		        	{
			        	var item = avgPuttsChart.getSelection()[0];
			        	if (item.row != null && item.column != null) {
      						score_id = chartData.getValue(avgPuttsChart.getSelection()[0]['row'], 3 )
      						window.location.href = '/scores/' + score_id + '/edit';
      					}
  					}
		        }

		        // Add our selection handler.
		        google.visualization.events.addListener(avgPuttsChart, 'select', selectHandler);
	        }
	    }        
	});	
}
 


function drawPuttDistributionChart()
{
	var chartData = new google.visualization.DataTable();
    chartData.addColumn('string', 'Number of Putts');
    chartData.addColumn('number', 'How many times');
	$.ajax({
	    type: "GET",
	    url: "/charts/putt_distribution",
	    dataType: "json",
	    success: function(data){
	    	if (data != null)
	    	{
	        	chartData.addRow(['Zero Putts', data.zero]);
	        	chartData.addRow(['One Putt', data.one]);
	        	chartData.addRow(['Two Putts', data.two]);
	        	chartData.addRow(['Three Putts', data.three]);
	        	chartData.addRow(['Four Putts', data.four]);
	        	chartData.addRow(['More than Four', data.other]);

		        // Set chart options
		        var options = {
		            'title': 'Putt Distribution (how many 2 putts, how many 3 putts, etc.)',
		            tooltip: { isHtml: true },
		            // pointSize: 10,
		            // curveType: 'function',
		            dataOpacity: 0.3,
		            titleTextStyle: {
				        fontSize: 24, // 12, 18 whatever you want (don't specify px)
				        bold: false
				    },
				    chartArea:{left: 50, right: 100}
				    // interpolateNulls: true
		        };

		        // Instantiate and draw our chart, passing in some options.
		        var puttDistributionChart = new google.visualization.ColumnChart(document.getElementById('putt_distribution_column_chart'));
		        puttDistributionChart.draw(chartData, options);
	        }
	    }        
	});	
}   



function drawPuttDistributionPieChart()
{
	var chartData = new google.visualization.DataTable();
    chartData.addColumn('string', 'Number of Putts');
    chartData.addColumn('number', 'How many times');
	$.ajax({
	    type: "GET",
	    url: "/charts/putt_distribution",
	    dataType: "json",
	    success: function(data){
	    	if (data != null)
	    	{
	    		var oneOrLess = data.zero + data.one;
	    		var threeOrMore = data.three + data.four + data.other;
	        	chartData.addRow(['One or Less Putts', oneOrLess]);
	        	chartData.addRow(['Two Putts', data.two]);
	        	chartData.addRow(['Three or More Putts', threeOrMore]);

		        // Set chart options
		        var options = {
		            'title': 'Putt Distribution',
		            tooltip: { isHtml: true },
		            // pointSize: 10,
		            // curveType: 'function',
		            dataOpacity: 0.3,
		            titleTextStyle: {
				        fontSize: 24, // 12, 18 whatever you want (don't specify px)
				        bold: false
				    },
				    chartArea:{left: 50, right: 100},
				    colors: ['green', '#3366CC', '#DB3B14']
				    // interpolateNulls: true
		        };

		        // Instantiate and draw our chart, passing in some options.
		        var puttDistributionChart = new google.visualization.PieChart(document.getElementById('putt_distribution_pie_chart'));
		        puttDistributionChart.draw(chartData, options);
	        }
	    }        
	});	
}   



function drawGIRPieChart()
{
	var chartData = new google.visualization.DataTable();
    chartData.addColumn('string', 'Number of Putts');
    chartData.addColumn('number', 'How many times');
	$.ajax({
	    type: "GET",
	    url: "/charts/gir",
	    dataType: "json",
	    success: function(data){
	    	if (data != null)
	    	{
	    		chartData.addRow(['Greens in Regulation', data.greensInRegulation]);
	        	chartData.addRow(['Greens not in Regulation', data.greensNotInRegulation]);

		        // Set chart options
		        var options = {
		            'title': 'Greens in Regulation',
		            tooltip: { isHtml: true },
		            // pointSize: 10,
		            // curveType: 'function',
		            dataOpacity: 0.3,
		            titleTextStyle: {
				        fontSize: 24, // 12, 18 whatever you want (don't specify px)
				        bold: false
				    },
				    chartArea:{left: 50, right: 100}
				    // interpolateNulls: true
		        };

		        // Instantiate and draw our chart, passing in some options.
		        var girChart = new google.visualization.PieChart(document.getElementById('gir_pie_chart'));
		        girChart.draw(chartData, options);
	        }
	    }        
	});	
}   




function drawFairwaysHitPieChart()
{
	var chartData = new google.visualization.DataTable();
    chartData.addColumn('string', 'Fairways Hit');
    chartData.addColumn('number', 'How many times');
	$.ajax({
	    type: "GET",
	    url: "/charts/fairways_hit",
	    dataType: "json",
	    success: function(data){
	    	if (data != null)
	    	{
	        	chartData.addRow(['Fairways Hit', data.hit]);
	        	chartData.addRow(['Fairways Missed', data.missed]);

		        // Set chart options
		        var options = {
		            'title': 'Fairways Hit',
		            tooltip: { isHtml: true },
		            // pointSize: 10,
		            // curveType: 'function',
		            dataOpacity: 0.3,
		            titleTextStyle: {
				        fontSize: 24, // 12, 18 whatever you want (don't specify px)
				        bold: false
				    },
				    chartArea:{left: 50, right: 100}
				    // interpolateNulls: true
		        };

		        // Instantiate and draw our chart, passing in some options.
		        var girChart = new google.visualization.PieChart(document.getElementById('fairways_hit_pie_chart'));
		        girChart.draw(chartData, options);
	        }
	    }        
	});	
}   


function drawPenaltiesPerNineChart()
{
	var chartData = new google.visualization.DataTable();
    chartData.addColumn('datetime', 'Date');
    chartData.addColumn('number', 'Penalties per Nine');
    chartData.addColumn({ type: 'string', role: 'tooltip', 'p': {'html': true} });
    chartData.addColumn('number', 'id');
	$.ajax({
	    type: "GET",
	    url: "/charts/penalties_per_nine",
	    dataType: "json",
	    success: function(data){
	    	if (data.length > 0)
	    	{
		        for (i = 0; i < data.length; i++)
		        {
		        	// subtract 1 from month b/c js date uses zero based month for some stupid reason
		        	var dt = new Date(data[i].year, data[i].month - 1, data[i].day);  
		        	chartData.addRow([dt, data[i].penalties_per_nine, genToolTipPenaltiesPerNine(dt, data[i].total, data[i].penalties_per_nine, data[i].course), data[i].id]);
		        }
		        // Set chart options
		        var options = {
		            'title': 'Penalties per Nine',
		            tooltip: { isHtml: true },
		            pointSize: 10,
		            curveType: 'function',
		            dataOpacity: 0.3,
		            titleTextStyle: {
				        fontSize: 24, // 12, 18 whatever you want (don't specify px)
				        bold: false
				    },
				    chartArea:{left: 50, right: 100},
				    interpolateNulls: true
		        };

		       	// Create view from dataTable so can hide the id column, don't want to display it
		        var view = new google.visualization.DataView(chartData);
    			view.setColumns([0, 1, 2]);

		        // Instantiate and draw our chart, passing in some options.
		        var avgPuttsChart = new google.visualization.LineChart(document.getElementById('penalties_per_nine_chart'));
		        avgPuttsChart.draw(view, options);

		        var selectHandler = function(e) {
		        	if (avgPuttsChart.getSelection().length > 0)
		        	{
			        	var item = avgPuttsChart.getSelection()[0];
			        	if (item.row != null && item.column != null) {
      						score_id = chartData.getValue(avgPuttsChart.getSelection()[0]['row'], 3 )
      						window.location.href = '/scores/' + score_id + '/edit';
      					}
  					}
		        }

		        // Add our selection handler.
		        google.visualization.events.addListener(avgPuttsChart, 'select', selectHandler);
	        }
	    }        
	});	
}



function genToolTip(dt, score, course )
{
    var tooltip = '<div class="tool_tip">#_DATE_#<br>Score:  <b>#_SCORE_#</b><br>#_COURSE_#</div>';
    tooltip = tooltip.replace('#_DATE_#', dt.toDateString());
    tooltip = tooltip.replace('#_SCORE_#', score);
    tooltip = tooltip.replace('#_COURSE_#', course);
    return tooltip;
}

function genToolTipPuttAvg(dt, score, puttAvg, course )
{
    var tooltip = '<div class="tool_tip">#_DATE_#<br>Score:  <b>#_SCORE_#</b><br>Putt Avg:  <b>#_PUTT_AVG_#</b><br>#_COURSE_#</div>';
    tooltip = tooltip.replace('#_DATE_#', dt.toDateString());
    tooltip = tooltip.replace('#_SCORE_#', score);
    tooltip = tooltip.replace('#_PUTT_AVG_#', puttAvg);
    tooltip = tooltip.replace('#_COURSE_#', course);
    return tooltip;
}

function genToolTipPenaltiesPerNine(dt, score, penalties, course )
{
    var tooltip = '<div class="tool_tip">#_DATE_#<br>Score:  <b>#_SCORE_#</b><br>Penalties per Nine:  <b>#_PENALTIES_#</b><br>#_COURSE_#</div>';
    tooltip = tooltip.replace('#_DATE_#', dt.toDateString());
    tooltip = tooltip.replace('#_SCORE_#', score);
    tooltip = tooltip.replace('#_PENALTIES_#', penalties);
    tooltip = tooltip.replace('#_COURSE_#', course);
    return tooltip;
}

