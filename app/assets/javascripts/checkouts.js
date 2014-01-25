var enableCheckoutButton = function() {
	//$("#checkout_btn").prop("disabled", !v_g || !v_a);
	//$("#swap_btn").prop("disabled", (!v_g || !v_a) || (c_o != 1));
	$('#swap_chkbox').toggleClass('invis', c_o != 1);
	$('#x_atte').toggleClass('invis', !v_a);
	//$('#x_game').toggleClass('invis', !v_g);
};

var resetCheckout = function() {
	$("#co_a_id").attr('readonly', false);
	$("#co_a_id").focus();
	$("#a_label").text('');
	$("#g_label").text('');
	$("#co_a_id").val('');
	$("#co_g_id").val('');
	$('#swap_chkbox').toggleClass('invis', true);
	$('#swap_chkbox').prop('checked', true);
	v_a = false;
	v_g = false;
	c_o = 0;
	enableCheckoutButton();
};

var clearReturns = function(){
	$('#returns tr').remove();
	$('#swap_chkbox').toggleClass('invis', true);
};

var listCheckedOutGames = function(games) {
	for (i in games) {
		var row = $('<tr id="barcode' + games[i].barcode + '">');
		var cols = '';

		cols += '<td><input type="button" value="x" name="return' + i + '" id="' + games[i].barcode + '"/></td>';
		cols += '<td>' + games[i].barcode + ' - ' + games[i].name + '</td>';

		row.append(cols);
		$('#returns').append(row);
	}
};

var v_a = false;
var v_g = false;
var c_o = 0;

$(document).ready(function() {

	//entry for attendee barcode
	$("#co_a_id").change(function(e) {
		if (bc_regex.test(this.value)) {
			$.ajax({
				url : "/attendee_by_id",
				data : {
					a_id : this.value
				},
				dataType : "json",
				complete : enableCheckoutButton,
				success : function(att) {
					$("#g_label").text('');
					if (v_a = att.valid) {
						if(att.hasGames){
							//add checkouts to return table
							listCheckedOutGames(att.games);
							//TODO: display text for swap
						}
						//TODO: display text for checkout
						$("#co_g_id").focus();
					} else {
						$('#new_attendee > input[type="text"]').val('');
						$('#new_attendee').dialog('open');
					}
					$("#co_a_id").attr('readonly', att.valid);
					$("#a_label").text(att.info.name + att.status);
					c_o = att.games.length;
				}
			});
		}
	});

	//entry for game barcode
	$("#co_g_id").change(function(e) {
		if (bc_regex.test(this.value)) {
			data = {
				g_id : $('#co_g_id').val(),
				a_id : $('#co_a_id').val(),
				swap : $('#swap_chkbox').is(':visible') ? $('#swap_chkbox').prop('checked') : false
			};
			$.ajax({
				url : '/checkouts/create',
				data : data,
				dataType : "json",
				type : 'POST',
				complete : enableCheckoutButton,
				success : function(data) {
					if (data.success) {
						resetCheckout();
						clearReturns();
						//TODO: display success message
						$("#g_label").text(data.message);
					}else{
						$("#co_g_id").val('');
						$("#g_label").text(data.message);
					}
					//v_g = data.valid;
				}
			});
		}
	});

	//return game on click of X button
	$('#returns').on('click', 'input[name^="return"]', function() {
		var field = this;
		data = {
			g_id : field.id,
			a_id : $('#co_a_id').val()
		};
		$.ajax({
			url : '/return',
			data : data,
			dataType : 'json',
			type : 'POST',
			complete : enableCheckoutButton,
			success : function(data) {
				$("#g_label").text('');
				if (data.success) {
					$('#returns tr[id="barcode' + field.id + '"]').remove();
					c_o--;
					//TODO: display success message
				}
				if ($('#returns tr').length < 1) {
					resetCheckout();
				}
			}
		});
	});

	//X button for attendee barcode
	$('#x_atte').click(function() {
		$("#co_a_id").attr('readonly', false);
		$("#co_a_id").val('');
		$("#a_label").text('');
		$('#new_attendee').toggleClass('invis', true);
		$('#new_attendee > input').val('');
		v_a = false;
		c_o = 0;
		$("#co_a_id").focus();
		//clear returns
		clearReturns();
	});
	$('#x_atte').click(enableCheckoutButton);

	/*
	//X button for game barcode
	$('#x_game').click(function() {
		//$("#co_g_id").attr('readonly', false); not needed currently
		$("#co_g_id").val('');
		$("#g_label").text('');
		v_g = false;
		$("#co_g_id").focus();
	});
	$('#x_game').click(enableCheckoutButton);
	*/

	//modal dialog for new attendee
	$("#new_attendee").dialog({
		autoOpen : false,
		modal : true,
		resizable : true,
		buttons : {
			"Add Attendee" : function() {
				data = $('#new_attendee > input[type="text"], #co_a_id').serializeArray();
				$.ajax({
					url : '/attendees/create',
					data : data,
					dataType : 'json',
					type : 'POST',
					success : function(data) {
						$('#new_attendee > input').removeClass('error');
						if (data.success) {
							$("#new_attendee").dialog("close");
							$('#co_a_id').change();
						}else{
							data.missing.forEach(function(e){
								$('#' + e).addClass('error');
							});
						}
					}
				});
			},
			Cancel : function() {
				$("#new_attendee").dialog("close");
				$('#new_attendee > input[type="text"]').val('');
			}
		},
		close : function() {
			$('#new_attendee > input[type="text"]').val('');
			$('#new_attendee > input[type="text"]').removeClass('error');
			
			$('#co_a_id').val('');
			$("#a_label").text('');
		}
	});
});
