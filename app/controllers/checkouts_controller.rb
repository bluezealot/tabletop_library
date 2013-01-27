class CheckoutsController < ApplicationController

    def index
        pax = get_current_pax
        @checkouts = Checkout.where(:closed => false, :pax_id => pax.id)
    end

    def show
        @checkout = Checkout.find(params[:id])
    end

    def new
        reset_session
    end

    def create
        a_id = params[:a_id].upcase
        session[:a_id] = a_id
        
        if barcode_check(a_id)
            if get_attendee(a_id)
                redirect_to checkouts_game_path
            else
                session[:redirect] = 'checkout'
                redirect_to attendees_info_path, notice: 'Attendee doesn\'t exist, please enter information.'
            end
        else
            flash.now[:error] = 'Invalid barcode.'
            render 'new'
        end

    end
  
    def game_get
    end
    
    def game_post
        g_id = params[:g_id].upcase
        
        if barcode_check(g_id)
            game = get_game(g_id)
            
            if game && !game.returned
                if game_has_unclosed_co(g_id)#fixme
                    redirect_to new_checkout_path, notice: 'Game is already checked out!'
                else
                    if (@current_checkouts = atte_has_unclosed_co(session[:a_id])).empty? || session[:redirect] == 'morethanone'
                        checkout_game(session[:a_id], g_id)
                    else
                        #redirect_to new_checkout_path, notice: 'Attendee already has a game checked out!'
                        session[:redirect] = 'morethanone'
                        render 'already'
                    end
                end
            else
                session[:redirect] = 'checkout'
                session[:g_id] = g_id
                redirect_to games_info_path, notice: 'Game doesn\'t exist, please enter information.'
            end
        else
            flash.now[:error] = 'Invalid barcode.'
            render 'game_get'
        end
        
    end
    
    def swap
        if return_game(session[:a_id], params[:old_g_id])
            checkout_game(session[:a_id], params[:g_id])
        else
            redirect_to new_checkout_path, notice: 'Error occurred while swapping!'
        end
    end

end
