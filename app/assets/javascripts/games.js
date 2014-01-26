var clearEntryForm = function(){
	$('#game_form input[type="text"], #section_id').val('');
};

$(document).ready(function() {

	//add game on click
	$('#add_btn').click(function() {
		if (bc_regex.test($('#g_id').val())) {
			$('#g_label').text('');
			$('#game_form input[type="text"]').removeClass('error');
			
			data = $('#game_form input[type="text"], #section_id').serializeArray();
			$.ajax({
				url : '/games/create',
				data : data,
				dataType : 'json',
				type : 'POST',
				//complete : enableCheckoutButton,
				success : function(data) {
					if(data.success || data.exists){
						clearEntryForm();
					}else{
						//highlight missing fields
						for(var i = 0; i < data.missing.length; i++){
							$('#' + data.missing[i]).addClass('error');
						}
					}
					$('#g_label').text(data.message);
				}
			});
		}
	});
	
});