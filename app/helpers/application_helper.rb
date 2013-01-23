module ApplicationHelper

    def full_title(page_title)
        base = "PAX TT HQ"
        if page_title.empty?
            base
        else
            "#{base} - #{page_title}"
        end
    end
    
    def admin_name(user)
        base = ""
        if user.nil?
            base
        else
            "Logged in as: " + user.name
        end
    end
    
    def tab_class(tab)
        current = 'current'
        case tab
        when 'checkout'
            if controller.class == CheckoutsController || session[:redirect] == 'checkout'
                logger.debug controller.class
                current
            end
        when 'return'
            if controller.class == ReturnsController
                current
            end
        when 'newattendee'
            if controller.class == AttendeesController && controller.action_name != 'index' && session[:redirect] != 'checkout'
                current
            end
        when 'admin'
            if controller.class == SessionsController
                current
            end
        else
            
        end
    end
    
    def current_pax
        current_pax = Pax.where({:current => true}).first
        if current_pax
            current_pax.full_name
        else
            nil
        end
    end
    
end
