var listCheckedOutGames = function(games) {
	for (i in games) {
		var row = $('<tr id="barcode' + games[i].barcode + '">');
		var cols = '';

		cols += '<td><input type="button" value="x" name="return' + i + '" id="' + games[i].barcode + '"/></td>';
		cols += '<td>' + games[i].barcode + ' - ' + games[i].title + '</td>';

		row.append(cols);
		$('#results').append(row);
	}
};

//clear attendee entry
var clearEntryForm = function() {
	$('#r_x_atte').toggleClass('invis', true);
	$("#r_a_id").attr('readonly', false);
	$("#r_a_id").val('');
	$("#a_label").text('');
	$('#r_a_id').focus();
};

$(document).ready(function() {

	//entry for attendee barcode
	$("#r_a_id").change(function(e) {
		if (bc_regex.test(this.value)) {
			$.ajax({
				url : "/returns/get_games",
				data : {
					a_id : this.value
				},
				dataType : "json",
				success : function(data) {
					if (data.has_games) {
						$("#r_a_id").attr('readonly', true);
						$('#r_x_atte').toggleClass('invis', false);
						listCheckedOutGames(data.games);
					} else {
						clearEntryForm();
					}
					$('#a_label').text(data.message);
				}
			});
		}
	});

	//return game on click of X button
	$('#results').on('click', 'input[name^="return"]', function() {
		var field = this;
		data = {
			g_id : field.id,
			a_id : $('#r_a_id').val()
		};
		$.ajax({
			url : '/returns/create',
			data : data,
			dataType : 'json',
			type : 'POST',
			success : function(data) {
				if (data.success) {
					$('#results tr[id="barcode' + field.id + '"]').remove();
					//TODO: display success message
				}
				if ($('#results tr').length < 1) {
					clearEntryForm();
				}
			}
		});
	});

	//clear entry form and rows on X
	$('#r_x_atte').click(function() {
		clearEntryForm();
		$('#results tr').remove();
	});

});
