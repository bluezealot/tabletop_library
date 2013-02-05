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
        if !params[:id].nil?
            @pax = Pax.find(params[:id])
        end
        if @pax.nil?
            @pax = get_current_pax
        end
        #Top Five, not done!!!!
        @top_five_per_game = {}
        Title.all.each do |t|
            x = Checkout.where(:game_id => Game.where(:title_id => t), :pax_id => @pax).count
            @top_five_per_game[t.title] = x
        end
        @top_five_per_game = @top_five_per_game.sort_by {|a,b| b}.reverse[0..4]
        
        checkouts = Checkout.where(:pax_id => @pax).sort_by {|a| a.play_time_min}
        
        @shortest_checkout = checkouts.first
        @longest_checkout = checkouts.reverse.first
        @current_checkouts = Checkout.where(:closed => false).count
    end
    
=begin
    def fix_titles
        Game.all.each do |game|
            alt = Alternate.find(game.title_id)
            if !alt.nil?
                tit = Title.where(:title => alt.title).first
                if !tit.nil?
                    game.update_attributes(:title_id => tit.id)
                end
            end
        end
    end
=end

end
