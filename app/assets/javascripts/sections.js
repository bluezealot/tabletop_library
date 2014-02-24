var cancelAction = function(){
	$('#sectionNew').remove();
	$('#newBtn').prop('disabled', false);
};

var cancelUpdateAction = function(){
	var id = $('#sectionUpdate').data('id');
	$('#sectionUpdate').remove();
	$('#section-' + id).removeClass('invis');
};
	
$(document).ready(function() {
	
	$('#sections').on('click', '#addBtn', function(){
		$.ajax({
			url : '/sections/create',
			data : {
				name: $('#name').val()
			},
			dataType : 'json',
			type : 'POST',
			success : function(data) {
				$('#name').removeClass('error');
				if(data.success){
					cancelAction();
					
					var row = '';
					row += '<tr id="section-' + data.section.id + '">';
					row += '<td>' + data.section.name + '</td>';
					row += '<td>Games: 0</td>';
					row += '<td><button class="btn btn-default edit-btn" data-id="' + data.section.id + '" name="button" type="submit">Edit</button></td>';
					row += '</tr>';
					
					$('#sections').append(row);
				}else{
					$('#name').addClass('error');
				}
			}
		});
	});
	
	$('#sections').on('click', '#cancelBtn', cancelAction);
	$('#sections').on('click', '#cancelUpdateBtn', cancelUpdateAction);

	$('#newBtn').click(function(e){
		cancelUpdateAction();
		
		$('#newBtn').prop('disabled', true);
		
		var row = '';
		row += '<tr id="sectionNew">';
		row += '<td><input type="text" id="name"/></td>';
		row += '<td><button id="addBtn" class="btn btn-default form-button">Add</button></td>';
		row += '<td><button id="cancelBtn" class="btn btn-default form-button">Cancel</button></td>';
		row += '</tr>';
		
		$('#sections').append(row);
	});
	
	$('#sections').on('click', '.edit-btn', function(e){
		cancelAction();
		cancelUpdateAction();
		
		var id = $(e.currentTarget).data('id');
		
		$('#section-' + id).addClass('invis');
		
		var row = '';
		row += '<tr id="sectionUpdate" data-id="' + id + '">';
		row += '<td><input type="text" id="editName" value="' + $('#section-' + id).children().first().text() + '"/></td>';
		row += '<td><button id="updateBtn" class="btn btn-default form-button">Update</button></td>';
		row += '<td><button id="cancelUpdateBtn" class="btn btn-default form-button">Cancel</button></td>';
		row += '</tr>';
		
		$('#section-' + id).after(row);
	});
	
	$('#sections').on('click', '#updateBtn', function(e){
		var id = $(e.currentTarget).parent().parent().data('id');
		
		$.ajax({
			url : '/sections/update',
			data : {
				name: $('#editName').val(),
				id: id
			},
			dataType : 'json',
			type : 'PUT',
			success : function(data) {
				$('#editName').removeClass('error');
				if(data.success){
					$('#section-' + data.section.id).children().first().text(data.section.name);
					cancelUpdateAction();
				}else{
					$('#editName').addClass('error');
				}
			}
		});
	});
	
});