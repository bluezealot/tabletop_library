var enableCheckoutButton = function() {
	checkBoxInvis(c_o != 1);
	$('#x_atte').toggleClass('invis', !v_a);
	$('#co_g_id').toggleClass('invis', !v_a);
	if(v_a){
		$("#co_g_id").focus();
	}
};

var checkBoxInvis = function(val){
	$('#swap_chkbox').parent().parent().toggleClass('invis', val);
};

var resetCheckout = function() {
	$("#co_a_id").attr('readonly', false);
	$("#co_a_id").focus();
	$("#a_label").text('');
	$("#g_label").text('');
	$("#co_a_id").val('');
	$("#co_g_id").val('');
	
	checkBoxInvis(true);
	
	$('#swap_chkbox').bootstrapSwitch('state', true);
	v_a = false;
	v_g = false;
	c_o = 0;
	enableCheckoutButton();
};

var clearReturns = function(){
	$('#returns tr').remove();
	checkBoxInvis(true);
};

var listCheckedOutGames = function(games) {
	for (i in games) {
		var row = $('<tr id="barcode' + games[i].barcode + '">');
		var cols = '';

		cols += '<td><button type="button" class="btn btn-danger" name="return' + i + '" id="' + games[i].barcode + '">x</button></td>';
		cols += '<td>' + games[i].barcode + ' - ' + games[i].name + '</td>';

		row.append(cols);
		$('#returns').append(row);
	}
};

var v_a = false;
var v_g = false;
var c_o = 0;

$(document).ready(function() {
	$("#swap_chkbox").bootstrapSwitch();
	checkBoxInvis(true);
	
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
						}
						$("#a_label").text(att.info.name + att.status);
					} else {
						$("#a_label").text('');
						$('#new_attendee > input[type="text"]').val('');
						$('#new_attendee').dialog('open');
					}
					$("#co_a_id").attr('readonly', att.valid);
					
					c_o = att.games.length;
				}
			});
		}
	});

	//entry for game barcode
	$("#co_g_id").change(function(e) {
		if (bc_regex.test(this.value)) {
			q_data = {
				g_id : $('#co_g_id').val(),
				a_id : $('#co_a_id').val(),
				swap : $('#swap_chkbox').parent().parent().is(':visible') ? $('#swap_chkbox').bootstrapSwitch('state') : false
			};
			$.ajax({
				url : '/checkouts/create',
				data : q_data,
				dataType : "json",
				type : 'POST',
				complete : enableCheckoutButton,
				success : function(data) {
					if (data.success) {
						resetCheckout();
						clearReturns();
						$("#g_label").text(data.message);
					}else{
						$("#co_g_id").val('');
						$("#g_label").text(data.message);
					}
				}
			});
		}
	});

	//return game on click of X button
	$('#returns').on('click', 'button[name^="return"]', function() {
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
		$('#new_attendee > input').val('');
		v_a = false;
		c_o = 0;
		$("#co_a_id").focus();
		//clear returns
		clearReturns();
	});
	$('#x_atte').click(enableCheckoutButton);

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
							a_id = $('#co_a_id').val();
							$("#new_attendee").dialog("close");
							$('#co_a_id').val(a_id);
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
				$('#co_a_id').val('');
				$("#co_a_id").focus();
			}
		},
		close : function() {
			$('#new_attendee > input[type="text"]').val('');
			$('#new_attendee > input[type="text"]').removeClass('error');
			$("#co_a_id").focus();
			
			$('#co_a_id').val('');
			$("#a_label").text('');
		}
	});
	
	$('#checkout_form > input').focus(pTipIn);
	$('#checkout_form > input').blur(pTipOut);
	
	$("#return-confirm").dialog({
		autoOpen : false,
		modal : true,
		buttons : {
			"Return" : function() {
				$.ajax({
					url : '/return',
					data : {
						g_id: $('.return-this').data('g_id'),
						a_id: $('.return-this').data('a_id')
					},
					dataType : 'json',
					type : 'POST',
					success : function(data) {
						//remove checkout row
						if (data.success) {
							$('.return-this').remove();
						}else{
							$('.return-this').removeClass('return-this');
						}
						$("#return-confirm").dialog('close');
					}
				});
			},
			Cancel : function() {
				$('.return-this').removeClass('return-this');
				$("#return-confirm").dialog('close');
			}
		},
		close : function() {
			$('.return-this').removeClass('return-this');
		}
	});
	
	$('#allCheckouts').on('click', '.index-return', function(){
		var _me = $(this).parent().parent();
		
		_me.addClass('return-this');
		$('#attendee_name').text(_me.data('attendee_name'));
		$('#game_name').text(_me.data('game_name'));
		
		$("#return-confirm").dialog('open');
	});
	
});

var randId = function(){
	return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
};
