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
            redirect_to signin_path, notice: 'Invalid user/pass combo.'
        end
    end
    
    def destroy
        sign_out
        redirect_to root_url
    end
    
    def metrics
        #Top Five, not done!!!!
        @topFive = {}
        pax = get_current_pax
        Title.all.each do |t|
            x = Checkout.where(:game_id => Game.where(:title_id => t), :pax_id => pax).count
            @topFive[t.title] = x
        end
        @topFive = @topFive.sort_by {|a,b| b}.reverse
        
        #Longest Checkout!
        @longest_checkout = Checkout.all.sort_by {|a| a.play_time_min}.reverse.first
    end
    
end
