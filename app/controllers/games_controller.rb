class GamesController < ApplicationController
    before_filter :select_sections, :only => [:index, :new, :info_get, :info_post]
    before_filter :signed_in_user, only: [:new, :remove]

    def index
      @games = []
      
      search = {:returned => false}
      search[:barcode]    = params[:g_id]       unless params[:g_id].blank?
      search[:section_id] = params[:section_id] unless params[:section_id].blank?
      search[:title_id]   = Title.where("lower(title) like lower(?)", '%' + params[:title] + '%') unless params[:title].blank?
      
      #@games = Game.where(search).order('title_id ASC')
      @games = Game.where(search).order('title_id ASC').paginate(:page => params[:page], :per_page => 10)
    end

    def new
    end

    def create
      g_id = params[:g_id].upcase
      t_id = get_title_id(params[:title], params[:publisher])

      game = get_game(g_id)
      success = false
      message = ''
      missing_fields = []
      already_exists = false
      
      params.each do |k, v|
        if v.nil? || v.empty?
          missing_fields << k
        end
      end

      if game
        if game.returned == false
          message = 'Game barcode already exists in the system.'
          already_exists = true
        elsif game.returned == true
          game.update_attributes({
            :title_id => t_id, 
            :section_id => params[:section_id],
            :returned => false,
            :checked_in => true#,
            #:loaner_id => l_id
            })
            success = true
        end
      else
        game = Game.new({
          :title_id => t_id, 
          :barcode => g_id, 
          :section_id => params[:section_id]#,
          #:loaner_id => l_id
          })
        success = game.save
      end
      
      render json: {
        success: success,
        message: success ? 'Game successfully added.' : message,
        missing: missing_fields,
        exists: already_exists
      }
    end

    def remove
      g_id = params[:g_id]
      if g_id
        if get_game(g_id)
          if game_has_unclosed_co(g_id)
            flash[:alert] = 'Game is still checked out. Please return the game first.'
            redirect_to games_remove_path
          else
            game = Game.find(g_id)
            if game.loaner.nil?
              remove_game(g_id)
              flash[:notice] = 'Game removed from the library.'
              redirect_to games_remove_path
            else
              flash[:alert] = 'This game is donated and can\'t be removed this way. Please remove it via the "loaners" function.'
              redirect_to games_remove_path
            end
          end
        else
          flash[:alert] = 'Game does not exist.'
          redirect_to games_remove_path
        end
      end
    end

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
