class GamesController < ApplicationController
    before_filter :reset_session, :only => [:index, :new, :show]
    #before_filter :get_section, :only => [:index]
    before_filter :select_sections, :only => [:index, :new, :info_get, :info_post]
    before_filter :signed_in_user, only: [:new, :remove]

    def index
        @games = []
        search = {:returned => false}
        barcode =       params[:barcode]
        title =         params[:title]
        section =       params[:section_id]
        if params[:commit]
            if !barcode.empty?
                search[:barcode] = barcode
            end
            if !title.empty?
                search[:title_id] = Title.where("lower(title) like lower(?)", '%' + title + '%' )
            end            
            if !section.empty?
                search[:section_id] = section
            end
            @games = Game.where(search).order('title_id ASC')
        end        
    end

    def show
        @game = Game.find(params[:id])
    end

    def new
    end

    def create
        bc = params[:g_id].upcase
        
        if bc.empty? || !barcode_check(bc)
            redirect_to new_game_path(params), notice:'Invalid barcode.'
        else
            game = get_game(bc)
            if game && game.returned == false
                flash[:error] = 'Game barcode already exists in the system.'
                render 'new'
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
        if !session[:l_id].nil? && !session[:l_id].empty?
            l_id = session[:l_id]
        else
            l_id = nil
        end
        @game = get_game(g_id)
        
        if @game && @game.returned == true
            @game.update_attributes({
                :title_id => t_id, 
                #:barcode => g_id, 
                :section_id => params[:section_id],
                :returned => false,
                :checked_in => true, #just in case!
                :loaner_id => l_id
                })
        else
            @game = Game.new({
                :title_id => t_id, 
                :barcode => g_id, 
                :section_id => params[:section_id],
                :loaner_id => l_id
                })
        end
        
        if @game.save
            if session[:redirect] == 'checkout'
                session[:redirect] = nil
                checkout_game(session[:a_id], session[:g_id])
            elsif !session[:l_id].nil?
                #redirect to new?
                flash[:error] ='Game was successfully added to loaner.'
                render 'new'
            else
                session[:g_id] = nil;
                redirect_to @game, notice: 'Game was successfully added.'
            end
        else
            flash[:error] = 'Please fill in all fields.'
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
                    game = Game.find(g_id)
                    if game.loaner.nil?
                        remove_game(g_id)
                        redirect_to games_remove_path, notice: 'Game removed from the library.'
                    else
                        redirect_to games_remove_path, notice: 'This game is donated and can\'t be removed this way. Please remove it via the "loaners" function.'
                    end
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
