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

  def create
    missing_fields = Array.new
    params.each do |k, v|
      if v.nil? || v.empty?
        missing_fields << k unless k == 'handle'
      end
    end

    enforcer = !params[:handle].empty?
    
    @attendee = Attendee.new({
        first_name: capitalize_all(params[:first_name]),
        last_name: capitalize_all(params[:last_name]),
        handle: capitalize_all(params[:handle]),
        enforcer: enforcer,
        barcode: params[:co_a_id].upcase
        })
    
    render json: {
      success: @attendee.save,
      missing: missing_fields
      }
  end
  
  # checks to see if attendee exists and whether or not it has open checkouts
  # valid: always true if attendee exists
  # has_checkouts: true if more than 0 open checkouts exist
  def valid_attendee
    a_id = params[:a_id].upcase
    att = get_attendee(a_id)
    
    if att
      if atte_has_unclosed_co(a_id)
        count = get_open_count_for_atte(a_id)
        message = "#{att.name} has #{pluralize(count, 'game')} checked out."
      else
        message = att.name
      end
    end
    
    render :json => {
      message: att ? message : 'Attendee does not exist.',
      valid: att ? true : false,
      coCount: count
      }
  end
  
end
