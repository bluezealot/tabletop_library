(function($){
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
        $('div[data-target="' + id + '"]').remove();
    };

    $.fn.pTip = function(){
        return this.each(function(k, o){
            var o = $(o),
                actions = $(o).data('actions');
            if(!actions || actions.length <= 0){
                actions = ['hover'];
            }
            for(var i = 0; i < actions.length; i++){
                switch(actions[i]){
                    case 'hover':
                        console.log('Applying hover', o);
                        o.hover(pTipIn, pTipOut);
                        break;
                    case 'focus':
                        console.log('Applying focus', o);
                        o.focus(pTipIn);
                        o.blur(pTipOut);
                        break;
                    default:
                        break;
                }
            }
        });
    };
}(jQuery));