class SessionsController < ApplicationController
    before_filter :signed_in_user, only: [:index]
    
    def index
        
    end
    
    def new
        
    end
    
    def create
        user = User.find_by_user_name(params[:session][:user_name])
        if user && user.authenticate(params[:session][:password])
            sign_in user
            redirect_to admin_path
        else
            flash[:alert] = 'Invalid user/pass combo.'
            redirect_to signin_path
        end
    end
    
    def destroy
        sign_out
        redirect_to root_url
    end
    
    def metrics
        if params[:id]
            @pax = Pax.find(params[:id])
        else
          @pax = get_current_pax
        end

        #Top Five, not done!!!!
        @top_five_per_game = {}
        Title.all.each do |t|
            x = Checkout.where(:game_id => Game.where(:title_id => t), :pax_id => @pax).count
            if x > 0
                @top_five_per_game[t.title] = x
            end
        end
        @top_five_per_game = @top_five_per_game.sort_by {|a,b| b}.reverse[0..4]
        
        checkouts = Checkout.where(:pax_id => @pax).sort_by!{|a| a.play_time_min}
        
        @shortest_checkout = checkouts.first
        @longest_checkout = checkouts.last#reverse.first
        @current_checkouts = Checkout.where(:closed => false).count
    end
    
end
