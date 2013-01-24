class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
    
    def checkout_game(a_id, g_id)
        a_id.upcase!
        g_id.upcase!
        
        Game.find(g_id).update_attributes({
            :checked_in => false
            })
        pax = get_current_pax
            
        @checkout = Checkout.new({
                    :check_out_time => Time.new,
                    :pax_id => pax.id,
                    :game_id => g_id,
                    :attendee_id => a_id
                    })
        
        if @checkout.save
            reset_session
            redirect_to new_checkout_path, notice: 'Game was successfully checked out.'
        else
            redirect_to new_checkout_path, notice: 'An error has occurred during checkout.<br/>Error code: 0HB4LL5'
        end
        
    end
    
    def return_game(a_id, g_id)
        pax = get_current_pax
        @co = Checkout.where({:attendee_id => a_id, :game_id => g_id, :closed => false, :pax_id => pax.id}).first
        @game = get_game(g_id)
        
        if @co && @game
            @co.update_attributes({
                :return_time => Time.new,
                :closed => true
                })
                
            @game.update_attributes({
                :checked_in => true
                })
            true
        else
            false
        end
    end

    def get_game(id)
        Game.where(:barcode => id).first
    end
    
    def get_attendee(id)
        Attendee.where(:barcode => id).first
    end
    
    def game_has_unclosed_co(g_id)
        g_id = g_id.upcase
        pax = get_current_pax
        Checkout.where(:game_id => g_id, :closed => false, :pax_id => pax.id).first 
    end
    
    def atte_has_unclosed_co(a_id)
        a_id = a_id.upcase
        pax = get_current_pax
        Checkout.where(:attendee_id => a_id, :closed => false, :pax_id => pax.id)
    end
    
    def reset_session
        session[:g_id] = nil
        session[:a_id] = nil
        session[:redirect] = nil
    end
    
    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
  
end
