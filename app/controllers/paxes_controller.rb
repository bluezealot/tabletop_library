class PaxesController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show, :new, :edit]

  def index
    @paxes = Pax.all.sort_by(&:id)
  end

  def create
    pax = Pax.new({
      name: params[:name],
      location: params[:location],
      start_date: params[:start_date],
      end_date: params[:end_date]
    })
    
    set_to_current = false
    success = false
    missing_fields = []
    pax_info = {}
    
    params.each do |k, v|
      if v.nil? || v.empty?
        missing_fields << k
      end
    end

    if missing_fields.empty?
      if pax.save
        set_to_current = set_curent_pax(pax.id)
        
        pax_info = {
          id: pax.id,
          name: pax.name,
          location: pax.location,
          start_date: pax.start_date,
          end_date: pax.end_date,
          current: pax.current
        }
        
        success = true
        message = set_to_current ? '' : 'PAX Created. Unable to set to current.'
      else
        message = 'An error occurred.'
      end
    else
      message = 'Required fields are missing.'
    end
    
    render json: {
      success: success,
      current: set_to_current,
      message: message,
      missing: missing_fields,
      info: pax_info
    }
  end
  
  def update
    missing_fields = []
    success = false
    message = 'PAX updated successfully.'
    
    params.each do |k, v|
      if v.nil? || v.empty?
        missing_fields << k
      end
    end
    
    if missing_fields.empty?
      if pax = Pax.find(params[:id])
        pax.update_attributes({
          name: params[:name],
          location: params[:location],
          start_date: params[:start_date],
          end_date: params[:end_date]
        })
        success = true
      else
        message = 'PAX id does not exist.'
      end
    else
      #fields missing
      message = 'Require fields are missing.'
    end
    
    render json: {
      success: success,
      message: message,
      missing: missing_fields
    }
    
  end

  def set_current
    id = params[:id]
    success = false
    message = ''
    
    current = get_current_pax
    pax = Pax.find_by_id(id)
    
    if pax && pax.id != current.id
      success = set_curent_pax(id)
      message = success ? '' : 'Checkouts are still open under current PAX. Unable to change.'
    elsif pax && pax.id == current.id
      success = true
    else
      success = false
      message = 'Invalid PAX id.'
    end
    
    render json: {
      success: success,
      message: message
    }
  end

  private
  def set_curent_pax(id)
    current = get_current_pax
    
    if Checkout.where(:pax_id => current.id, :closed => false).count <= 0
      if current && current.id != id
          current.update_attributes({
              :current => false
          })
      end
      new_current = Pax.find_by_id(id)
      new_current.update_attributes({
          :current => true
      })
    else
      false
    end
  end

end
