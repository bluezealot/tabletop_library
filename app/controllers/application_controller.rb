class ApplicationController < ActionController::Base
    protect_from_forgery
    include SessionsHelper
    include ApplicationHelper
    
    def return_game(a_id, g_id)
      a_id.upcase!
      g_id.upcase!
      
      pax = get_current_pax
      game = get_active_game(g_id)
      atte = Attendee.where(barcode: a_id, pax_id: pax.id).first
    
      co = Checkout.where(:attendee_id => atte.id, :game_id => game.id, :closed => false, :pax_id => pax.id).first
      
      if co && game
        co.update_attributes({
          :return_time => Time.new,
          :closed => true
        })
            
        game.update_attributes({
          :checked_in => true
        })
        true
      else
        false
      end
    end

    def get_game(g_id)
      Game.where(:barcode => g_id, culled: false).first
    end
    
    def get_active_game(g_id)
      Game.where(:barcode => g_id, culled: false, active: true).first
    end
    
    def game_has_unclosed_co(id)
      pax = get_current_pax
      Checkout.where(:game_id => id, :closed => false, :pax_id => pax.id).size > 0
    end
    
    def signed_in_user
      redirect_to signin_url, alert: "Please sign in." unless signed_in?
    end
    
    def capitalize_all(str)
      str.split.map(&:capitalize).join(' ')
    end
    
    def select_sections
      @sections = Section.all.collect {|s| [s.name, s.id]}
    end
    
    def general_status
      render json: {
        success: true,
        openCheckoutCount: Checkout.where(pax_id: get_current_pax, closed: false).size,
        activeGameCount: Game.where(active: true, culled: false).size
      }
    end
  
end
