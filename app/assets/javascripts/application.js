// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

var enableCheckoutButton = function() {
  $("#checkout_btn").prop("disabled", !v_g || !v_a);
  $("#swap_btn")	.prop("disabled", !v_g || !v_a);
};

var resetCheckout = function(){
  $("#attendee_label").text('');
  $("#game_label").text('');
  $("#a_id").val('');
  $("#g_id").val('');
  v_a = false;
  v_g = false;
};

var bc_regex = /^[a-z]{3}[a-z0-9]{3,6}$/i;
var v_a = false;
var v_g = false;

$(document).ready(function() {
  
  $("#g_id").change(function(e) {
    if (bc_regex.test(this.value)) {
      $.ajax({
        url: "/is_valid_game"
        ,data: {
          g_id: this.value
        }
        ,dataType: "json"
        ,complete: enableCheckoutButton
        ,success: function(data) {
          $("#game_label").text(data.message);
          v_g = data.valid;
        }
      });
    }
  });
  
  $("#a_id").change(function(e) {
    if (bc_regex.test(this.value)) {
      $.ajax({
        url: "/is_valid_attendee"
        ,data: {
          a_id: this.value
        }
        ,dataType: "json"
		,complete: enableCheckoutButton
        ,success: function(data) {
          $("#attendee_label").text(data.message);
          v_a = data.valid;
          $('#swap_btn').toggleClass('invis', !data.coCount == 1);
        }
      });
    }
  });
  
  $('#checkout_btn').click(function(){
  	data = $('input[type="text"]').serializeArray();
  	$.ajax({
  		url:'/checkouts/create'
  		,data: data
  		,dataType:'json'
  		,type: 'POST'
  		,complete: enableCheckoutButton
  		,success:function(data){
  			if(data.success){
  				resetCheckout();
  				//TODO: display success message
  			}
  		}
  	});
  });
  
  $('#swap_btn').click(function(){
  	data = $('input[type="text"]').serializeArray();
  	data.swap = true;
  	$.ajax({
  		url:'/checkouts/swap'
  		,data: data
  		,dataType:'json'
  		,type: 'POST'
  		,complete: enableCheckoutButton
  		,success:function(data){
  			if(data.success){
  				resetCheckout();
  				//TODO: display success message
  			}
  		}
  	});
  });
  
});
