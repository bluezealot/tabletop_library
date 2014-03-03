class SessionsController < ApplicationController
    before_filter :signed_in_user, only: [:index]
    before_filter :select_sections, only: [:index]
    
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
        
        @top_games = Title.joins(games: :checkouts)
            .select('title, count(*) as total')
            .where('checkouts.pax_id' => @pax.id)
            .group('title')
            .order('count(*) desc')
            .limit(20)

        all_co = Checkout.where(:pax_id => @pax)
        closed_co = all_co.where(:closed => true)
        
        @shortest_checkout = closed_co.sort_by! { |a| a.play_time_min }.first
        @longest_checkout = closed_co.last
        @current_checkouts = closed_co.size
        @total_checkouts = all_co.size
    end
    
    def culls
      if params[:id]
        @pax = Pax.find(params[:id])
      else
        @pax = get_current_pax
      end
      
      #0 checkouts overall - with checks
      #less than 3 overall - with checks
      #less than 3 per copy
      
      @culls_none = {}
      @culls_perTitle = {}
      @culls_perCopy = {}
      Title.all.each do |t|
        gameCount = t.games.where(:section_id => 1).count
        if gameCount > 0
          x = Checkout.where(:game_id => Game.where(:title_id => t, :section_id => 1), :pax_id => @pax).count
          o = {checkouts:x, title:t.title, copies:gameCount }
          if x == 0
            @culls_none[t.title] = o
          elsif x < 3
            @culls_perTitle[t.title] = o
          elsif x/gameCount < 3
            @culls_perCopy[t.title] = o
          end
        end
      end
      
    end
    
end
