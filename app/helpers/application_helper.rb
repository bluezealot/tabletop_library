module ApplicationHelper

    def full_title(page_title)
        base = "PAX TT HQ"
        if page_title.empty?
            base
        else
            "#{base} - #{page_title}"
        end
    end
    
    def admin_label(user)
        base = ""
        if user.nil?
            base
        else
            admin_name(user)
        end
    end
    
    def admin_name(user)
        if user.nil?
            nil
        else
            sign_out_link(user)
        end
    end
    
    def sign_out_link(user)
        if user.nil?
            nil
        else
            link_to user.name + ' - sign out', signout_path, method: "delete"
        end
    end
    
    def tab_class(tab)
        current = 'current'
        if controller.class == CheckoutsController || session[:redirect] == 'checkout'
            loc = 'checkout'
        #elsif controller.class == ReturnsController
        #    loc = 'return'
        elsif controller.class == GamesController && controller.action_name == 'index'
            loc = 'games'
        else
            loc = 'admin'
        end
        
        if loc == tab
            current
        end
    end
    
    def current_pax_label
        current_pax = get_current_pax
        if current_pax
            link_to current_pax.full_name, metrics_path(current_pax)
        else
            nil
        end
    end
    
    def get_current_pax
        pax = Pax.where({:current => true}).first
        if !pax
            Pax.find(:all, :order => 'start DESC').first
        else
            pax
        end
    end
    
    def bool_img(bool)
        if bool
            image_tag("check.png", alt: "true", title: bool)
        else
            image_tag("x.png", alt: "false")
        end
    end
    
    def progress_percent
        per = nil
        c = controller
        if (c.action_name == 'new' || c.action_name == 'create') && c.class != SessionsController
            if notice
                per = 100
            else
                per = 0
            end
        elsif c.class == CheckoutsController
            if c.action_name != 'index'
              if session[:a_id]
                  if session[:g_id]
                    per = 90
                  else
                    per = 50
                  end
              else
                  per = 0
              end
            end
        elsif c.class == AttendeesController && c.action_name == 'info_get'
            if session[:redirect] == 'checkout'
                per = 25
            else
                per = 50
            end
        elsif c.class == GamesController && c.action_name == 'info_get'
            if session[:redirect] == 'checkout'
                per = 75
            else
                per = 50
            end
        elsif c.class == ReturnsController && c.action_name == 'show'
            per = 50
        end
        per
    end
    
end
