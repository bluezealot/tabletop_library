var activeGameCount = function(bool){
	var count = parseInt($('#activeGameCount').text());
	if(bool){
		++count;
	}else{
		if(--count < 0){
			count = 0;
		}
	}
	$('#activeGameCount').text(count);
};

$(document).ready(function() {
	$(".active-chkbox").bootstrapSwitch();
	//replace un-formatted <em> field with matching <a> field
	$('em.current').replaceWith('<a class="current" style="background-color: #ccc;">' + $('em.current').text() + '</a>');

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
				$('td[data-id="' + data.id + '"][data-section] select').attr('disabled', false);
				if(data.success){
					//set check mark to show and delay-disappear
					$('#' + data.id + '-tinycheck').removeClass('invis');
					setTimeout(function(){ $('#' + data.id + '-tinycheck').addClass('invis'); }, 1000);
				}else{
					//set x to show and delay-disappear
					$('#' + data.id + '-tinyx').removeClass('invis');
					setTimeout(function(){ $('#' + data.id + '-tinyx').addClass('invis'); }, 1000);
				}
			} 
		});
	});
	
	$('#games').on('switch-change', '.active-chkbox', function(e){
		if($(this).hasClass('failed')){
			$(this).removeClass('failed');
			return;
		}
		var id = $(this).data('id');
		
		var barcode = $('td[data-id=' + id + '][data-barcode]').data('barcode');
		
		var url = '';
		var state = $(this).bootstrapSwitch('state');
		if(state){
			url = '/games/activate';
		}else{
			url = '/games/deactivate';
		}
		
		$.ajax({
			url : url,
			data : {
				id: barcode
			},
			dataType : 'json',
			type : 'POST',
			success : function(data) {
				//set field back to editable
				if(data.success){
					activeGameCount(state);
					//set check mark to show and delay-disappear
					$('#' + data.info.id + '-tinycheck').removeClass('invis');
					setTimeout(function(){ $('#' + data.info.id + '-tinycheck').addClass('invis'); }, 1000);
				}else{
					//set x to show and delay-disappear
					$('.active-chkbox[data-id="' + data.info.id + '"]').addClass('failed');
					$('.active-chkbox[data-id="' + data.info.id + '"]').bootstrapSwitch('setState', !state);
					$('#' + data.info.id + '-tinyx').removeClass('invis');
					setTimeout(function(){ $('#' + data.info.id + '-tinyx').addClass('invis'); }, 1000);
				}
			} 
		});
	});
	
});