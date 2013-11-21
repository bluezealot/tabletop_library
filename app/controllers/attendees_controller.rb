class AttendeesController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_filter :reset_session, :only => [:index, :new, :show]
  
  def index
      @attendees = []
      col = []
      par = []
      barcode =       params[:a_id]
      first_name =    params[:first_name]
      last_name =     params[:last_name]
      handle =        params[:handle]
      if params[:commit]
          if !barcode.empty?
              col.push 'barcode'
              par.push '%' + barcode + '%'
          end
          if !first_name.empty?
              col.push 'first_name'
              par.push '%' + first_name + '%'
          end            
          if !last_name.empty?
              col.push 'last_name'
              par.push '%' + last_name + '%'
          end
          if !handle.empty?
              col.push 'handle'
              par.push '%' + handle + '%'
          end
          sql_query = col.map{|c| "lower(#{c}) like lower(?)"}.join(' or ')
          @attendees = Attendee.where(sql_query, par)#.order('title_id ASC')
      else
          @attendees = Attendee.all
      end  
  end

  def show
      @attendee = Attendee.find(params[:id])
  end

  def new
  end

  def create
      bc = params[:a_id].upcase
      if bc.empty? || !barcode_check(bc)
          flash[:alert] = 'Invalid barcode.'
          redirect_to new_attendee_path(params)
      else
          if get_attendee(bc)
              flash[:alert] = 'Attendee barcode already exists in the system.'
              redirect_to new_attendee_path(params) 
          else
              session[:a_id] = bc
              redirect_to attendees_info_path
          end
      end
  end
  
  def info_get
  end
  
  def info_post
      if params[:handle].empty?
          enforcer = false
      else
          enforcer = true
      end
      
      @attendee = Attendee.new({
          first_name: params[:first_name],
          last_name: params[:last_name],
          handle: params[:handle],
          enforcer: enforcer,
          barcode: session[:a_id]
          })
      
      if @attendee.save
          if session[:redirect] == 'checkout'
              session[:redirect] = nil
              redirect_to checkouts_game_path
          else
              session[:a_id] = nil;
              flash[:notice] = 'Attendee was successfully created.'
              redirect_to new_attendee_path
          end
      else
          flash[:alert] = 'Please fill in all fields.'
          redirect_to attendees_info_path(params)
      end
  end
  
  #checks to see if attendee exists and whether or not it has open checkouts
  #valid: always true if attendee exists
  #has_checkouts: true if more than 0 open checkouts exist
  def valid_attendee
    a_id = params[:a_id].upcase
    att = get_attendee(a_id)
    
    if att
      if open = atte_has_unclosed_co(a_id)
        count = get_open_count_for_atte(a_id)
        message = "#{att.name} has #{pluralize(count, 'game')} checked out."
      else
        message = att.name
      end
    end
    
    render :json => {
      message: att ? message : 'Attendee does not exist.',
      valid: att ? true : false,
      has_checkouts: open
      }
  end
    
end
