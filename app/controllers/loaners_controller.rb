class LoanersController < ApplicationController
    before_filter :signed_in_user#, only: [:new, :remove]
    before_filter :reset_session, :only => [:index, :new, :show]
    
    def index
        @loaners = Loaner.all
    end

    def new
        @loaner = Loaner.new
    end

    def create
        @loaner = Loaner.new(params[:loaner])
        
        if @loaner.save
            flash[:notice] = 'Loaner was successfully created.'
            redirect_to loaners_path
        else
            render action: "new"
        end
    end
    
    def edit
        @loaner = Loaner.find(params[:id])
    end

    def update
        @loaner = Loaner.find(params[:id])

        if @loaner.update_attributes(params[:loaner])
            flash[:notice] = 'Loaner was successfully updated.'
            redirect_to @loaner
        else
            render action: "edit"
        end
    end
    
    def add_game
        session[:l_id] = params[:id]
        #redirect_to new_game_path
        render './games/new'
    end

    def destroy
        @loaner = Loaner.find(params[:id])
        
        all_checked_in = true
        @loaner.games.each do |game|
            if !game.checked_in
                all_checked_in = false
            end
        end
        
        if all_checked_in
            @loaner.games.each do |game|
                remove_game(game.barcode)
            end
            name = @loaner.name
            #if @loaner.games.count <= 0
            #    @loaner.destroy
            #end
            flash[:notice] = 'All games returned to: ' + name
            redirect_to loaners_path
        else
            flash[:alert] = 'Some games are still checked out. Please check all games in before returning them.'
            redirect_to @loaner
        end        
    end

end
