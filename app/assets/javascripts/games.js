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
	
	//update section on selection oooh that kind of rhymes hee hee
	$('td[data-section] select').change(function(e){
		id = $(e.currentTarget).parent().data('id');
		
		tag = $('td[data-id="' + id + '"][data-section] select');
		tag.attr('disabled', true);

		$.ajax({
			url : '/games/update_section',
			data : {
				id: id,
				section_id: $(e.currentTarget).val() //section
			},
			dataType : 'json',
			type : 'POST',
			success : function(data) {
				//set field back to editable
				tag.attr('disabled', false);
				if(data.success){
					//set check mark to show and delay-disappear
					
				}else{
					//set x to show and delay-disappear
					
				}
			} 
		});
	});
	
});