class CheckoutsController < ApplicationController

  def index
    @checkouts = Checkout.where(:closed => false, :pax_id => get_current_pax.id)
  end

  def create
    a_id = params[:a_id].upcase
    g_id = params[:g_id].upcase
    
    game = get_active_game(g_id)
    begin
      unless game
        raise 'Game does not exist or is not ACTIVE!'
      end
      if game_has_unclosed_co(game.id)
        raise "Game is already checked out!"
      end
      
      if params[:swap].to_bool
        json = swap(a_id, g_id)
      else
        json = checkout_game(a_id, g_id)
      end
    rescue Exception => e
      json = {
        message: e.message,
        success: false
      }
    end
    
    render json: json
  end

  def return
    a_id = params[:a_id].upcase
    g_id = params[:g_id].upcase

    return_game(a_id, g_id)
    render json: { success: true }
  end
  
  private
  def checkout_game(a_id, g_id)
    a_id.upcase!
    g_id.upcase!

    pax = get_current_pax
    game = get_game(g_id)
    atte = Attendee.where(barcode: a_id, pax_id: pax.id).first

    checkout = Checkout.new({
        :check_out_time => Time.new,
        :pax_id => pax.id,
        :game_id => game.id,
        :attendee_id => atte.id
      })
    success = checkout.save
    
    if success
      game.update_attributes({
        :checked_in => false
      })
    end
    
    return {
      success: success,
      message: success ? 'Checkout complete.' : 'An error occurred during checkout. Please contact your Admin.'
    }
  end
  
  def swap(a_id, g_id)
    unless get_open_count_for_atte(a_id) != 1
      old_g = get_checked_out_game_for(a_id)
      
      return_game(a_id, old_g)
      json = checkout_game(a_id, g_id)
      
      json[:message] = 'Games swapped successfully.'
      
      return json
    end
  end
    
  def get_checked_out_game_for(a_id)
    c = Checkout.where(
      attendee_id: a_id.upcase,
      closed: false,
      pax_id: get_current_pax.id
      ).first
    c.game_id
  end
  
end
