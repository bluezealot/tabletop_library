var true_src = '/assets/check.png';
var false_src = '/assets/x.png';

var cancelAction = function(){
	clearLabel();
	$('#cancelBtn').unbind('click', cancelAction);
	$('#addBtn').unbind('click', addAction);
	
	$('#paxes tr[id="pax-new"]').remove();
	$('#newPaxBtn').prop('disabled', false);
};

var cancelUpdateAction = function(){
	clearLabel();
	$('#cancelUpdateBtn').unbind('click', cancelUpdateAction);
	$('#updateBtn').unbind('click', updateAction);
	
	id = $('#pax-update').data('id');
	$('#pax-' + id).removeClass('invis');
	
	$('#paxes tr[id="pax-update"]').remove();
};

var updateCurrentImg = function(new_id){
	var old_id = $('tr img[alt="true"]').parent().parent().attr('id');
	if(new_id != old_id){
		$('#' + old_id + ' img').attr('src', false_src).attr('alt', 'false');
		$('#' + new_id + ' img').attr('src', true_src).attr('alt', 'true');
	}
};

var addAction = function(){
	clearLabel();
	//add pax on click
	data = {
		name: $('#name').val(),
		location: $('#location').val(),
		start: $('#start').val(),
		end: $('#end').val()
	};
	$.ajax({
		url : '/pax/create',
		data : data,
		dataType : 'json',
		type : 'POST',
		success : function(data) {
			$('#paxes input[type="text"]').removeClass('error');
			if(data.success){
				//run cancelAction
				cancelAction();
				//add row with pax data
				var row = $('<tr id="pax-' + data.info.id + '">');
				var cols = '';
		
				cols += '<td data-id="' + data.info.id + '" data-name="' + data.info.name + '" >' + data.info.name + '</td>';
				cols += '<td data-id="' + data.info.id + '" data-location="' + data.info.location + '" >' + data.info.location + '</td>';
				cols += '<td data-id="' + data.info.id + '" data-start="' + data.info.start + '" >' + data.info.start + '</td>';
				cols += '<td data-id="' + data.info.id + '" data-end="' + data.info.end + '" >' + data.info.end + '</td>';
				cols += '<td><img alt="' + data.info.current + '" src="' + (data.info.current ? '/assets/check.png' : '/assets/x.png') + '" /></td>';
				cols += '<td><input data-id="' + data.info.id + '" type="submit" class="setCurrentBtn" value="Set Current" /></td>';
				cols += '<td><input data-id="' + data.info.id + '" type="submit" class="editBtn" value="Edit" /></td>';
				cols += '<td><a href="/metrics?id=' + data.info.id + '">Show Metrics</a></td>';
		
				row.append(cols);
				$('#paxes').append(row);
				
				$('.editBtn').unbind('click', editAction);
				$('.editBtn').click(editAction);
				
				$('.setCurrentBtn').unbind('click', setCurrentAction);
				$('.setCurrentBtn').click(setCurrentAction);
				
				updateCurrentImg('pax-' + data.info.id);
			}else{
				//highlight missing fields
				data.missing.forEach(function(e){
					$('#' + e).addClass('error');
				});
			}
			$('#p_label').text(data.message);
		}
	});
};

var updateAction = function(){
	clearLabel();
	//update pax on click
	id = $('#pax-update').data('id');
	data = {
		id: id,
		name: $('#name-' + id).val(),
		location: $('#location-' + id).val(),
		start: $('#start-' + id).val(),
		end: $('#end-' + id).val()
	};
	$.ajax({
		url : '/pax/update',
		data : data,
		dataType : 'json',
		type : 'POST',
		success : function(data) {
			$('#paxes input[type="text"]').removeClass('error');
			if(data.success){
				//update values in hidden row
				old_val = $('#pax-' + id + ' > td[data-id="' + id + '"]').map(function() { return $(this); });
				old_val[0].data('name', data.name).text(data.name);
				old_val[1].data('location', data.location).text(data.location);
				old_val[2].data('start', data.start).text(data.start);
				old_val[3].data('end', data.end).text(data.end);
				//run cancelUpdateAction
				cancelUpdateAction();
			}else{
				//highlight missing fields
				data.missing.forEach(function(e){
					$('#' + e + '-' + id).addClass('error');
				});
			}
			//display message
			$('#p_label').text(data.message);
		}
	});
};

var clearLabel = function(){
	$('#p_label').text('');
};

var setCurrentAction = function(e){
	id = e.currentTarget.dataset['id'];
	//set scrolling gif active
	
	$.ajax({
		url : '/pax/current',
		data : {
			id: id
		},
		dataType : 'json',
		type : 'POST',
		success : function(data) {
			if(data.success){
				new_id = 'pax-' + id;
				updateCurrentImg(new_id);
			}else{
				$('#p_label').text(data.message);
			}
		}
	});
};

var editAction = function(e){
	cancelAction();
	//add in call for cancelUpdate method
	cancelUpdateAction();
	id = e.currentTarget.dataset['id'];
	//hide active row with id
	$('#pax-' + id).addClass('invis');
	//get current values
	vals = $('#pax-' + id + ' > td[data-id="' + id + '"]').map(function() { return $(this); });
	//add row with inputs and update button
	var row = $('<tr data-id="' + id + '" id="pax-update">');
	var cols = '';

	cols += '<td><input type="text" value="' + vals[0].data('name') + '" placeHolder="PAX Name" id="name-' + id + '" /></td>';
	cols += '<td><input type="text" value="' + vals[1].data('location') + '" placeHolder="Location" id="location-' + id + '" /></td>';
	cols += '<td><input type="text" value="' + vals[2].data('start') + '" placeHolder="Start Date {yyyy-mm-dd}" id="start-' + id + '" /></td>';
	cols += '<td><input type="text" value="' + vals[3].data('end') + '" placeHolder="End Date {yyyy-mm-dd}" id="end-' + id + '" /></td>';
	cols += '<td><input type="button" value="Update" id="updateBtn" /></td>';
	cols += '<td><input type="button" value="Cancel" id="cancelUpdateBtn" /></td>';

	row.append(cols);
	$('#pax-' + id).after(row);
	//add click listener for update/cancel button
	$('#updateBtn').click(updateAction);
	$('#cancelUpdateBtn').click(cancelUpdateAction);
};

$(document).ready(function() {

	$('.editBtn').click(editAction);
	$('#editBtn').click(clearLabel);

	$('.setCurrentBtn').click(setCurrentAction);
	$('.setCurrentBtn').click(clearLabel);
	
	$('#newPaxBtn').click(function(){
		cancelUpdateAction();
		//add row of inputs to #paxes table
		var row = $('<tr id="pax-new">');
		var cols = '';

		cols += '<td><input type="text" placeHolder="PAX Name" id="name" /></td>';
		cols += '<td><input type="text" placeHolder="Location" id="location" /></td>';
		cols += '<td><input type="text" placeHolder="Start Date {yyyy-mm-dd}" id="start" /></td>';
		cols += '<td><input type="text" placeHolder="End Date {yyyy-mm-dd}" id="end" /></td>';
		cols += '<td><input type="button" value="Add" id="addBtn" /></td>';
		cols += '<td><input type="button" value="Cancel" id="cancelBtn" /></td>';

		row.append(cols);
		$('#paxes').append(row);
		//add cancel event listener
		$('#cancelBtn').click(cancelAction);
		$('#addBtn').click(addAction);
		//disable #newPaxBtn
		$('#newPaxBtn').prop('disabled', true);
	});
	$('#newPaxBtn').click(clearLabel);
	
	
});