class CheckoutsController < ApplicationController

    def index
        @checkouts = Checkout.where(:closed => false, :pax_id => get_current_pax.id)
    end

    def create
      a_id = params['a_id'].upcase
      g_id = params['g_id'].upcase
      
      unless game_has_unclosed_co(g_id)
        checkout_game(a_id, g_id)
        render json: { success: true }
      else
        #should never get to this point
      end
    end

    def swap
      a_id = params[:a_id].upcase
      g_id = params[:g_id].upcase
      oldg = params[:oldg].upcase

      return_game(a_id, oldg)
      checkout_game(a_id, g_id)
    end

end
