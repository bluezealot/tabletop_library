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
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap-switch

var bc_regex = /^[a-z]{3}[a-z0-9]{3,6}$/i;

//$(document).tooltip();

var pTipIn = function(e){
	var text = $(e.currentTarget).data('title');
	if(text && !$(e.currentTarget).prop('readOnly')){
		var pos = $(e.currentTarget).position();
		pos.left += $(e.currentTarget)[0].offsetWidth + 10;
		
		var tip = '<div class="ptip" style="top:' + pos.top +'px;left:' + pos.left + 'px;display:none;" data-target="' + $(e.currentTarget).attr('id') + '">' + text + '</div>';
		$('body').append(tip);
		$('.ptip').fadeIn(300);
	}
};

var pTipOut = function(e){
	var id = $(e.currentTarget).attr('id');
	$('div[data-target="' + id + '"]').fadeOut('150');
	$('div[data-target="' + id + '"]').remove();
};