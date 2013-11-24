var enableCheckoutButton = function() {
	$("#checkout_btn").prop("disabled", !v_g || !v_a);
	$("#swap_btn").prop("disabled", (!v_g || !v_a) || (c_o != 1));
	$('#x_atte').toggleClass('invis', !v_a);
	$('#x_game').toggleClass('invis', !v_g);
};

var resetCheckout = function() {
	$("#co_a_id").attr('readonly', false);
	$("#a_label").text('');
	$("#g_label").text('');
	$("#co_a_id").val('');
	$("#co_g_id").val('');
	v_a = false;
	v_g = false;
	c_o = 0;
};

var bc_regex = /^[a-z]{3}[a-z0-9]{3,6}$/i;
var v_a = false;
var v_g = false;
var c_o = 0;

$(document).ready(function() {

	//entry for attendee barcode
	$("#co_a_id").change(function(e) {
		if (bc_regex.test(this.value)) {
			$.ajax({
				url : "/is_valid_attendee",
				data : {
					a_id : this.value
				},
				dataType : "json",
				complete : enableCheckoutButton,
				success : function(data) {
					if ( v_a = data.valid) {
						$("#co_g_id").toggleClass('invis', false);
						$("#co_g_id").focus();
					} else {
						$('#new_attendee').dialog('open');
					}
					$("#co_a_id").attr('readonly', data.valid);
					$("#a_label").text(data.message);
					c_o = data.coCount;
				}
			});
		}
	});

	//entry for game barcode
	$("#co_g_id").change(function(e) {
		if (bc_regex.test(this.value)) {
			$.ajax({
				url : "/is_valid_game",
				data : {
					g_id : this.value
				},
				dataType : "json",
				complete : enableCheckoutButton,
				success : function(data) {
					$("#g_label").text(data.message);
					v_g = data.valid;
				}
			});
		}
	});

	//checkout button for new checkouts
	$('#checkout_btn').click(function() {
		data = {
			g_id : $('#co_g_id').val(),
			a_id : $('#co_a_id').val()
		};
		$.ajax({
			url : '/checkouts/create',
			data : data,
			dataType : 'json',
			type : 'POST',
			complete : enableCheckoutButton,
			success : function(data) {
				if (data.success) {
					resetCheckout();
					//TODO: display success message
				}
			}
		});
	});

	//swap button for new checkouts
	$('#swap_btn').click(function() {
		data = {
			g_id : $('#co_g_id').val(),
			a_id : $('#co_a_id').val()
		};
		data.swap = true;
		$.ajax({
			url : '/checkouts/swap',
			data : data,
			dataType : 'json',
			type : 'POST',
			complete : enableCheckoutButton,
			success : function(data) {
				if (data.success) {
					resetCheckout();
					//TODO: display success message
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
	});
	$('#x_atte').click(enableCheckoutButton);

	//X button for game barcode
	$('#x_game').click(function() {
		//$("#co_g_id").attr('readonly', false); not needed currently
		$("#co_g_id").val('');
		$("#g_label").text('');
		v_g = false;
	});
	$('#x_game').click(enableCheckoutButton);

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
						if (data.success) {
							$("#new_attendee").dialog("close");
							$('#co_a_id').change();
						}
					}
				});
			},
			Cancel : function() {
				$("#new_attendee").dialog("close");
			}
		},
		close : function() {
			$('#new_attendee > input[type="text"]').val('');
		}
	});
});
