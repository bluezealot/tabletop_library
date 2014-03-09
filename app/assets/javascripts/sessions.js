$(document).ready(function() {
	$('#actGameBtn').click(function(){
		// fade out admin form
		$('#adminForm').fadeOut(250, function(){
			$('#actGameField').fadeIn(250);
			$('#a_g_id').focus();
		});
	});
	
	$('#newGameBtn').click(function(){
		// fade out admin form
		$('#adminForm').fadeOut(250, function(){
			$('#newGameField').fadeIn(250);
			$('#g_id').focus();
		});
	});
	
	$('#rmvGameBtn').click(function(){
		// fade out admin form
		$('#adminForm').fadeOut(250, function(){
			$('#rmvGameField').fadeIn(250);
			$('#r_g_id').focus();
		});
	});
	
	$('#cancelActBtn').click(function(){
		$('#g_label').text('');
		$('#actGameField').fadeOut(250, function(){
			$('#adminForm').fadeIn(250);
		});
	});
	
	$('#cancelNewBtn').click(function(){
		$('#g_label').text('');
		$('#newGameField').fadeOut(250, function(){
			$('#adminForm').fadeIn(250);
		});
	});
	
	$('#cancelRmvBtn').click(function(){
		$('#g_label').text('');
		$('#rmvGameField').fadeOut(250, function(){
			$('#adminForm').fadeIn(250);
		});
	});
	
	$('#g_id').change(function(){
		$('#g_label').text('');
		if (bc_regex.test(this.value)) {
			$.ajax({
				url : '/game_by_id',
				data : {
					id: this.value
				},
				dataType : 'json',
				type : 'GET',
				success : function(data) {
					if(data.valid){
						//set warning message
						$('#g_id').val('');
						var msg = '';
						msg += '<strong>Game already exists!</strong>';
						msg += '</br>';
						msg += '<br/>Barcode: ' + data.info.barcode;
						msg += '<br/>Title: ' + data.info.title;
						msg += '<br/>Publisher: ' + data.info.publisher;
						msg += '<br/>Section: ' + data.info.section;
						msg += '<br/>Active: ' + data.info.active;
						
						$('#g_label').html(msg);
						//$('x_game').toggleClass('invis', true);
					}else{
						//set other fields to visible
						$('#new_game').dialog('open');
					}
				}
			});
		}
	});
	
	$("#new_game").dialog({
		autoOpen : false,
		modal : true,
		resizable : true,
		buttons : {
			"Add Game" : function() {
				data = $('#new_game > input[type="text"], #new_game > select, #g_id').serializeArray();
				$.ajax({
					url : '/games/create',
					data : data,
					dataType : 'json',
					type : 'POST',
					success : function(data) {
						$('#new_game > input, #new_game > select').removeClass('error');
						if (data.success) {
							$("#new_game").dialog("close");
							$('#g_id').val('');
							$('#g_label').text('Game added successfully.');
						}else{
							data.missing.forEach(function(e){
								$('#' + e).addClass('error');
							});
						}
					}
				});
			},
			Cancel : function() {
				$("#new_game").dialog("close");
				$('#new_game > input[type="text"]').val('');
				$('#g_id').val('');
				$("#g_id").focus();
			}
		},
		close : function() {
			$("#new_game").dialog("close");
			$('#new_game > input[type="text"]').val('');
			$('#new_game > input[type="text"]').removeClass('error');
			$("#g_id").focus();
			
			$('#g_id').val('');
			$("#g_label").text('');
		}
	});
	
	$('#r_g_id').change(function(){
		$('#g_label').text('');
		if (bc_regex.test(this.value)) {
			$.ajax({
				url : '/games/cull',
				data : {
					id: this.value
				},
				dataType : 'json',
				type : 'POST',
				success : function(data) {
					if(data.success){
						$('#r_g_id').val('');
						$('#g_label').text('Game culled!');
					}else{
						$('#r_g_id').val('');
						$('#g_label').text(data.message);
					}
				}
			});
		}
	});
	
	$('#a_g_id').change(function(){
		$('#g_label').text('');
		if (bc_regex.test(this.value)) {
			$.ajax({
				url : '/games/activate',
				data : {
					id: this.value
				},
				dataType : 'json',
				type : 'POST',
				success : function(data) {
					$('#a_g_id').val('');
					if(data.success){
						var msg = '';
						
						if(data.already_active){
							msg += '<strong>Game is already ACTIVE!</strong>';
						}else{
							msg += '<strong>Game was activated successfully!</strong>';
						}
						
						msg += '</br>';
						msg += '<br/>Barcode: ' + data.info.barcode;
						msg += '<br/>Title: ' + data.info.title;
						msg += '<br/>Publisher: ' + data.info.publisher;
						msg += '<br/>Section: ' + data.info.section;
						
						$('#g_label').html(msg);
					}else{
						$('#g_label').text(data.message);
					}
				}
			});
		}
	});
	
	$('#a_g_id').focus(pTipIn);
	$('#a_g_id').blur(pTipOut);
	
	$('#actGameBtn').hover(pTipIn, pTipOut);
	$('#rmvGameBtn').hover(pTipIn, pTipOut);
	$('#newGameBtn').hover(pTipIn, pTipOut);
	
});