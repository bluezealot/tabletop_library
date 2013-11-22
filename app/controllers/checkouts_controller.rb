class CheckoutsController < ApplicationController

  def index
    @checkouts = Checkout.where(:closed => false, :pax_id => get_current_pax.id)
  end

  def create
    a_id = params['a_id'].upcase
    g_id = params['g_id'].upcase
    
    checkout_game(a_id, g_id)
    render json: { success: true }
  end

  def swap
    a_id = params[:a_id].upcase
    g_id = params[:g_id].upcase
    
    unless get_open_count_for_atte(a_id) != 1
      old_g = get_checked_out_game_for(a_id)
      
      return_game(a_id, old_g)
      checkout_game(a_id, g_id)
      render json: { success: true }
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
