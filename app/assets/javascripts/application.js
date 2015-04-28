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
//= require bootstrap
//= require bootstrap-switch
//= require pTipping

var bc_regex = /^[a-z]{3}[a-z0-9]{3,6}$/i;

var getStatus = function(){
    $.ajax({
        url : "/status",
        dataType : "json",
        success : function(data) {
            if (data.success) {
                $('#openCheckoutCount').text(data.openCheckoutCount);
                $('#activeGameCount').text(data.activeGameCount);
            }
            setTimeout(getStatus, 2500);
        }
    });
};

$(document).ready(function(){
    setTimeout(getStatus, 2500);
    $('[data-title]').pTip();
});