class AttendeesController < ApplicationController
    before_filter :reset_session, :only => [:index, :new, :show]
    
    def index
        @attendees = []
        col = []
        par = []
        barcode =       params[:barcode]
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
            redirect_to new_attendee_path(params), notice:'Invalid barcode.'
        else
            if get_attendee(bc)
                redirect_to new_attendee_path(params), notice: 'Attendee barcode already exists in the system.'
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
                redirect_to new_attendee_path, notice: 'Attendee was successfully created.'
            end
        else
            flash[:error] = 'Please fill in all fields.'
            redirect_to attendees_info_path(params)
        end
    end

=begin
    def destroy
        @attendee = Attendee.find(params[:id])
        @attendee.destroy
    end
=end 
    
end
