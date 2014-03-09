class GamesController < ApplicationController
    before_filter :select_sections, only: [:index, :new]
    before_filter :signed_in_user, only: [:new, :remove]

    def index
      @games = []
      
      search = { :culled => false }
      search[:barcode]    = params[:g_id]       unless params[:g_id].blank?
      search[:section_id] = params[:section_id] unless params[:section_id].blank?
      unless params[:title].blank?
        if params[:title].size == 1
          search[:title_id]   = Title.where("lower(title) like lower(? || '%')", params[:title])
        else
          search[:title_id]   = Title.where("lower(title) like lower('%' || ? || '%')", params[:title])
        end
      end
      
      @games = Game.where(search).order('title_id, section_id ASC').paginate(:page => params[:page], :per_page => 10)
    end

    def update_section
      game = Game.find(params[:id])
      
      success = false
      
      if game && params[:section_id]
        game.update_attributes({
          section_id: params[:section_id]
        })
        success = true
      end
      
      render json: {
        success: success,
        id: game.id
      }
    end

    def create
      g_id = params[:g_id].upcase
      t_id = get_title_id(params[:title], params[:publisher])

      game = get_game(g_id)
      success = false
      message = ''
      missing_fields = []
      
      params.each do |k, v|
        if v.nil? || v.empty?
          missing_fields << k
        end
      end
      
      if missing_fields.empty?
        if game
          if game.active?
            message = 'Game already exists and is ACTIVE in the system.'
          else
            message = 'Game already exists, but is not ACTIVE in the system.'
          end
        else
          new_game = Game.new({
            :barcode => g_id,
            :title_id => t_id, 
            :section_id => params[:section_id],
            :checked_in => true,
            :culled => false,
            :active => true
          })
          success = new_game.save
        end
      end

      render json: {
        success: success,
        message: success ? 'Game successfully added and set to ACTIVE.' : message,
        missing: missing_fields
      }
    end

    def cull
      g_id = params[:id].upcase
      game = get_game(g_id)
      
      message = ''
      success = false
      
      if game
        unless game_has_unclosed_co(g_id)
          game.update_attributes({
            culled: true,
            active: false
          })
          success = true
        else
          message = 'Game can not be culled until it is checked in.'
        end
      else
        message = 'Game is not in the system currently.'
      end
      
      render json: {
        success: success,
        message: message
      }
    end
    
    def get_game_by_id
      game = get_game(params[:id].upcase)
      
      render json: get_game_data(game)
    end

    def activate
      game = get_game(params[:id].upcase)

      success = false
      alr_act = false
      message = ''
      info = 
      
      if game
        if game.active?
          alr_act = true
        else
          game.update_attributes(
            active: true
          )
        end
        success = true
      else
        message = 'Game does not exist. Please add it to the library.'
      end
      
      render json: {
        success: success,
        already_active: alr_act,
        message: message,
        info: get_game_data(game)[:info]
      }
    end
    
    def deactivate
      game = get_game(params[:id].upcase)

      success = false
      alr_dea = false
      message = ''
      info = 
      
      if game
        if !game.active?
          alr_dea = true
        else
          game.update_attributes(
            active: false
          )
        end
        success = true
      else
        message = 'Game does not exist.'
      end
      
      render json: {
        success: success,
        already_inactive: alr_dea,
        message: message,
        info: get_game_data(game)[:info]
      }
    end

    private
    
    def get_game_data(game)
      game_info = nil
      message = ''
    
      if game
        check_outs = Checkout.where(:game_id => game.barcode, :closed => false, :pax_id => get_current_pax.id)
        
        if check_outs.size > 0
          message = " is currently checked out."
        end
        
        game_info = {
          barcode: game.barcode,
          title: game.title_name,
          publisher: game.publisher_name,
          checked_out: check_outs.size > 0,
          culled: game.culled,
          active: game.active,
          section: game.section.name
        }
      end
      
      return {
        valid: game,
        info: game_info,
        status: game ? message : 'Game does not exist.'
      }
    end
    
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

end
