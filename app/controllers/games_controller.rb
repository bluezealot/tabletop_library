class GamesController < ApplicationController
    before_filter :reset_session, :only => [:index, :new, :show]
    before_filter :get_section, :only => [:index]
    before_filter :select_sections, :only => [:index, :new, :info_get]
    before_filter :signed_in_user, only: [:new, :remove]

    def index
        if @section
            @games = @section.games.where({:returned => false})
        else
            @games = Game.where({:returned => false})
        end
    end

    def show
        @game = Game.find(params[:id])
    end

    def new
    end

    def create
        bc = params[:g_id].upcase
        
        if bc.empty? || !/[a-z]{3}\d{4}[a-z0-9]{2}/i.match(bc)
            redirect_to new_game_path(params), notice:'Invalid barcode.'
        else
            game = get_game(bc)
            if game && game.returned == false
                redirect_to new_game_path(params), notice: 'Game barcode already exists in the system.'
            else
                session[:g_id] = bc
                redirect_to games_info_path
            end
        end
    end
    
    def info_get
    end
    
    def info_post
        t_id = get_title_id(params[:title], params[:publisher])
        g_id = session[:g_id]
        @game = get_game(g_id)
        
        if @game && @game.returned == true
            @game.update_attributes({
                :title_id => t_id, 
                #:barcode => g_id, 
                :section_id => params[:section_id],
                :returned => false,
                :checked_in => true #just in case!
                })
        else
            @game = Game.new({
                :title_id => t_id, 
                :barcode => g_id, 
                :section_id => params[:section_id]
                })
        end
        
        if @game.save
            if session[:redirect] == 'checkout'
                redirect_to checkouts_attendee_path
                
            else
                session[:g_id] = nil;
                redirect_to @game, notice: 'Game was successfully added.'
            end
        else
            redirect_to games_info_path(params)
        end
    end
    
    def remove
        g_id = params[:g_id]
        if g_id
            if get_game(g_id)
                if game_has_unclosed_co(g_id)
                    redirect_to games_remove_path, notice: 'Game is still checked out. Please return the game first.'
                else
                    Game.find(g_id).update_attributes({
                        :returned => true
                    })
                    redirect_to games_remove_path, notice: 'Game removed from the library.'
                end
            else
                redirect_to games_remove_path, notice: 'Game does not exist.'
            end
        end
    end

=begin
    # DELETE /games/1
    # DELETE /games/1.json
    def destroy
        if game_has_unclosed_co(params[:id])
            redirect_to games_url, notice: 'Game is still checked out. Please return the game first.'
        else
            @game = Game.find(params[:id])
            @game.destroy
            redirect_to games_url
        end
    end
=end

    private
        
        def get_title_id(title, publisher)
            if Title.where(:title => title).empty?
                #create new title
                @pub_id = get_publisher_id(publisher)
                Title.create({:title => title, :publisher_id => @pub_id}).id
            else
                #get title id
                Title.where(:title => title).first.id
            end
        end
        
        def get_publisher_id(publisher)
            if Publisher.where(:name => publisher).empty?
                #create publisher
                Publisher.create({:name => publisher}).id
            else
                #get publisher
                Publisher.where(:name => publisher).first.id
            end        
        end
        
        def get_section
            if params[:section_id] && !params[:section_id].empty?
                @section = Section.find(params[:section_id])
            end
        end

        def select_sections
            @sections = Section.all.collect {|s| [s.name, s.id]}
        end
        
end
