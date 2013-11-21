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
  $("#checkout_btn").prop("disabled", !$("#v_a").val() || !$("#v_g").val());
};

var resetCheckout = function(){
	$("#game_label").text('');
    $("#attendee_label").text('');
    $("#v_g").val('').trigger("change");
    $("#v_a").val('').trigger("change");
};

var bc_regex = /^[a-z]{3}[a-z0-9]{3,6}$/i;

$(document).ready(function() {
  $("#v_g").change(enableCheckoutButton);
  $("#v_a").change(enableCheckoutButton);
  
  $("#g_id").change(function(e) {
    if (bc_regex.test(this.value)) {
      $.ajax({
        url: "/is_valid_game",
        data: {
          g_id: this.value
        },
        dataType: "json",
        success: function(data) {
          $("#game_label").text(data.message);
          $("#v_g").val(data.valid).trigger("change");
        }
      });
    }
  });
  
  $("#a_id").change(function(e) {
    if (bc_regex.test(this.value)) {
      $.ajax({
        url: "/is_valid_attendee",
        data: {
          a_id: this.value
        },
        dataType: "json",
        success: function(data) {
          $("#attendee_label").text(data.message);
          $("#v_a").val(data.valid).trigger("change");
          //TODO: add swap button to view, enable based on has_checkouts
        }
      });
    }
  });
  
  $('#checkout_btn').click(function(){
  	data = $('input[type="text"]');
  	$.ajax({
  		url:'/checkouts/create'
  		,data: data.serializeArray()
  		,dataType:'json'
  		,type: 'POST'
  		,success:function(data){
  			if(data.sucess){
  				resetCheckout();
  			}
  		}
  	});
  });
  
});
