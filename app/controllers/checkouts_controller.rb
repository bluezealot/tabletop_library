class CheckoutsController < ApplicationController

    def index
        @checkouts = Checkout.where(:closed => false)
    end

    def show
        @checkout = Checkout.find(params[:id])
    end

    def new
        reset_session
    end

    def create
        g_id = params[:g_id].upcase
        game = get_game(g_id)
        
        if game && game.returned == false
            if game_has_unclosed_co(g_id)#fixme
                redirect_to new_checkout_path, notice: 'Game is already checked out!'
            else
                session[:g_id] = g_id
                redirect_to checkouts_attendee_path
            end
        else
            session[:redirect] = 'checkout'
            session[:g_id] = g_id
            redirect_to games_info_path, notice: 'Game doesn\'t exist, please enter information.'
        end

    end
    
    def atte_entr
        #if this second calling of get_game causes perf issues, store game record in session
        @game = get_game(session[:g_id])
    end
    
    def attendee
        a_id = params[:a_id].upcase
                
        if get_attendee(a_id)
            if (@current_checkouts = atte_has_unclosed_co(a_id)).empty? || session[:redirect] == 'morethanone'
                checkout_game(a_id, session[:g_id])
            else
                #redirect_to new_checkout_path, notice: 'Attendee already has a game checked out!'
                @game = get_game(session[:g_id])
                session[:redirect] = 'morethanone'
                render 'already'
            end
        else
            session[:redirect] = 'checkout'
            session[:a_id] = a_id
            redirect_to attendees_info_path, notice: 'Attendee doesn\'t exist, please enter information.'
        end
        
    end
    
    def swap
        if return_game(params[:a_id], params[:old_g_id])
            checkout_game(params[:a_id], session[:g_id])
        else
            redirect_to new_checkout_path, notice: 'Error occurred while swapping!'
        end
    end

end
